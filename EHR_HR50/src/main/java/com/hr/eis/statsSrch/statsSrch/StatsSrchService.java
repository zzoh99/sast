package com.hr.eis.statsSrch.statsSrch;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;

/**
 * 통계 조회 Service
 * @author gjyoo
 *
 */
@Service("StatsSrchService")
public class StatsSrchService {
	@Inject
	@Named("Dao")
	private Dao dao;

}
