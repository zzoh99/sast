package com.hr.sys.pwrSrch.pwrSrchMgrApp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import com.hr.common.util.ParamUtils;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;


/**
 * 조건검색관리(일반)
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/PwrSrchMgrApp.do", method=RequestMethod.POST )
public class PwrSrchMgrAppController {

	@Inject
	@Named("PwrSrchMgrAppService")
	private PwrSrchMgrAppService pwrSrchMgrAppService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;


	/**
	 * 조건검색관리(일반) 화면
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
//	@RequestMapping(params="cmd=viewPwrSrchMgrApp", method = {RequestMethod.POST, RequestMethod.GET} )
//	public String viewPwrSrchMgrApp(
//			HttpSession session, HttpServletRequest request,
//			@RequestParam Map<String, Object> paramMap) throws Exception {
//		Log.Debug("PwrSrchMgrAppController.viewPwrSrchMgrApp");
//		return "sys/pwrSrch/pwrSrchMgrApp/pwrSrchMgrApp";
//	}


	@RequestMapping(params="cmd=viewPwrSrchMgrApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewPwrSrchMgrApp(
				HttpSession session, HttpServletRequest request,
				@RequestParam Map<String, Object> paramMap) throws Exception {

		//////////
		Map<String, Object> urlParam = new HashMap<String, Object>();
		String surl =paramMap.get("murl").toString();
		String skey = session.getAttribute("ssnEncodedKey").toString();

		String subGrpCd = null;
		String subGrpNm = null;
		urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

		//////////
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchMgrApp/pwrSrchMgrApp");
		mv.addObject("result", urlParam);
		return mv;

	}

	/**
	 * 조건검색관리(일반) 조회
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchMgrAppList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchMgrAppList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		List<?> result = pwrSrchMgrAppService.getPwrSrchMgrAppList(paramMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 조건검색관리(일반) 저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePwrSrchMgr", method = RequestMethod.POST )
	public ModelAndView savePwrSrchMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		//List result = sysPwrSchViewService.getPwrSch(paramMap);
		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해
		// 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		String getParamNames = "sNo,sDelete,sStatus,dbItemDesc,searchSeq,searchType,searchDesc,bizCd,viewCd,viewDesc,commonUseYn,owner,chkDate,viewNm,copySearchSeq";
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		convertMap.put("sabun", session.getAttribute("ssnSabun"));
		convertMap.put("enterCd", session.getAttribute("ssnEnterCd"));

		int result = pwrSrchMgrAppService.savePwrSrchMgrApp(convertMap);
		String message = "";
		if(result > 0){ message="저장되었습니다."; }
		else{ message="저장 실퍠 하였습니다."; }

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", result);
		resultMap.put("Message", message);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);

		Log.Debug("Result Message : "+mv );
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 조건검색관리(일반) BIZ 팝업 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchMgrBizPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchMgrBizPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchMgrAppController.pwrSrchMgrBizPopup");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchMgr/pwrSrchMgrBizPopup");
		return mv;
	}

	/**
	 * 조건검색관리(일반) ADMIN 팝업 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchMgrAdminPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchMgrAdminPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchMgrAppController.pwrSrchMgrAdminPopup");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchMgr/pwrSrchMgrAdminPopup");
		return mv;
	}

	/**
	 * 조건검색관리(일반)  SuiTableMatch 팝업 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=pwrSrchMgrSuiTableMatchPopup", method = RequestMethod.POST )
	public ModelAndView pwrSrchMgrSuitableMatchPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("PwrSrchMgrAppController.pwrSrchMgrSuitableMatchPopup");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/pwrSrch/pwrSrchMgr/pwrSrchMgrSuitableMatchPopup");
		return mv;
	}
}
