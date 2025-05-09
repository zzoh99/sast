package com.hr.ben.resort.resortTagerMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 리조트지원대상자관리 Service
 * 
 * @author 이름
 *
 */
@Service("ResortTargetMgrService")  
public class ResortTargetMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}