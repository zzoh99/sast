package com.hr.ben.medical.medStd;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 질병코드관리 Service
 * 
 * @author 이름
 *
 */
@Service("MedStdService")  
public class MedStdService{
	@Inject
	@Named("Dao")
	private Dao dao;
}