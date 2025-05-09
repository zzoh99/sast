package com.hr.tra.outcome.required.requiredSta;
import java.util.ArrayList;
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

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 필수교육이수현황 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/RequiredSta.do", method=RequestMethod.POST ) 
public class RequiredStaController extends ComController {
	/**
	 * 필수교육이수현황 서비스
	 */
	@Inject
	@Named("RequiredStaService")
	private RequiredStaService requiredStaService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 필수교육이수현황 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRequiredSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRequiredSta() throws Exception {
		return "tra/outcome/required/requiredSta/requiredSta";
	}

	/**
	 * 필수교육이수현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRequiredStaList", method = RequestMethod.POST )
	public ModelAndView getRequiredStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		List<?> titleList = requiredStaService.getRequiredStaTitleList(paramMap);

		paramMap.put("titles", titleList);
		
		return getDataList(session, request, paramMap);
	}
	
	

}
