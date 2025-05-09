package com.hr.ben.buscard.buscardAppDet;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 명함신청 세부내역 Service
 *
 * @author
 *
 */
@Service("BuscardAppDetService")
public class BuscardAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
}