package com.hr.org.organization.orgPersonStaList;

import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * orgPersonStaList Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/OrgPersonStaList.do", method=RequestMethod.POST )
public class OrgPersonStaListController {
	/**
	 * orgPersonStaList 서비스
	 */
	@Inject
	@Named("OrgPersonStaListService")
	private OrgPersonStaListService orgPersonStaListService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * orgPersonStaList View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgPersonStaList", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgPersonStaList() throws Exception {
		return "org/organization/orgPersonStaList/orgPersonStaList";
	}

	/**
	 * orgPersonStaList(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgPersonStaListPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgPersonStaListPop() throws Exception {
		return "org/organization/orgPersonStaList/orgPersonStaListPop";
	}

	/**
	 * orgPersonStaList 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgPersonStaListList", method = RequestMethod.POST )
	public ModelAndView getOrgPersonStaListList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<Map<String, Object>> list  = new ArrayList<>();
		String Message = "";
		try{
			list = (List<Map<String, Object>>) orgPersonStaListService.getOrgPersonStaListList(paramMap);

			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_EMPCARD);

			if (encryptKey != null) {
				for (Map<String, Object> empMap : list) {
					empMap.put("rk", CryptoUtil.encrypt(encryptKey, empMap.get("enterCd") + "#" + empMap.get("sabun")));
				}
			}
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * orgPersonStaList 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgPersonStaList", method = RequestMethod.POST )
	public ModelAndView saveOrgPersonStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =orgPersonStaListService.saveOrgPersonStaList(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * orgPersonStaList 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgPersonStaListMap", method = RequestMethod.POST )
	public ModelAndView getOrgPersonStaListMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = orgPersonStaListService.getOrgPersonStaListMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
	
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_EMPCARD);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
			String empKey = CryptoUtil.decrypt(encryptKey, paramMap.get("rk")+"");
			String[] empKeys = empKey.split("#");

			String securityKey = request.getAttribute("securityKey")+"";

			String mrdPath = "/hrm/empcard/PersonInfoCardType2_HR.mrd";
			String param = "/rp [ ,('" + empKeys[0] + "','" + empKeys[1] +"') ]"
					+ " [" + imageBaseUrl + "] "
					+ " [Y]" // 마스킹 여부
					+ " [Y]" // hrbasic1
					+ " [Y]" // hrbasic2
					+ " [Y]" // 발령사항
					+ " [Y]" // 교육사항
					+ " [Y]" // 전체발령표시여부
					+ " [" + ssnEnterCd + "]"
					+ " ['" + ssnSabun + "']"
					+ " [" + ssnLocaleCd + "]"
					+ " ['," + empKeys[1] + "']"
					+ " [Y]" // 평가
					+ " [Y]" // 타부서발령여부
					+ " [Y]" // 연락처
					+ " [Y]" // 병역
					+ " [Y]" // 학력
					+ " [Y]" // 경력
					+ " [Y]" // 포상
					+ " [Y]" // 징계
					+ " [Y]" // 자격
					+ " [Y]" // 어학
					+ " [Y]" // 가족
					+ " [Y]" // 발령
					+ " [Y]" // 경력
					+ " [ " + securityKey + " ] "
					+ " /rv securityKey[" + securityKey + "] /rloadimageopt [1]"
					;


			ModelAndView mv = new ModelAndView();
			mv.setViewName("jsonView");
			try {
				mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
				mv.addObject("Message", "");
			} catch (Exception e) {
				mv.addObject("Message", "암호화에 실패했습니다.");
			}

			Log.DebugEnd();
			return mv;
		}
		return null;
	}
}
