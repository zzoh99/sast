package com.hr.ben.psnalPension.psnalPenSta;
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

import yjungsan.util.DateUtil;

/**
 * 개인연금현황 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PsnalPenSta.do", method=RequestMethod.POST )
public class PsnalPenStaController extends ComController {
	/**
	 * 개인연금현황 서비스
	 */
	@Inject
	@Named("PsnalPenStaService")
	private PsnalPenStaService psnalPenStaService;


	/**
	 * 개인연금현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalPenSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalPenSta() throws Exception {
		return "ben/psnalPension/psnalPenSta/psnalPenSta";
	}
	

	/**
	 * 개인연금현황 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalPenStaList", method = RequestMethod.POST )
	public ModelAndView getPsnalPenStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		String searchYm = String.valueOf(paramMap.get("searchYm"));
		String arr[] = searchYm.split("-");
		String ym1 = DateUtil.getMonthAddTight(arr[0], arr[1], -1);  //전월
		String ym2 = arr[0] + arr[1]; //당월
		String ym3 = DateUtil.getMonthAddTight(arr[0], arr[1], 1); //익월
		
		paramMap.put("ym1", ym1);paramMap.put("ym2", ym2);paramMap.put("ym3", ym3);
		return getDataList(session, request, paramMap);
	}
	
	
}
