package com.hr.ben.club.clubpayApr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 동호회 지원금 승인 Service
 */
@Service("ClubpayAprService")
public class ClubpayAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
