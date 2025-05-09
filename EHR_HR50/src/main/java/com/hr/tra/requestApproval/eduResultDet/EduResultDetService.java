package com.hr.tra.requestApproval.eduResultDet;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 교육결과보고 Service
 * 
 * @author JSG
 *
 */
@Service("EduResultDetService")  
public class EduResultDetService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
}