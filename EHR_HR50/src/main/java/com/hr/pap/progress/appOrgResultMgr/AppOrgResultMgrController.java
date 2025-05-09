package com.hr.pap.progress.appOrgResultMgr;
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
 * 평가결과종합관리 Controller
 *
 * @author JCY
 *
 */
@Controller
@RequestMapping(value="/AppOrgResultMgr.do", method=RequestMethod.POST )
public class AppOrgResultMgrController {
	/**
	 * 평가결과종합관리 서비스
	 */
	@Inject
	@Named("AppOrgResultMgrService")
	private AppOrgResultMgrService appOrgResultMgrService;

	/**
	 * 평가결과종합관리 단건 조회(평가ID정보 조회)
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppOrgResultMgrMap", method = RequestMethod.POST )
	public ModelAndView getAppOrgResultMgrMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		Map<?, ?> map = appOrgResultMgrService.getAppOrgResultMgrMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

}
