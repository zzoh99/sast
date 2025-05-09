package com.hr.pap.progress.mltsrcRst;
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
 * 다면평가결과조회 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/MltsrcRst.do", method=RequestMethod.POST )
public class MltsrcRstController {
	/**
	 * 다면평가결과조회 서비스
	 */
	@Inject
	@Named("MltsrcRstService")
	private MltsrcRstService mltsrcRstService;
	/**
	 * 다면평가결과조회 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMltsrcRst", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMltsrcRst() throws Exception {
		return "pap/progress/mltsrcRst/mltsrcRst";
	}
	/**
	 * 다면평가결과조회 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=veiwMltsrcRstDtlPopup", method = RequestMethod.POST )
	public String veiwMltsrcRstDtlPopup() throws Exception {
		return "pap/progress/mltsrcRst/mltsrcRstDtlPopup";
	}
	/**
	 * 다면평가결과조회 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMltsrcRstList", method = RequestMethod.POST )
	public ModelAndView getMltsrcRstList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = mltsrcRstService.getMltsrcRstList(paramMap);
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
	 * 다면평가결과조회 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMltsrcRstMap", method = RequestMethod.POST )
	public ModelAndView getMltsrcRstMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = mltsrcRstService.getMltsrcRstMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 다면평가결과조회 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMltsrcRst", method = RequestMethod.POST )
	public ModelAndView saveMltsrcRst(
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
			resultCnt =mltsrcRstService.saveMltsrcRst(convertMap);
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
