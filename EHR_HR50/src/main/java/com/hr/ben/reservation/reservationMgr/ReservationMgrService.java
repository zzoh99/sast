package com.hr.ben.reservation.reservationMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 자원예약관리 Service
 * 
 * @author 이름
 *
 */
@Service("ReservationMgrService")  
public class ReservationMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}