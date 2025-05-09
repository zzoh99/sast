package com.hr.ben.resort.resortSeasonMgr;

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
import com.hr.common.util.ParamUtils;

/**
 * 성수기리조트 관리 Controller
 *
 * @author ksj
 *
 */
@Controller
@RequestMapping(value="/ResortSeasonMgr.do", method=RequestMethod.POST )
public class ResortSeasonMgrController extends ComController {
	/**
	 * 성수기리조트 관리 서비스
	 */
	@Inject
	@Named("ResortSeasonMgrService")
	private ResortSeasonMgrService resortSeasonMgrService;

	/**
	 * 성수기리조트 관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResortSeasonMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResortSeasonMgr() throws Exception {
		return "ben/resort/resortSeasonMgr/resortSeasonMgr";
	}
	
    /**
     * ResortSeasonMgrPop Layer View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewResortSeasonMgrLayer",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewResortSeasonMgrLayer() throws Exception {
        return "ben/resort/resortSeasonMgrPop/resortSeasonMgrLayer";
    }
    
	
	/**
	 * 성수기리조트 신청기간 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonMgrList", method = RequestMethod.POST )
	public ModelAndView getResortSeasonMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 성수기리조트 객실 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortSeasonMgrRoomList", method = RequestMethod.POST )
	public ModelAndView getResortSeasonMgrRoomList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 성수기리조트 신청기간 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResortSeasonMgr", method = RequestMethod.POST )
	public ModelAndView saveResortMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
	
	
	/**
	 * 성수기리조트 객실 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResortSeasonMgrRoom", method = RequestMethod.POST )
	public ModelAndView saveResortSeasonMgrRoom(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	//	return saveDataBatch(session, request, paramMap);
		return saveData(session, request, paramMap);
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
        return saveData(session, request, paramMap);
    }
    

}
