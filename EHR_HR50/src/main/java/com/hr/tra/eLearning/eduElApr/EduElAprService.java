package com.hr.tra.eLearning.eduElApr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 이러닝승인 Service
 * 
 * @author 이름
 *
 */
@Service("EduElAprService")  
public class EduElAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
}