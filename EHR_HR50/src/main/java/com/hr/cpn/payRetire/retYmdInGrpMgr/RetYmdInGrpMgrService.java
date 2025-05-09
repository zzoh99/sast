package com.hr.cpn.payRetire.retYmdInGrpMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 그룹내 퇴직정산일(\C774\C218) Service
 *
 * @author EW
 *
 */
@Service("RetYmdInGrpMgrService")
public class RetYmdInGrpMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 그룹내 퇴직정산일(\C774\C218) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetYmdInGrpMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetYmdInGrpMgrList", paramMap);
	}
}
