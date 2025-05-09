package com.hr.ben.resort.resortAppDet;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 학자금신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("ResortAppDetService")
public class ResortAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
}