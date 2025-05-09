package com.hr.ben.psnalPension.psnalPenSta;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 개인연금현황 Service
 * 
 * @author 이름
 *
 */
@Service("PsnalPenStaService")  
public class PsnalPenStaService{
	@Inject
	@Named("Dao")
	private Dao dao;
}