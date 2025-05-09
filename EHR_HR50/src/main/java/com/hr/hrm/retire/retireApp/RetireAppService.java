package com.hr.hrm.retire.retireApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직신청 Service
 *
 * @author bckim
 *
 */
@Service("RetireAppService")
public class RetireAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getRetireAppList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireAppList", paramMap);
	}
	
	/**
	 *  퇴직신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetireApp", convertMap);
			dao.delete("deleteRetireApp185", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireApp", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}