package com.hr.tim.code.workItemMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 일일근무신청코드설정 Service
 *
 * @author bckim
 *
 */
@Service("WorkItemMgrService")
public class WorkItemMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  일일근무신청코드설정 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkItemMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkItemMgrList", paramMap);
	}
	
	/**
	 * 일일근무신청코드설정 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkItemMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		dao.delete("deleteWorkItemMgr", paramMap);
		cnt += dao.update("insertWorkItemMgr", paramMap);

		Log.Debug();
		return cnt;
	}
}