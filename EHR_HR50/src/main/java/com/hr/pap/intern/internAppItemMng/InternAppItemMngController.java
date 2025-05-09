package com.hr.pap.intern.internAppItemMng;

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
 * 수습평가항목관리 Controller
 * 
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/InternAppItemMng.do", method=RequestMethod.POST )
public class InternAppItemMngController extends ComController {

	/**
	 * 수습평가항목관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewInternAppItemMngr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewInternAppItemMngr() throws Exception {
		return "pap/intern/internAppItemMngr/internAppItemMngr";
	}

	/**
	 * 수습평가항목관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getInternAppItemMngrList", method = RequestMethod.POST )
	public ModelAndView getInternAppItemMngrList(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 수습평가항목관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveInternAppItemMngr", method = RequestMethod.POST )
	public ModelAndView saveInternAppItemMngr(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
