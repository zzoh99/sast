package com.hr.eis.empSituation.orgGrpSta;
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

import com.hr.common.logger.Log;
/**
 *  Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/OrgGrpSta.do", method=RequestMethod.POST )
public class OrgGrpStaController {
	/**
	 *  서비스
	 */
	@Inject
	@Named("OrgGrpStaService")
	private OrgGrpStaService orgGrpStaService;
	/**
	 *  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgGrpSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgGrpSta() throws Exception {
		return "eis/empSituation/orgGrpSta/orgGrpSta";
	}

	/**
	 *  View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgHisSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgHisSta() throws Exception {
		return "eis/empSituation/orgGrpSta/orgHisSta";
	}

	/**
	 * 공통코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSheetHeaderCnt1", method = RequestMethod.POST )
	public ModelAndView getCommonCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		paramMap.put("name", 	session.getAttribute("ssnName"));
//		paramMap.put("foreignYn",session.getAttribute("ssnForeignYn"));
//		paramMap.put("birYmd", 	session.getAttribute("ssnBirYmd"));
		List<?> result = orgGrpStaService.getSheetHeaderCnt1(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
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
	@RequestMapping(params="cmd=getOrgGrpStaList", method = RequestMethod.POST )
	public ModelAndView getOrgGrpStaList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			if( paramMap.get("gubun").toString().equals("1") ) {
				list = orgGrpStaService.getOrgGrpStaList1(paramMap);
			} else {
				list = orgGrpStaService.getOrgGrpStaList2(paramMap);
			}
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
