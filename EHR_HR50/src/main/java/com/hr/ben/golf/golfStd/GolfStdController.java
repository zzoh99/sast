package com.hr.ben.golf.golfStd;

import com.hr.common.code.CommonCodeService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * 골프예약 기준관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/GolfStd.do", method=RequestMethod.POST )
public class GolfStdController extends ComController {
	/**
	 * 골프예약 기준관리 서비스
	 */
	@Inject
	@Named("GolfStdService")
	private GolfStdService goflStdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 골프예약 기준관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGolfStd",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGolfStd() throws Exception {
		return "ben/golf/golfStd/golfStd";
	}
	
	/**
	 * 골프예약 기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getGolfStdList", method = RequestMethod.POST )
	public ModelAndView getGolfStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 골프예약 기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveGolfStd", method = RequestMethod.POST )
	public ModelAndView saveGolfStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN510", "ENTER_CD,GOLF_CD,SDATE", "ssnEnterCd,golfCd,sdate", "s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

}
