package com.hr.pap.execCompAppMngResultSrh;

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
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 임원다면평가업로드 Controller
 */
@Controller
@RequestMapping(value="/ExecCompAppMngResultSrh.do", method=RequestMethod.POST )
public class ExecCompAppMngResultSrhController extends ComController {

	/**
	 * 임원다면평가업로드 서비스
	 */
	@Inject
	@Named("ExecCompAppMngResultSrhService")
	private ExecCompAppMngResultSrhService execCompAppMngResultSrh;
	
	/**
	 * 임원다면평가업로드 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewExecCompAppMngResultSrh", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewExecCompAppMngUpload() throws Exception {
		return "pap/execCompApp/execCompAppMngResultSrh/execCompAppMngResultSrh";
	}
	
	/**
	 * ExecCompAppMngUpload 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getExecCompAppMngResultSrhList", method = RequestMethod.POST )
	public ModelAndView getExecCompAppMngResultSrhList(
				HttpSession session
			,  	HttpServletRequest request
			,	@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = execCompAppMngResultSrh.getExecCompAppMngResultSrhList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		
		Log.DebugEnd();
		
		return mv;
	}
}
