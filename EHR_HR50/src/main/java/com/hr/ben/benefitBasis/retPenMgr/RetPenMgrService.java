package com.hr.ben.benefitBasis.retPenMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직전환금관리 Service
 *
 * @author EW
 *
 */
@Service("RetPenMgrService")
public class RetPenMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직전환금관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetPenMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetPenMgrList", paramMap);
	}

	/**
	 * 퇴직전환금관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetPenMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetPenMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetPenMgr", convertMap);
		}

		return cnt;
	}
}
