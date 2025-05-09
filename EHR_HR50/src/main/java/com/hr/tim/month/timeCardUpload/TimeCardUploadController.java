package com.hr.tim.month.timeCardUpload;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * TimeCard업로드 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@EnableAsync
@RequestMapping(value="/TimeCardUpload.do", method=RequestMethod.POST )
public class TimeCardUploadController extends ComController {
	/**
	 * TimeCard업로드 서비스
	 */
	@Inject
	@Named("TimeCardUploadService")
	private TimeCardUploadService timeCardUploadService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * TimeCard업로드 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTimeCardUpload", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTimeCardUpload() throws Exception {
		return "tim/month/timeCardUpload/timeCardUpload";
	}
	
	
	/**
	 * TimeCard업로드 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimeCardUploadList", method = RequestMethod.POST )
	public ModelAndView getTimeCardUploadList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	

	
	/**
	 * TimeCard업로드 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeCardUpload", method = RequestMethod.POST )
	public ModelAndView saveTimeCardUpload(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  


		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = timeCardUploadService.saveTimeCardUpload(convertMap);
			if(resultCnt > 0){
				message="저장 되었습니다."; 
			} else{ 
				message="저장된 내용이 없습니다."; 
			}
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

	/**
	 * TimeCard업로드 후 일근무 갱신 
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcTimeCardUpload", method = RequestMethod.POST )
	public ModelAndView prcTimeCardUpload(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "처리 되었습니다.";
		int resultCnt = 1;
		try{

			Map<?, ?> pMap 		= request.getParameterMap();
			List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
			String[] sabuns = (String[]) pMap.get("sabun");
			for( int i=0; i<sabuns.length; i++){
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("sabun", sabuns[i]);
				list.add(map);
			}
			paramMap.put("sabunList", list);
			
			//일근무갱신
			Log.Debug("prcTimeCardUpload======== SSSSSSSSSSSSS =========>");
			timeCardUploadService.prcTimeCardUpload(paramMap);
			Log.Debug("prcTimeCardUpload======== eeeeeeeeeeeeeeeeee =========>");
			
		}catch(Exception e){
			resultCnt = -1; message="처리에 실패하였습니다.";
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
