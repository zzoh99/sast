package com.hr.org.capacity.orgCapaInfoSta2;
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

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 조직구분등록 Controller 
 * 
 * @author CBS
 *
 */
@Controller
@RequestMapping(value="/OrgCapaInfoSta2.do", method=RequestMethod.POST )
public class OrgCapaInfoSta2Controller {
	/**
	 * 조직구분등록 서비스
	 */
	@Inject
	@Named("OrgCapaInfoSta2Service")
	private OrgCapaInfoSta2Service OrgCapaInfoSta2Service;
	/**
	 * 조직구분등록 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgCapaInfoSta2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOrgCapaInfoSta2() throws Exception {
		return "org/capacity/orgCapaInfoSta2/orgCapaInfoSta2";
	}

	/**
	 * 조직구분등록 sheet1 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgCapaInfoSta2Sheet1List", method = RequestMethod.POST )
	public ModelAndView getOrgCapaInfoSta2Sheet1List(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));		
		try{
			list = OrgCapaInfoSta2Service.getOrgCapaInfoSta2Sheet1List(paramMap);
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
	 * 인력수급현황  정원 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgCapaInfoSta2", method = RequestMethod.POST )
	public ModelAndView saveOrgCapaInfoSta2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("searchYear",paramMap.get("searchYear"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = OrgCapaInfoSta2Service.saveOrgCapaInfoSta2(convertMap);
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
	
}