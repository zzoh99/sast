package com.hr.ben.golf.golfMgr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
/**
 * 골프예약관리 Service
 * 
 * @author 이름
 *
 */
@Service("GolfMgrService")  
public class GolfMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}