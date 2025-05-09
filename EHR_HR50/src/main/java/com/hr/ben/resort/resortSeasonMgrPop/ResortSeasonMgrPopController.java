package com.hr.ben.resort.resortSeasonMgrPop;

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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * ResortSeasonMgrPop Controller
 */
@Controller
@RequestMapping(value="/ResortSeasonMgrPop.do", method=RequestMethod.POST )
public class ResortSeasonMgrPopController extends ComController {

	/**
	 * ResortSeasonMgrPop 서비스
	 */
	@Inject
	@Named("ResortSeasonMgrPopService")
	private ResortSeasonMgrPopService resortSeasonMgrPopService;

	/**
	 * ResortSeasonMgrPop View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResortSeasonMgrPop",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResortSeasonMgrPop() throws Exception {
		return "ben/resort/resortSeasonMgrPop/resortSeasonMgrPop";
	}
	
	/**
	 * 성수기 리조트 객실정보
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonMgrPopRs", method = RequestMethod.POST )
	public ModelAndView getResortSeasonMgrPopRs(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 신청 리스트
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonMgrPopAprList", method = RequestMethod.POST )
	public ModelAndView getResortSeasonMgrPopAprList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	/**
	 * ResortSeasonMgrPop 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResortSeasonMgrPop", method = RequestMethod.POST )
	public ModelAndView saveResortSeasonMgrPop(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		int resultCnt = -1;
		String message = "";
		try{
			resultCnt =resortSeasonMgrPopService.saveResortSeasonMgrPop(paramMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
