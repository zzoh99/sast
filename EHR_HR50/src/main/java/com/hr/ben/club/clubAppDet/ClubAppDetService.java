package com.hr.ben.club.clubAppDet;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 동호회 가입/탈퇴신청 Service
 *
 * @author bckim
 *
 */
@Service("ClubAppDetService")
public class ClubAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
}