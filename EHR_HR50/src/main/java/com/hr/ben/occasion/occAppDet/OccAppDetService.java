package com.hr.ben.occasion.occAppDet;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 경조신청 세부내역 Service
 *
 * @author
 *
 */
@Service("OccAppDetService")
public class OccAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
}