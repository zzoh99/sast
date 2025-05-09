package com.hr.ben.medical.medCodeMgr;
import java.util.ArrayList;
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
 * 질병코드관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping({"/MedCodeMgr.do", "/MedApp.do"}) 
public class MedCodeMgrController extends ComController {
	/**
	 * 질병코드관리 서비스
	 */
	@Inject
	@Named("MedCodeMgrService")
	private MedCodeMgrService medCodeMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 질병코드관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMedCodeMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewMedCodeMgr() throws Exception {
		return "ben/medical/medCodeMgr/medCodeMgr";
	}
	
	/**
	 * 질병코드관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMedCodeMgrList", method = RequestMethod.POST )
	public ModelAndView getMedCodeMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 질병코드관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMedCodeMgr", method = RequestMethod.POST )
	public ModelAndView saveMedCodeMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN700", "ENTER_CD,CODE", "ssnEnterCd,code", "s,s"};
		paramMap.put("dupList", dupList);
		
		//return saveDataBatch(session, request, paramMap);
		return saveData(session, request, paramMap);
	}

}
