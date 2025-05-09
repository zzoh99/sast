package com.hr.ben.club.clubAgreeSta;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 클럽 승인 Service
 *
 * @author EW
 *
 */
@Service("ClubAgreeStaService")
public class ClubAgreeStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
