package com.hr.ben.psnalPension.psnalPenAppDet;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 개인연금신청 세부내역 Service
 *
 * @author
 *
 */
@Service("PsnalPenAppDetService")
public class PsnalPenAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
}