package com.hr.ben.resort.resortMgr;

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
@Service("ResortMgrService")
public class ResortMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
