package com.hr.tim.workApp.otWorkOrgApr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 연장근무사전승인 Service
 * 
 * @author 이름
 *
 */
@Service("OtWorkOrgAprService")  
public class OtWorkOrgAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
}