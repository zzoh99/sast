package com.hr.hrm.appmt.orgAppmtMgr;
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
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 조직개편발령 Controller 
 * 
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/OrgAppmtMgr.do", method=RequestMethod.POST )
public class OrgAppmtMgrController {
	/**
	 * 조직개편발령 서비스
	 */
	@Inject
	@Named("OrgAppmtMgrService")
	private OrgAppmtMgrService orgAppmtMgrService;
	/**
	 * 조직개편발령 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgAppmtMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgAppmtMgr() throws Exception {
		return "hrm/appmt/orgAppmtMgr/orgAppmtMgr";
	}
	/**
	 * 조직개편발령 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgAppmtMgr2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgAppmtMgr2() throws Exception {
		return "orgAppmtMgr/orgAppmtMgr";
	}
	/**
	 * 조직개편발령 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrList", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = orgAppmtMgrService.getOrgAppmtMgrList(paramMap);
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
	/**
	 * 조직개편발령 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgAppmtMgrMap", method = RequestMethod.POST )
	public ModelAndView getOrgAppmtMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Map<?, ?> map = orgAppmtMgrService.getOrgAppmtMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

}
