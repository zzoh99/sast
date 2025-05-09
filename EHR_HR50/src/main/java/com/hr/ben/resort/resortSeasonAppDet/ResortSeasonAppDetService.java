package com.hr.ben.resort.resortSeasonAppDet;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 학자금신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("ResortSeasonAppDetService")
public class ResortSeasonAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
}