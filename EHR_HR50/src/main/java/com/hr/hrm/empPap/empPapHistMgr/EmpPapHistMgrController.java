package com.hr.hrm.empPap.empPapHistMgr;
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
 * 고과현황(년도별) Controller
 *
 * @author jy
 *
 */
@Controller
@RequestMapping(value="/EmpPapHistMgr.do", method= RequestMethod.POST )
public class EmpPapHistMgrController extends ComController {

	/**
	 * 고과현황(년도별) 서비스
	 */
	@Inject
	@Named("EmpPapHistMgrService")
	private EmpPapHistMgrService empPapHistMgrService;
	
	/**
	 * 고과현황(년도별) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEmpPapHistMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEmpPapResultUpload() throws Exception {
		return "hrm/empPap/empPapHistMgr/empPapHistMgr";
	}
	

	/**
	 * 고과현황(년도별) 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEmpPapHistMgrList", method = RequestMethod.POST )
	public ModelAndView getEmpPapHistMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

}
