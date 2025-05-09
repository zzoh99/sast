package com.hr.hrm.psnalInfo.psnalConYmdMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalConYmdMgr Service
 *
 * @author EW
 *
 */
@Service("PsnalConYmdMgrService")
public class PsnalConYmdMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalConYmdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalConYmdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalConYmdMgrList", paramMap);
	}
}
