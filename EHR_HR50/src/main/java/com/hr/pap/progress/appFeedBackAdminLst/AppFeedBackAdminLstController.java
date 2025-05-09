package com.hr.pap.progress.appFeedBackAdminLst;
import java.util.ArrayList;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 평가결과피드백 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/AppFeedBackAdminLst.do", method=RequestMethod.POST )
public class AppFeedBackAdminLstController {
	/**
	 * 평가결과피드백 서비스
	 */
	@Inject
	@Named("AppFeedBackAdminLstService")
	private AppFeedBackAdminLstService appFeedBackAdminLstService;
	/**
	 * 평가결과피드백 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackAdminLst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackAdminLst() throws Exception {
		return "pap/progress/appFeedBackAdminLst/appFeedBackAdminLst";
	}
	/**
	 * 평가결과피드백 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedBackAdminLst2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackAdminLst2() throws Exception {
		return "appFeedBackAdminLst/appFeedBackAdminLst";
	}
	 /** 평가의견 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppFeedbackLstPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppFeedBackAdminLstPopup() throws Exception {
		return "pap/progress/appFeedBackAdminLst/appFeedBackAdminLstPopup";
	}
	/**
	 * 평가결과피드백 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppFeedBackAdminLstList", method = RequestMethod.POST )
	public ModelAndView getAppFeedBackAdminLstList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = appFeedBackAdminLstService.getAppFeedBackAdminLstList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	* 평가결과팝업 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppFeedBackAdminLstPopupList", method = RequestMethod.POST )
	public ModelAndView getAppFeedBackAdminLstPopupList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
      //  paramMap.put("searchSabun", session.getAttribute("searchSabun"));
	//	paramMap.put("searchYear", session.getAttribute("searchYear"));
		try{
			list = appFeedBackAdminLstService.getAppFeedBackAdminLstPopupList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 평가결과피드백 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppFeedBackAdminLstMap", method = RequestMethod.POST )
	public ModelAndView getAppFeedBackAdminLstMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = appFeedBackAdminLstService.getAppFeedBackAdminLstMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 평가결과피드백 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppFeedBackAdminLst", method = RequestMethod.POST )
	public ModelAndView saveAppFeedBackAdminLst(
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
			resultCnt =appFeedBackAdminLstService.saveAppFeedBackAdminLst(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
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
