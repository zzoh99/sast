package com.hr.ben.reservation.reservationStd;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 자원예약기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("ReservationStdService")  
public class ReservationStdService{
	@Inject
	@Named("Dao")
	private Dao dao;
}