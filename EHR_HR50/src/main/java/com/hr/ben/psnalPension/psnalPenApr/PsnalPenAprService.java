package com.hr.ben.psnalPension.psnalPenApr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 개인연금승인 Service
 * 
 * @author 이름
 *
 */
@Service("PsnalPenAprService")  
public class PsnalPenAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
}