package com.hr.ben.reservation.reservationStd;
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
 * 자원예약 기준관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/ReservationStd.do", method=RequestMethod.POST )
public class ReservationStdController extends ComController {
	/**
	 * 자원예약 기준관리 서비스
	 */
	@Inject
	@Named("ReservationStdService")
	private ReservationStdService goflStdService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 자원예약 기준관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReservationStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReservationStd() throws Exception {
		return "ben/reservation/reservationStd/reservationStd";
	}
	
	/**
	 * 자원예약 기준관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReservationStdList", method = RequestMethod.POST )
	public ModelAndView getReservationStdList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
	/**
	 * 자원예약 기준관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveReservationStd", method = RequestMethod.POST )
	public ModelAndView saveReservationStd(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN510", "ENTER_CD,GOLF_CD,SDATE", "ssnEnterCd,reservationCd,sdate", "s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

}
