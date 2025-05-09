package com.hr.pap.config.mltsrcAppItemMgnr;

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
 * 다면평가항목정의 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/MltsrcAppItemMgnr.do", method=RequestMethod.POST )
public class MltsrcAppItemMgnrController extends ComController {
	
	/**
	 * 다면평가항목정의 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMltsrcAppItemMgnr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMltsrcAppItemMgnr() throws Exception {
		return "pap/config/mltsrcAppItemMgnr/mltsrcAppItemMgnr";
	}
	
	/**
	 * 다면평가항목정의 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMltsrcAppItemMgnrList", method = RequestMethod.POST )
	public ModelAndView getMltsrcAppItemMgnrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 *  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMltsrcAppItemMgnr", method = RequestMethod.POST )
	public ModelAndView saveMltsrcAppItemMgnr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}
}
