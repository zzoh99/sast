package com.hr.sys.security.ipAddressMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * IP관리 Service
 * 
 * @author 이름
 *
 */
@Service("IpAddressMgrService")  
public class IpAddressMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
}