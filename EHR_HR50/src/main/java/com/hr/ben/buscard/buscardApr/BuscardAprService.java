package com.hr.ben.buscard.buscardApr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
/**
 * 경조승인 Service
 * 
 * @author 이름
 *
 */
@Service("BuscardAprService")  
public class BuscardAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
}