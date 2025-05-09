package com.hr.sys.alteration.saveCmdMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * saveCmdMgr Service
 *
 * @author EW
 *
 */
@Service("SaveCmdMgrService")
public class SaveCmdMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

}
