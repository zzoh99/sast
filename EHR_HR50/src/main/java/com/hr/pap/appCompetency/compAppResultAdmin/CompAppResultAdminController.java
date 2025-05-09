package com.hr.pap.appCompetency.compAppResultAdmin;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
/**
 * 다면진단통계조회 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/CompAppResultAdmin.do", method= RequestMethod.POST )
public class CompAppResultAdminController extends ComController {
	/**
	 * 다면진단통계조회 서비스
	 */
	@Inject
	@Named("CompAppResultAdminService")
	private CompAppResultAdminService compAppResultAdminService;
	
	/**
	 * 다면진단통계조회 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCompAppResultAdmin", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMltsrcRstAdmin() throws Exception {
		return "pap/appCompetency/compAppResultAdmin/compAppResultAdmin";
	}
	
	/**
	 * 다면진단통계 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCompAppResultAdminList", method = RequestMethod.POST )
	public ModelAndView getCompAppResultAdminList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = compAppResultAdminService.getCompAppResultAdminList(paramMap);
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
