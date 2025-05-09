package com.hr.ben.occasion.occStd;
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
@Service("OccStdService")  
public class OccStdService{
	@Inject
	@Named("Dao")
	private Dao dao;
}