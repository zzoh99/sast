package com.hr.eis.statsSrch.chartItemMng;

import java.util.Map;

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
 * 통계그래프 > 차트 관리 컨트롤러
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/ChartItemMng.do", method=RequestMethod.POST )
public class ChartItemMngController extends ComController {
	
	/**
	 * 차트 관리 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewChartItemMng", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewChartItemMng() throws Exception {
		return "eis/statsSrch/chartItemMng/chartItemMng";
	}
	
	/**
	 * 차트 관리 > 데이터 필수 정의 컬럼 정보 팝업 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewChartItemMngRequiredColPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewChartItemMngRequiredColPop() throws Exception {
		return "eis/statsSrch/chartItemMng/chartItemMngRequiredColPop";
	}
	
	@RequestMapping(params="cmd=viewChartItemMngRequiredColLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewChartItemMngRequiredColLayer() throws Exception {
		return "eis/statsSrch/chartItemMng/chartItemMngRequiredColLayer";
	}

	/**
	 * 차트 관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getChartItemMngList", method = RequestMethod.POST )
	public ModelAndView getChartItemMngList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 차트 관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveChartItemMng", method = RequestMethod.POST )
	public ModelAndView saveChartItemMng(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
