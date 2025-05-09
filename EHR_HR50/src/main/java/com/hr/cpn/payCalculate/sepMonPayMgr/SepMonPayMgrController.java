package com.hr.cpn.payCalculate.sepMonPayMgr;

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
 * 퇴직월급여실지급일자관리 Controller
 *
 */
@Controller
@RequestMapping(value="/SepMonPayMgr.do", method=RequestMethod.POST )
public class SepMonPayMgrController extends ComController {

	/**
	 * 퇴직월급여실지급일자관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepMonPayMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepMonPayMgr() throws Exception {
		return "cpn/payCalculate/sepMonPayMgr/sepMonPayMgr";
	}

	/**
	 * 퇴직월급여실지급일자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepMonPayMgrList", method = RequestMethod.POST )
	public ModelAndView getSepMonPayMgrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 퇴직월급여실지급일자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPayCalcCreBasicMap", method = RequestMethod.POST )
	public ModelAndView getPayCalcCreBasicMap(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 퇴직월급여실지급일자관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepMonPayMgr", method = RequestMethod.POST )
	public ModelAndView saveSepMonPayMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
