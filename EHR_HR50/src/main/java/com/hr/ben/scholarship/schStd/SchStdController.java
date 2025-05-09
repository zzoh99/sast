package com.hr.ben.scholarship.schStd;
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

/**
 * 학자금기준관리 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/SchStd.do", method=RequestMethod.POST )
public class SchStdController extends ComController {
	/**
	 * 학자금기준관리 서비스
	 */
	@Inject
	@Named("SchStdService")
	private SchStdService schStdService;

	/**
	 * 학자금기준관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSchStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSchStd() throws Exception {
		return "ben/scholarship/schStd/schStd";
	}

	/**
	 * 학자금기준관리 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSchStdList", method = RequestMethod.POST )
	public ModelAndView getSchStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 학자금기준관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSchStd", method = RequestMethod.POST )
	public ModelAndView saveSchStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN750", "ENTER_CD,SCH_TYPE_CD,SCH_SUP_TYPE_CD,FAM_CD,SDATE", "ssnEnterCd,schTypeCd,schSupTypeCd,famCd,sdate", "s,s,s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}
	
}
