package com.hr.ben.reservation.reservationMgr;
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
 * 자원예약관리 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/ReservationMgr.do", method=RequestMethod.POST )
public class ReservationMgrController extends ComController {
	/**
	 * 자원예약관리 서비스
	 */
	@Inject
	@Named("ReservationMgrService")
	private ReservationMgrService goflMgrService;	
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 자원예약관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReservationMgr",method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReservationMgr() throws Exception {
		return "ben/reservation/reservationMgr/reservationMgr";
	}
	
	/**
	 * 자원예약관리 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getReservationMgrList", method = RequestMethod.POST )
	public ModelAndView getReservationMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	
}
