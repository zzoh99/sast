package com.hr.tim.etc.psnlWeekWorkSta;
import java.util.Arrays;
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
 * 개인별주근무현황 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnlWeekWorkSta.do", method=RequestMethod.POST )
public class PsnlWeekWorkStaController extends ComController {
	/**
	 * 개인별주근무현황 서비스
	 */
	@Inject
	@Named("PsnlWeekWorkStaService")
	private PsnlWeekWorkStaService requiredStaService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 개인별주근무현황 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnlWeekWorkSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnlWeekWorkSta() throws Exception {
		return "tim/etc/psnlWeekWorkSta/psnlWeekWorkSta";
	}

	/**
	 * 조직콤보 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlWeekWorkStaOrgList", method = RequestMethod.POST )
	public ModelAndView getPsnlWeekWorkStaOrgList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 개인별주근무현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnlWeekWorkStaList", method = RequestMethod.POST )
	public ModelAndView getPsnlWeekWorkStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		if (paramMap.containsKey("searchJikgubCd")) {
			String searchJikgubCd = String.valueOf(paramMap.get("searchJikgubCd"));
			List<String> searchJikgubCdList = Arrays.asList(searchJikgubCd.split(","));
			paramMap.put("searchJikgubCdList", searchJikgubCdList);
		}

		return getDataList(session, request, paramMap);
	}
	

}
