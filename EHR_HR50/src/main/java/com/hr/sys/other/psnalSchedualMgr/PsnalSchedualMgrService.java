package com.hr.sys.other.psnalSchedualMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 개인별알림관리 Service
 * 
 * @author 이름
 *
 */
@Service("PsnalSchedualMgrService")  
public class PsnalSchedualMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}