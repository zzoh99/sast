package com.hr.cpn.payRetire.sepWorkDayAddMgr;

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
 * 개인별근속기간가산관리
 *
 */
@Controller
@RequestMapping(value="/SepWorkDayAddMgr.do", method=RequestMethod.POST )
public class SepWorkDayAddMgrController extends ComController {

	/**
	 * 개인별근속기간가산관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepWorkDayAddMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepWorkDayAddMgr() throws Exception {
		return "cpn/payRetire/sepWorkDayAddMgr/sepWorkDayAddMgr";
	}

	/**
	 * 개인별근속기간가산관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepWorkDayAddMgrList", method = RequestMethod.POST )
	public ModelAndView getSepWorkDayAddMgrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 개인별근속기간가산관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepWorkDayAddMgr", method = RequestMethod.POST )
	public ModelAndView saveSepWorkDayAddMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
