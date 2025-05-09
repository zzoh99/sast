package com.hr.ben.golf.golfApp;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
/**
 * 골프예약신청 Service
 * 
 * @author 이름
 *
 */
@Service("GolfAppService")  
public class GolfAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
}