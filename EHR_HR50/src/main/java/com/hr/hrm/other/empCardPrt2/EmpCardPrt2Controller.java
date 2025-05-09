package com.hr.hrm.other.empCardPrt2;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import org.apache.commons.lang3.StringUtils;
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
 * 인사카드출력 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/EmpCardPrt2.do", method=RequestMethod.POST )
public class EmpCardPrt2Controller {
	/**
	 * 인사카드출력 서비스
	 */
	@Inject
	@Named("EmpCardPrt2Service")
	private EmpCardPrt2Service empCardPrt2Service;

	/*AuthTable */
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * viewEmpCardPrt2 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpCardPrt2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpCardPrt2() throws Exception {
		return "hrm/other/empCardPrt2/empCardPrt2";
	}

	/**
	 * 인사카드출력 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpCardPrt2AuthList", method = RequestMethod.POST )
	public ModelAndView getEmpCardPrt2AuthList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		/*AuthTable */
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));
		paramMap.put("authSqlID",		"TORG101");

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		if(query != null) {
			Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query",query.get("query"));
		}

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = empCardPrt2Service.getEmpCardPrt2AuthList(paramMap);
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
	 * getEmpCardPrt2List 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpCardPrt2List", method = RequestMethod.POST )
	public ModelAndView getEmpCardPrt2List(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		/*AuthTable */
		paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", 	session.getAttribute("ssnBaseDate"));
		paramMap.put("authSqlID",		"TORG101");

		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		if(query != null) {
			Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query",query.get("query"));
		}

		//List<?> list  = new ArrayList<Object>();
		List<Map<String, Object>>  list = null;
		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";

		try{
			list =  (List<Map<String, Object>>)  empCardPrt2Service.getEmpCardPrt2List(paramMap);

	        String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_EMPCARD);

            if (encryptKey != null) {
                for (Map<String, Object> map  : list) {
                    map.put("rk", CryptoUtil.encrypt(encryptKey, map.get("enterCd") + "#" + map.get("sabun")));
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
	 * RD 데이터 암호화
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		//String enterCd = paramMap.get("enterCd");

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_EMPCARD);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.

			String strParam = paramMap.get("rk").toString();


			strParam = strParam.replaceAll("[\\[\\]]", "");
			String[] splited = strParam.split(",") ;

            StringBuilder empKeys = new StringBuilder();
            StringBuilder empSabunKeys = new StringBuilder();

			if (StringUtils.isNoneEmpty(splited)) {
				for (String str : splited) {
					String strDecrypt = CryptoUtil.decrypt(encryptKey, str.trim() + "");
					String[] keys = strDecrypt.split("#");

					//('회사코드','사번')
					empKeys.append(",('").append(keys[0]).append("','").append(keys[1]).append("')");
					//,사번
					empSabunKeys.append(",").append(keys[1]);
					//첫문째문자제거
					empSabunKeys.deleteCharAt(0);
				}
			}
			String securityKey = request.getAttribute("securityKey")+"";

			String itemType = paramMap.get("itemType")+"";
			String mrdPath = itemType.equals("1") ? "/hrm/empcard/PersonInfoCardType1_HR.mrd" : "/hrm/empcard/PersonInfoCardType2_HR.mrd";




			String param = "/rp [" +  empKeys + "]"
					+ " [" + imageBaseUrl + "] "
					+ " [" + paramMap.get("maskingYn") + "]" // 마스킹 여부
					+ " [Y]" // hrbasic1
					+ " [Y]" // hrbasic2
					+ " [Y]"
					+ " [Y]"
					+ " [" +  paramMap.get("hrAppt") +"]" // 전체발령표시여부
					+ " [" + ssnEnterCd + "]"
					+ " ['" + ssnSabun + "']"
					+ " [" + ssnLocaleCd + "]"
					+ " ['" + empSabunKeys + "']"  //사번
	                + " [" +  paramMap.get("rdViewType6") +"]" // 평가
                    + " [" +  paramMap.get("rdViewType") +"]" // 타부서발령여부
                    + " [" +  paramMap.get("rdViewType3") +"]" // 연락처
                    + " [" +  paramMap.get("rdViewType4") +"]" // 병역
                    + " [" +  paramMap.get("rdViewType5") +"]" // 학력
                    + " [" +  paramMap.get("rdViewType7") +"]" // 경력
                    + " [" +  paramMap.get("rdViewType8") +"]" // 포상
                    + " [" +  paramMap.get("rdViewType9") +"]" // 징계
                    + " [" +  paramMap.get("rdViewType10") +"]" // 자격
                    + " [" +  paramMap.get("rdViewType11") +"]" // 어학
                    + " [" +  paramMap.get("rdViewType12") +"]" // 가족
                    + " [" +  paramMap.get("rdViewType13") +"]" // 발령
                    + " [" +  paramMap.get("rdViewType14") +"]" // 직무
					+ " [" + securityKey + "] "
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

	/**
	 * rk 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpCardPrtRk", method = RequestMethod.POST )
	public ModelAndView getEmpCardPrtRk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String Message = "";
		String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
		Map<String, Object> mapResult = new HashMap<>();

		try{
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM_EMPCARD);

			if (encryptKey != null) {
				mapResult.put("rk", CryptoUtil.encrypt(encryptKey, paramMap.get("enterCd") + "#" + paramMap.get("sabun")));

			}

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", mapResult);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
