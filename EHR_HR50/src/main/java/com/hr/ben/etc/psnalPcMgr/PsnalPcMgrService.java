package com.hr.ben.etc.psnalPcMgr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
/**
 * 개인PC정보 Service
 * 
 * @author 이름
 *
 */
@Service("PsnalPcMgrService")  
public class PsnalPcMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}