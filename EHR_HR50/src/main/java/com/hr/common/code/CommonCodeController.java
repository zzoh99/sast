package com.hr.common.code;

import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 공통 코드관리
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/CommonCode.do", method=RequestMethod.POST )
public class CommonCodeController {

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("CommonCodeRecService")
	private CommonCodeRecService commonCodeRecService;

	/**
	 * 공통코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCommonCodeList", method = RequestMethod.POST )
	public ModelAndView getCommonCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
//		paramMap.put("name", 	session.getAttribute("ssnName"));
//		paramMap.put("foreignYn",session.getAttribute("ssnForeignYn"));
//		paramMap.put("birYmd", 	session.getAttribute("ssnBirYmd"));

//		if(paramMap.containsKey("inCode") && paramMap.get("inCode") != null && !paramMap.get("inCode").equals("")){
//			paramMap.put("inCode", (paramMap.get("inCode")+"").split(","));
//		}else if(paramMap.containsKey("notInCode") && paramMap.get("notInCode") != null && !paramMap.get("notInCode").equals("")){
//			paramMap.put("notInCode", (paramMap.get("notInCode")+"").split(","));
//		}else if(paramMap.containsKey("grpCd") && paramMap.get("grpCd") != null && !paramMap.get("grpCd").equals("")){
//			paramMap.put("grpCd", (paramMap.get("grpCd")+"").split(","));
//		}

		getBaseYmd(paramMap);

		List<?> result = commonCodeService.getCommonCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getCommonCodeLists", method = RequestMethod.POST )
	public ModelAndView getCommonCodeLists(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		paramMap.put("grpCd", (paramMap.get("grpCd") + "").split(","));

		getBaseYmd(paramMap);

		List<?> result = commonCodeService.getCommonCodeLists(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	private void getBaseYmd(@RequestParam Map<String, Object> paramMap) {
		if (paramMap.containsKey("baseSYmd") && paramMap.get("baseSYmd") != null && !"".equals(paramMap.get("baseSYmd"))) {
			paramMap.put("baseSYmd", replaceBaseYmd(paramMap.get("baseSYmd").toString()));
		} else {
			paramMap.put("baseSYmd", getToday());
		}

		if (paramMap.containsKey("baseEYmd") && paramMap.get("baseEYmd") != null && !"".equals(paramMap.get("baseEYmd"))) {
			paramMap.put("baseEYmd", replaceBaseYmd(paramMap.get("baseEYmd").toString()));
		}
	}

	private String replaceBaseYmd(String baseYmd) {
		return baseYmd.replaceAll("-", "");
	}

	private String getToday() {
		Date today = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		return dateFormat.format(today);
	}

	/**
	 * 공통 COMBO 코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCommonNSCodeList", method = RequestMethod.POST )
	public ModelAndView getCommonNSCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));
		paramMap.put("ssnPreSrchYn", 	session.getAttribute("ssnPreSrchYn"));


//		if(paramMap.containsKey("applStatusNotCd") && paramMap.get("applStatusNotCd") != null){
//			paramMap.put("applStatusNotCd",(paramMap.get("applStatusNotCd")+"").split(","));
//		} else if (paramMap.containsKey("gubun") && paramMap.get("gubun") != null){
//			paramMap.put("gubun",(paramMap.get("gubun")+"").split(","));
//		} else if (paramMap.containsKey("searchAppTypeCd") && paramMap.get("searchAppTypeCd") != null){
//			paramMap.put("searchAppTypeCd",(paramMap.get("searchAppTypeCd")+"").split(","));
//		} else if (paramMap.containsKey("searchDAppTypeCd") && paramMap.get("searchDAppTypeCd") != null){
//			paramMap.put("searchDAppTypeCd",(paramMap.get("searchDAppTypeCd")+"").split(","));
//		} else if (paramMap.containsKey("searchAppStepCds") && paramMap.get("searchAppStepCds") != null){
//			paramMap.put("searchAppStepCds",(paramMap.get("searchAppStepCds")+"").split(","));
//		} else if (paramMap.containsKey("searchRunType") && paramMap.get("searchRunType") != null){
//			paramMap.put("searchRunType",(paramMap.get("searchRunType")+"").split(","));
//		} else if (paramMap.containsKey("searchRetPayCd") && paramMap.get("searchRetPayCd") != null){
//			paramMap.put("searchRetPayCd",(paramMap.get("searchRetPayCd")+"").split(","));
//		} else if (paramMap.containsKey("inOrdType") && paramMap.get("inOrdType") != null){
//			paramMap.put("inOrdType",(paramMap.get("inOrdType")+"").split(","));
//		} else if (paramMap.containsKey("notInOrdType") && paramMap.get("notInOrdType") != null){
//			paramMap.put("notInOrdType",(paramMap.get("notInOrdType")+"").split(","));
//		} else if (paramMap.containsKey("inOrdType") && paramMap.get("inOrdType") != null){
//			paramMap.put("inOrdType",(paramMap.get("inOrdType")+"").split(","));
//		} else if (paramMap.containsKey("ordTypeCd") && paramMap.get("ordTypeCd") != null){
//			paramMap.put("ordTypeCd",(paramMap.get("ordTypeCd")+"").split(","));
//		} else if (paramMap.containsKey("grpCd") && paramMap.get("grpCd") != null){
//			paramMap.put("grpCd",(paramMap.get("grpCd")+"").split(","));
//		}

		List<?> result = commonCodeService.getCommonNSCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}


	/*
	 * 마지막 일자 반환
	 */
	@RequestMapping(params="cmd=getLastDate", method = RequestMethod.POST )
	public ModelAndView getLastDate(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		//DateUtil.getLastDateOfMonth ("2010-11-20")=2010-11-30

		String lastDay = DateUtil.getLastDateOfMonth(paramMap.get("ymd").toString());

		Map<String, String> map = new HashMap<String, String>();

		map.put("lastDay", lastDay);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);

		return mv;
	}

	/**
	 * 신청서 종류 COMBO 코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAddlCodeList", method = RequestMethod.POST )
	public ModelAndView getAddlCodeList(
				HttpSession session,
				@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> result = commonCodeService.getAddlCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 종류 (근로시간 단축) COMBO 코드 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWorkingTypeCodeList", method = RequestMethod.POST )
	public ModelAndView getWorkingTypeCodeList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> result = commonCodeService.getWorkingTypeCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 날짜(주) 계산
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCommonWeek", method = RequestMethod.POST )
	public ModelAndView getCommonWeek(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = commonCodeService.getCommonWeek(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("chkWeek", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 가족관계 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFamilyRelations", method = RequestMethod.POST )
	public ModelAndView getFamilyRelations(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = commonCodeService.getFamilyRelations(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("familyRelation", result);
		Log.DebugEnd();
		return mv;
	}

	//채용DB용 start - 1
	/**
	 * 채용DB - 공통코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=commonCodeListRec", method = RequestMethod.POST )
	public ModelAndView getCommonCodeListRec(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> result = commonCodeRecService.getCommonCodeListRec(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 채용DB 공통 COMBO 코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCommonNSCodeListRec", method = RequestMethod.POST )
	public ModelAndView getCommonNSCodeListRec(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

		List<?> result = commonCodeRecService.getCommonNSCodeListRec(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}
	//채용DB용 end - 1

}