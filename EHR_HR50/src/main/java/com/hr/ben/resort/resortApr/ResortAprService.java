package com.hr.ben.resort.resortApr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 리조트 승인 Service
 *
 * @author EW
 *
 */
@Service("ResortAprService")
public class ResortAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
