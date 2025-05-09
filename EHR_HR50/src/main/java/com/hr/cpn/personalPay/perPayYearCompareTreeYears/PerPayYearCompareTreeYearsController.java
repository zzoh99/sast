package com.hr.cpn.personalPay.perPayYearCompareTreeYears;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.Serializable;
import java.net.URLDecoder;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 연봉관리 Controller
 *
 * @author JSG
 *
 */
@Controller
//@SuppressWarnings("unchecked")
@RequestMapping(value="/PerPayYearCompareTreeYears.do", method=RequestMethod.POST )
public class PerPayYearCompareTreeYearsController extends ComController {
	/**
	 * 연봉관리 서비스
	 */
	@Inject
	@Named("PerPayYearCompareTreeYearsService")
	private PerPayYearCompareTreeYearsService perPayYearCompareTreeYearsService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	/**
	 * 월별급여지급현황 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPerPayYearCompareTreeYears", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPerPayYearCompareTreeYears() throws Exception {
		return "cpn/personalPay/perPayYearCompareTreeYears/perPayYearCompareTreeYears";
	}
	
	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPerPayYearCompareTreeYearsList", method = RequestMethod.POST )
	public ModelAndView getPerPayYearCompareTreeYearsList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
//		String columnInfo = null;
//		columnInfo = paramMap.get("columnInfo").toString().replaceAll("&#39;", "'");
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		String[] elmentCdArr = paramMap.get("searchElementCdHidden").toString().split(",");
		paramMap.put("searchElementCdHidden", elmentCdArr);

		List<String> elementCd = Arrays.asList(elmentCdArr);
		List<String> columnInfo = elementCd.stream()
				.map(element -> "'" + element + "' AS ELE_" + element)
				.collect(Collectors.toList());

		paramMap.put("columnInfo", columnInfo );

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = perPayYearCompareTreeYearsService.getPerPayYearCompareTreeYearsList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
