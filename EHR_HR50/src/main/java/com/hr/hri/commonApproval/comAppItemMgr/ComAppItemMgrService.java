package com.hr.hri.commonApproval.comAppItemMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 경조기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("ComAppItemMgrService")  
public class ComAppItemMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}