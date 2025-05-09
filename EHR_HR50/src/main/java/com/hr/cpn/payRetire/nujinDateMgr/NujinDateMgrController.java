package com.hr.cpn.payRetire.nujinDateMgr;

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
 * 퇴직누진일수관리
 * 
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/NujinDateMgr.do", method=RequestMethod.POST )
public class NujinDateMgrController extends ComController {

	/**
	 * 퇴직누진일수관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewNujinDateMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewNujinDateMgr() throws Exception {
		return "cpn/payRetire/nujinDateMgr/nujinDateMgr";
	}

	/**
	 * 퇴직누진일수관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getNujinDateMgrList", method = RequestMethod.POST )
	public ModelAndView getNujinDateMgrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 퇴직누진일수관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveNujinDateMgr", method = RequestMethod.POST )
	public ModelAndView saveNujinDateMgr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
