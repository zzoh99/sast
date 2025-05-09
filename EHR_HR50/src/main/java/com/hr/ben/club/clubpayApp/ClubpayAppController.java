package com.hr.ben.club.clubpayApp;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * 동호회 지원금 Controller
 *
 *
 */
@Controller
@RequestMapping(value="/ClubpayApp.do", method=RequestMethod.POST )
public class ClubpayAppController extends ComController{
	/**
	 * 동호회 지원금 서비스
	 */
	@Inject
	@Named("ClubpayAppService")
	private ClubpayAppService clubpayAppService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 동호회 지원금 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewClubpayApp",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewClubpayAppApp() throws Exception {
		return "ben/club/clubpayApp/clubpayApp";
	}

	/**
	 * 동호회 지원금 내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubpayAppList", method = RequestMethod.POST )
	public ModelAndView getClubpayAppList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 동호회 지원금 기간 체크
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getClubpayAppDateChk", method = RequestMethod.POST )
	public ModelAndView getClubpayAppDateChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 동호회 지원금 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteClubpayApp", method = RequestMethod.POST )
	public ModelAndView deleteClubpayApp(
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
			resultCnt =clubpayAppService.deleteClubpayApp(convertMap);
			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");}
			else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");}
		}catch(Exception e){
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");;
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
}
