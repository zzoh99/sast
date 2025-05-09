package com.hr.ben.golf.golfStd;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
/**
 * 골프예약기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("GolfStdService")  
public class GolfStdService{
	@Inject
	@Named("Dao")
	private Dao dao;
}