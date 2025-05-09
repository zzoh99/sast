package com.hr.eis.keywordSearch;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
/**
 * 키워드검색 Controller 
 * 
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/EmpKeywordSearch.do", method=RequestMethod.POST )
public class EmpKeywordSearchController {
	/**
	 * 키워드검색 서비스
	 */
	@Inject
	@Named("EmpKeywordSearchService")
	private EmpKeywordSearchService keywordSearchService;

	@Autowired
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 * 키워드검색 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpKeywordSearch", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpKeywordSearch() throws Exception {
		return "hrm/other/keywordSearch/keywordSearch";
	}
	
	/**
	 * 키워드검색 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpKeywordSearchList", method = RequestMethod.POST )
	public ModelAndView getEmpKeywordSearchList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		List<?> list  = new ArrayList<Object>();
		String Code = "";
		String Message = "";
		
		// 프로시저실행
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		Map<?, ?> map  = keywordSearchService.prcEmpKeywordSearch(paramMap);

		if (map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));

			if (map.get("sqlcode") != null) {
				Code = map.get("sqlcode").toString();
			}
			if (map.get("sqlerrm") != null) {
				Message = map.get("sqlerrm").toString();
			}
		}
		
		// 조회
		if ( Code == null || "".equals(Code) ) {
			try{
				list = keywordSearchService.getEmpKeywordSearchList(paramMap);
			}catch(Exception e){
				Message="조회에 실패 하였습니다.";
			}
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Code", Code);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
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
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);

			if (encryptKey != null) {
				String enterCd = String.valueOf(paramMap.get("enterCd"));
				String sabun = String.valueOf(paramMap.get("sabun"));
				mapResult.put("rk", CryptoUtil.encrypt(encryptKey, enterCd + "#" + sabun));
				//mapResult.put("rp", CryptoUtil.encrypt(encryptKey, makeRp()));
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


	@RequestMapping(params="cmd=getEmpCardEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEmpCardEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();

		//String enterCd = paramMap.get("enterCd");

		if(paramMap != null && paramMap.containsKey("rk") && paramMap.get("rk") != null) {
			String ssnEnterCd = session.getAttribute("ssnEnterCd") + "";
			String ssnSabun = session.getAttribute("ssnSabun") + "";
			String ssnLocaleCd = session.getAttribute("ssnLocaleCd") + "";

			//반드시 암호화 한 곳의 prgPackage 를 맞춰야한다.
			String encryptKey = securityMgrService.getEncryptKey(ssnEnterCd, SecurityMgrService.HRM);
			//rdKey의 룰은 없다. 원하는 값으로 보내고 받아서 푼다 공통은 없다.
			String empKey = CryptoUtil.decrypt(encryptKey, paramMap.get("rk")+"");
			String[] empKeys = empKey.split("#");

			String securityKey = request.getAttribute("securityKey")+"";

			String mrdPath = "/hrm/empcard/PersonInfoCardType1_HR.mrd";
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
}
