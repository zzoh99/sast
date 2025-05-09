package com.hr.ben.psnalPension.psnalPenStd;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 개인연금기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("PsnalPenStdService")  
public class PsnalPenStdService{
	@Inject
	@Named("Dao")
	private Dao dao;
}