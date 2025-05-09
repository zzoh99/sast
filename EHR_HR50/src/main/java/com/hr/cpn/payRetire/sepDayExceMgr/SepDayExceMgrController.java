package com.hr.cpn.payRetire.sepDayExceMgr;

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
 * 퇴직기산일예외관리
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/SepDayExceMgr.do", method=RequestMethod.POST )
public class SepDayExceMgrController extends ComController {

	/**
	 * 퇴직기산일예외관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSepDayExceMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSepDayExceMgr() throws Exception {
		return "cpn/payRetire/sepDayExceMgr/sepDayExceMgr";
	}

	/**
	 * 퇴직기산일예외관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSepDayExceMgrList", method = RequestMethod.POST )
	public ModelAndView getSepDayExceMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 퇴직기산일예외관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSepDayExceMgr", method = RequestMethod.POST )
	public ModelAndView saveSepDayExceMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
