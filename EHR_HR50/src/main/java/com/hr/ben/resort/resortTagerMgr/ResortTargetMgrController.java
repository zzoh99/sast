package com.hr.ben.resort.resortTagerMgr;
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
 * 리조트지원대상자관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/ResortTargetMgr.do", method=RequestMethod.POST )
public class ResortTargetMgrController extends ComController {
	/**
	 * 리조트지원대상자관리 서비스
	 */
	@Inject
	@Named("ResortTargetMgrService")
	private ResortTargetMgrService resortTargetMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 리조트지원대상자관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResortTargetMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResortTargetMgr() throws Exception {
		return "ben/resort/resortTargetMgr/resortTargetMgr";
	}
	
	/**
	 * 리조트지원대상자관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResortTargetMgrList", method = RequestMethod.POST )
	public ModelAndView getResortTargetMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 리조트지원대상자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResortTargetMgr", method = RequestMethod.POST )
	public ModelAndView saveResortTargetMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN496", "ENTER_CD,YEAR,SABUN", "ssnEnterCd,year,sabun", "s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

}
