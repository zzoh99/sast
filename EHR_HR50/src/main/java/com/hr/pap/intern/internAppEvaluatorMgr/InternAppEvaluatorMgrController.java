package com.hr.pap.intern.internAppEvaluatorMgr;
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
@RequestMapping(value="/InternAppEvaluatorMgr.do", method=RequestMethod.POST )
public class InternAppEvaluatorMgrController extends ComController {
	/**
	 * 사용할 서비스 선언
	 */
	@Inject
	@Named("InternAppEvaluatorMgrService")
	private InternAppEvaluatorMgrService InternAppEvaluatorMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 수습평가대상자관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternAppEvaluatorMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternAppEvaluatorMgr() throws Exception {
		return "pap/intern/internAppEvaluatorMgr/internAppEvaluatorMgr";
	}
	
	/**
	 * 수습평가대상자 입력 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternAppEvaluatorMgrAppSabunPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternAppEvaluatorMgrAppSabunPop() throws Exception {
		return "pap/intern/internAppEvaluatorMgr/internAppEvaluatorMgrAppSabunPop";
	}
	
	/**
	 * 수습평가대상자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternAppEvaluatorMgrList", method = RequestMethod.POST )
	public ModelAndView getInternAppEvaluatorMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	

	/**
	 * 수습평가대상자관리 저장(상단 저장)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveInternAppEvaluatorMgr", method = RequestMethod.POST )
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
			resultCnt = InternAppEvaluatorMgrService.saveInternAppEvaluatorMgr(convertMap);
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
	 * 평가자 - 입력 피평가자 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternAppEvaluatorMgrListPop", method = RequestMethod.POST )
	public ModelAndView getInternAppEvaluatorMgrListPop(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
