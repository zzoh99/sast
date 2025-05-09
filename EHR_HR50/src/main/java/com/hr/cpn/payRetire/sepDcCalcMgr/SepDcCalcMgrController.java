package com.hr.cpn.payRetire.sepDcCalcMgr;

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
 * DC퇴직추계계산
 *
 */
@Controller
@RequestMapping(value="/SepDcCalcMgr.do", method=RequestMethod.POST )
public class SepDcCalcMgrController extends ComController {

	/**
	 * DC퇴직추계계산 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepDcCalcMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepDcCalcMgr() throws Exception {
		return "cpn/payRetire/sepDcCalcMgr/sepDcCalcMgr";
	}

	/**
	 * DC퇴직추계계산 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepDcCalcMgrList", method = RequestMethod.POST )
	public ModelAndView getSepDcCalcMgrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * DC퇴직추계계산 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepDcCalcMgr", method = RequestMethod.POST )
	public ModelAndView saveSepDcCalcMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * DC퇴직추계계산 - 프로시저 호출
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callP_CPN_SEP_DC_MON", method = RequestMethod.POST )
	public ModelAndView callPCpnSepDcMon(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return execPrc(session, request, paramMap);
	}
}
