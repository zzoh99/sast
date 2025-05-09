package com.hr.hrm.psnalInfo.psnalBasicInf;
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
 * 인사기본 정보 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/PsnalBasicInf.do", method=RequestMethod.POST )
public class PsnalBasicInfController extends ComController {

	/**
	 * 인사기본 정보 서비스
	 */
	@Inject
	@Named("PsnalBasicInfService")
	private PsnalBasicInfService psnalBasicInfService;

	
	/**
	 * 인사기본 정보 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalBasic", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalBasic() throws Exception {
		return "hrm/psnalInfo/psnalBasicInf/psnalBasic";
	}
	
	/**
	 * 인사기본 정보 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalBasicInf", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalBasicInf() throws Exception {
		return "hrm/psnalInfo/psnalBasicInf/psnalBasicInf";
	}
	

	/**
	 * 인사기본(Tree) 정보 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalBasicInfMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalBasicInfMgr() throws Exception {
		return "hrm/psnalInfo/psnalBasicInf/psnalBasicInfMgr";
	}
	
	/**
	 * 인사기본(Tree) - 조직  조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicLeftOrgList", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicLeftOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	/**
	 * 인사기본(Tree) - 조직월  조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalBasicLeftEmpList", method = RequestMethod.POST )
	public ModelAndView getPsnalBasicLeftEmpList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
