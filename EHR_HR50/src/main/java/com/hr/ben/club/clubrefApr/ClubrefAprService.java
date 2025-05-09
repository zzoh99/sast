package com.hr.ben.club.clubrefApr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 동호회 등록승인 승인 Service
 *
 * @author EW
 *
 */
@Service("ClubrefAprService")
public class ClubrefAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
