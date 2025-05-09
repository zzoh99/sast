package com.hr.ben.club.clubMgr;

import com.hr.common.dao.Dao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;

/**
 * 동호회관리 Service
 *
 */
@Service("ClubMgrService")
public class ClubMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
