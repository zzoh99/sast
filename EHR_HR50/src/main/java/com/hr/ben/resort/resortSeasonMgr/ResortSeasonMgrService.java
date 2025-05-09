package com.hr.ben.resort.resortSeasonMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 리조트관리 Service
 *
 * @author ksj
 *
 */
@Service("ResortSeasonMgrService")
public class ResortSeasonMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

}