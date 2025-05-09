package com.hr.pap.intern.internApp1st2nd;

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
 * 수습1차,2차평가 Controller 
 * 
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/InternApp1st2nd.do", method=RequestMethod.POST )
public class InternApp1st2ndController extends ComController {

	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("InternApp1st2ndService")
	private InternApp1st2ndService internApp1st2ndService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 수습1차,2차평가 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternApp1st2nd", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView internApp1st2nd(
		HttpSession session,  HttpServletRequest request, 
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("pap/intern/internApp1st2nd/internApp1st2nd");
		mv.addObject("map", paramMap);
		
		return mv;
	}
	
	/**
	 * 수습1차,2차평가 팝업 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternApp1st2ndPopMap", method = RequestMethod.POST )
	public ModelAndView getInternApp1st2ndPopMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		Map<?, ?> map = internApp1st2ndService.getInternApp1st2ndPopMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 수습1차,2차평가 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveInternApp1st2ndPop", method = RequestMethod.POST )
	public ModelAndView saveInternApp1st2ndPop(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = internApp1st2ndService.saveInternApp1st2ndPop(convertMap);
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
	
	/**
	 * 수습1차,2차평가 저장(합계)
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcInternApp1st2ndPopTotal", method = RequestMethod.POST )
	public ModelAndView prcInternApp1st2ndPopTotal(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		Map map  = internApp1st2ndService.prcInternApp1st2ndPopTotal(paramMap);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(map != null) {
			Log.Debug("obj : "+map);
			Log.Debug("sqlcode : "+map.get("sqlcode"));
			Log.Debug("sqlerrm : "+map.get("sqlerrm"));
			
			if (map.get("sqlcode") != null) {
				resultMap.put("Code", map.get("sqlcode").toString());
			}
			if (map.get("sqlerrm") != null) {
				resultMap.put("Message", map.get("sqlerrm").toString());
			}
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 수습1차,2차평가 저장(의견)
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveInternApp1st2ndPopMemo", method = RequestMethod.POST )
	public ModelAndView saveInternApp1st2ndPopMemo(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = internApp1st2ndService.saveInternApp1st2ndPopMemo(paramMap);
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
	
	/**
	 * 수습1차,2차평가 평가완료
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveInternApp1st2ndPopAppYn", method = RequestMethod.POST )
	public ModelAndView saveInternApp1st2ndPopAppYn(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = internApp1st2ndService.saveInternApp1st2ndPopAppYn(paramMap);
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

	/**
	 * 수습1차,2차평가 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternApp1st2ndList", method = RequestMethod.POST )
	public ModelAndView getInternApp1st2ndList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	/**
	 * 수습평가팝업 Popup View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternApp1st2ndPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternApp1st2ndPop() throws Exception {
		return "pap/intern/internApp1st2nd/internApp1st2ndPop";
	}

	/**
	 * 수습평가팝업 Popup 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternApp1st2ndPopList", method = RequestMethod.POST )
	public ModelAndView getInternApp1st2ndPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
