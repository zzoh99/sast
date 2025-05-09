package com.hr.sys.security.widgetMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;

import com.hr.common.logger.Log;

/**
 * 위젯관리 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/WidgetMgr.do", method=RequestMethod.POST )
public class WidgetMgrController extends ComController {
	/**
	 * 위젯관리 서비스
	 */
	@Inject
	@Named("WidgetMgrService")
	private WidgetMgrService widgetMgrService;



	/**
	 * 위젯관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWidgetMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWidgetMgr() throws Exception {
		return "sys/security/widgetMgr/widgetMgr";
	}

	/**
	 * 위젯관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWidgetMgrList", method = RequestMethod.POST )
	public ModelAndView getWidgetMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}


	/**
	 * 위젯관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWidgetMgr", method = RequestMethod.POST )
	public ModelAndView saveWidgetMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}


	/**
	 * 위젯 통계 데이터
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getStatsWidgetInfo", method = RequestMethod.POST )
	public ModelAndView getStatsWidgetInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> resultMap=new HashMap<String, Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{

			resultMap = widgetMgrService.getStatsWidgetInfo(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", resultMap);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
