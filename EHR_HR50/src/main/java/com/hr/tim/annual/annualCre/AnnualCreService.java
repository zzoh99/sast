package com.hr.tim.annual.annualCre;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 연차생성 Service
 * 
 * @author 이름
 *
 */
@Service("AnnualCreService")  
public class AnnualCreService{
	@Inject
	@Named("Dao")
	private Dao dao;

}