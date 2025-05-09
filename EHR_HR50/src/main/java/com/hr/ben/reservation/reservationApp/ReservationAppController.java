package com.hr.ben.reservation.reservationApp;
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
 * 자원예약신청 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/ReservationApp.do", method=RequestMethod.POST )
public class ReservationAppController extends ComController {
	/**
	 * 자원예약신청 서비스
	 */
	@Inject
	@Named("ReservationAppService")
	private ReservationAppService goflAppService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 자원예약신청 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReservationApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReservationApp() throws Exception {
		return "ben/reservation/reservationApp/reservationApp";
	}
	
	 /**
     * 자원예약신청 View
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewReservationAppLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewReservationAppLayer() throws Exception {
        return "ben/reservation/reservationApp/reservationAppLayer";
    }
    
	/**
	 * 자원예약신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReservationAppList", method = RequestMethod.POST )
	public ModelAndView getReservationAppList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 자원예약신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReservationAppMap", method = RequestMethod.POST )
	public ModelAndView getReservationAppMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 자원예약신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReservationAppUserMap", method = RequestMethod.POST )
	public ModelAndView getReservationAppUserMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 자원예약신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReservationAppUserDupCheck", method = RequestMethod.POST )
	public ModelAndView getReservationAppUserDupCheck(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 자원예약신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveReservationApp", method = RequestMethod.POST )
	public ModelAndView saveReservationApp(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		 //테이블명, 컬럼명,  파라메터키, 데이터 타입
		String[] dupList= {"TBEN521", "ENTER_CD,APPL_SEQ,RES_SEQ", "ssnEnterCd,applSeq,resSeq", "s,s,s"};
		paramMap.put("dupList", dupList);
		
		return saveData(session, request, paramMap);
	}

}
