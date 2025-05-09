package com.hr.pap.intern.internAppEvalSchMgr;
import java.util.HashMap;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 수습평가대상자관리 Controller
 *
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/InternAppEvalSchMgr.do", method=RequestMethod.POST )
public class InternAppEvalSchMgrController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("InternAppEvalSchMgrService")
	private InternAppEvalSchMgrService internAppEvalSchMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 수습평가일정관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternAppEvalSchMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternAppEvalSchMgr() throws Exception {
		return "pap/intern/internAppEvalSchMgr/internAppEvalSchMgr";
	}
	
	/**
	 * 수습평가일정관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternAppEvalSchMgrList", method = RequestMethod.POST )
	public ModelAndView getAppEvaluateeMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 수습평가일정관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternAppEvalSchMgrList2", method = RequestMethod.POST )
	public ModelAndView getAppEvaluateeMgrList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 수습평가일정관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveInternAppEvalSchMgr", method = RequestMethod.POST )
	public ModelAndView saveAppEvaluateeMgr1(
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
			resultCnt = internAppEvalSchMgrService.saveInternAppEvalSchMgr(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			e.printStackTrace();
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
	 * 평가일정생성 생성  - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcInternAppEvalSchMgrCreate", method = RequestMethod.POST )
	public ModelAndView prcInternAppEvalSchMgrCreate(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
	
	/**
	 * 평가초기화 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcInternAppEvalSchMgrClear", method = RequestMethod.POST )
	public ModelAndView prcInternAppEvalSchMgrClear(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return execPrc(session, request, paramMap);
	}
}
