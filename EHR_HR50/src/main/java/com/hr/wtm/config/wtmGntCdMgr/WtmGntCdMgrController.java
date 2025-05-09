package com.hr.wtm.config.wtmGntCdMgr;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 근태코드관리 Controller
 */
@Controller
@RequestMapping(value="/WtmGntCdMgr.do", method=RequestMethod.POST )
public class WtmGntCdMgrController extends ComController {

	/**
	 * 근태코드관리 서비스
	 */
	@Autowired
	private WtmGntCdMgrService wtmGntCdMgrService;

	/**
	 * 근태코드관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmGntCdMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmGntCdMgr() throws Exception {
		return "wtm/config/wtmGntCdMgr/wtmGntCdMgr";
	}

	@RequestMapping(params="cmd=viewWtmHolidayDeleteLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmHolidayDeleteLayer() throws Exception {
		return "wtm/config/wtmHolidayMgr/wtmHolidayDeleteLayer";
	}

	@RequestMapping(params="cmd=viewWtmHolidayCreateLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmHolidayCreateLayer() throws Exception {
		return "wtm/config/wtmHolidayMgr/wtmHolidayCreateLayer";
	}

	/**
	 * 근태코드관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmGntCdMgrList", method = RequestMethod.POST )
	public ModelAndView getWtmGntCdMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<Map<String, Object>> result  = new ArrayList<>();
		String Message = "";
		try{
			result = wtmGntCdMgrService.getWtmGntCdMgrList(paramMap);

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 대표코드 설정 중복체크
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmGntCdMgrDupCnt", method = RequestMethod.POST )
	public ModelAndView getWtmGntCdMgrDupCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String Message = "";
		Map<?, ?> map = null;

		try{
			map = wtmGntCdMgrService.getWtmGntCdMgrDupCnt(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 근태코드관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmGntCdMgr", method = RequestMethod.POST )
	public ModelAndView saveWtmGntCdMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<>();
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		convertMap.putAll(paramMap);
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmGntCdMgrService.saveWtmGntCdMgr(convertMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message="저장에 실패 하였습니다.";
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
	 * 근태코드관리 순서 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmGntCdSeq", method = RequestMethod.POST )
	public ModelAndView saveWtmGntCdSeq(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		convertMap.putAll(paramMap);
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmGntCdMgrService.saveWtmGntCdSeq(convertMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		}catch(Exception e){
			message="저장에 실패 하였습니다.";
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
	 * 근태코드관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmGntCdMgr", method = RequestMethod.POST )
	public ModelAndView deleteWtmGntCdMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmGntCdMgrService.deleteWtmGntCdMgr(convertMap);
			if(resultCnt > 0){ message="삭제 되었습니다."; } else{ message="삭제된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="삭제에 실패 하였습니다.";
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
