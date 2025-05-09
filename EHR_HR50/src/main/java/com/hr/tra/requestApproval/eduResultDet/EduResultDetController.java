package com.hr.tra.requestApproval.eduResultDet;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 교육결과보고 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping({"/EduApp.do", "/EduResultDet.do"}) 
public class EduResultDetController extends ComController {
	/**
	 * 교육결과보고 서비스
	 */
	@Inject
	@Named("EduResultDetService")
	private EduResultDetService eduResultDetService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 교육결과보고 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduResultDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduResultDet() throws Exception {
		return "tra/requestApproval/eduResultDet/eduResultDet";
	}
	
	/**
	 * 교육결과보고 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduResultDetMap", method = RequestMethod.POST )
	public ModelAndView getEduResultDetMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	
	
	/**
	 * 교육결과보고 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduResultDet", method = RequestMethod.POST )
	public ModelAndView saveEduResultDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		return saveData(session, request, paramMap);
	}

}
