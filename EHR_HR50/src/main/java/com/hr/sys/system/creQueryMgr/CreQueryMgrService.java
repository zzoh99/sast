package com.hr.sys.system.creQueryMgr;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

@Service("CreQueryMgrService")
public class CreQueryMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

}