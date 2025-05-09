package com.hr.org.organization.orgMappingPersonSta;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import com.nhncorp.lucy.security.xss.XssPreventer;

/**
 * orgMappingPersonSta Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/OrgMappingPersonSta.do", method=RequestMethod.POST )
public class OrgMappingPersonStaController {
	/**
	 * orgMappingPersonSta 서비스
	 */
	@Inject
	@Named("OrgMappingPersonStaService")
	private OrgMappingPersonStaService orgMappingPersonStaService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * orgMappingPersonSta View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgMappingPersonSta", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgMappingPersonSta() throws Exception {
		return "org/organization/orgMappingPersonSta/orgMappingPersonSta";
	}

	/**
	 * orgMappingPersonSta(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgMappingPersonStaPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgMappingPersonStaPop() throws Exception {
		return "org/organization/orgMappingPersonSta/orgMappingPersonStaPop";
	}

	/**
	 * orgMappingPersonSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgMappingPersonStaList", method = RequestMethod.POST )
	public ModelAndView getOrgMappingPersonStaList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		//paramMap.put("columnInfo", XssPreventer.unescape(paramMap.get("columnInfo").toString()));

		List<Map> columnInfo = (List<Map>) orgMappingPersonStaService.getOrgMappingPersonStaTitleList(paramMap);
		List<String> colName = Arrays.asList(columnInfo.get(0).get("colName").toString().split("\\|"));
		List<String> colSaveName = Arrays.asList(columnInfo.get(0).get("colSaveName").toString().split("\\|"));

		paramMap.put("colName", colName);
		paramMap.put("colSaveName", colSaveName);

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgMappingPersonStaService.getOrgMappingPersonStaList(paramMap);
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
	
	/**
	 * orgMappingPersonSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgMappingPersonStaListNull", method = RequestMethod.POST )
	public ModelAndView getOrgMappingPersonStaListNull(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgMappingPersonStaService.getOrgMappingPersonStaListNull(paramMap);
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


	/**
	 * orgMappingPersonSta 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgMappingPersonSta", method = RequestMethod.POST )
	public ModelAndView saveOrgMappingPersonSta(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =orgMappingPersonStaService.saveOrgMappingPersonSta(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * orgMappingPersonSta 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgMappingPersonStaTitleList", method = RequestMethod.POST )
	public ModelAndView getOrgMappingPersonStaTitleList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = orgMappingPersonStaService.getOrgMappingPersonStaTitleList(paramMap);
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
