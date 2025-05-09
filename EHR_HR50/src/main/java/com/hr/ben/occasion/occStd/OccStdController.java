package com.hr.ben.occasion.occStd;
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
 * 경조기준관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/OccStd.do", method=RequestMethod.POST )
public class OccStdController extends ComController {
	/**
	 * 경조기준관리 서비스
	 */
	@Inject
	@Named("OccStdService")
	private OccStdService occStdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 경조기준관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOccStd",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewOccStd() throws Exception {
		return "ben/occasion/occStd/occStd";
	}
	
	/**
	 * 경조기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOccStdList", method = RequestMethod.POST )
	public ModelAndView getOccStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 경조기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOccStd", method = RequestMethod.POST )
	public ModelAndView saveOccStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN470", "ENTER_CD,OCC_CD,FAM_CD,OCC_SDATE,WORK_TYPE", "ssnEnterCd,occCd,famCd,occSdate,workType", "s,s,s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

}
