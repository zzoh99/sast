package com.hr.sys.log.senderMailLogMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * senderMailLog Service
 *
 * @author EW
 *
 */
@Service("SenderMailLogMgrService")
public class SenderMailLogMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * senderMailLog 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSenderMailLogMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSenderMailLogMgrList", paramMap);
	}
}
