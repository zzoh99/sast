package com.hr.ben.reservation.reservationApp;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 자원예약신청 Service
 * 
 * @author 이름
 *
 */
@Service("ReservationAppService")  
public class ReservationAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
}