package com.hr.pap.evaluation.appSelfReportApp;
import java.io.Serializable;
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
 * 자기신고서승인 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/AppSelfReportApp.do", method=RequestMethod.POST )
public class AppSelfReportAppController {
	/**
	 * 자기신고서승인 서비스
	 */
	@Inject
	@Named("AppSelfReportAppService")
	private AppSelfReportAppService appSelfReportAppService;
	/**
	 * 자기신고서승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppSelfReportApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppSelfReportApp() throws Exception {
		return "pap/evaluation/appSelfReportApp/appSelfReportApp";
	}
	/**
	 * 자기신고서승인 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppSelfReportApp2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppSelfReportApp2() throws Exception {
		return "appSelfReportApp/appSelfReportApp";
	}
	/**
	 * 자기신고서승인 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppSelfReportAppList", method = RequestMethod.POST )
	public ModelAndView getAppSelfReportAppList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			HashMap<String, String> mapElement = null;
			List<?> titleList = new ArrayList<Object>();
			List<Serializable> titles = new ArrayList<Serializable>();

			titleList = appSelfReportAppService.getAppSelfReportAppColList(paramMap);

			for(int i = 0 ; i < titleList.size() ; i++){
				mapElement = new HashMap<String, String>();
				Map<String, String> map = (Map)titleList.get(i);

				mapElement.put("itemCd", String.valueOf(map.get("itemCd")));
				mapElement.put("saveNm", map.get("saveNm").toString());
				titles.add(mapElement);
			}
			paramMap.put("titles", titles);

			list = appSelfReportAppService.getAppSelfReportAppList(paramMap);
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
	 * 자기신고서승인 -컬럼정보- 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppSelfReportAppColList", method = RequestMethod.POST )
	public ModelAndView getAppSelfReportAppColList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = appSelfReportAppService.getAppSelfReportAppColList(paramMap);
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
	 * 자기신고서승인 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppSelfReportAppMap", method = RequestMethod.POST )
	public ModelAndView getAppSelfReportAppMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = appSelfReportAppService.getAppSelfReportAppMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 자기신고서승인 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppSelfReportApp", method = RequestMethod.POST )
	public ModelAndView saveAppSelfReportApp(
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
			resultCnt =appSelfReportAppService.saveAppSelfReportApp(convertMap);
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
