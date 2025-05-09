package com.hr.hrm.justice.rewardMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 포상내역관리 Service
 *
 * @author bckim
 *
 */
@Service("RewardMgrService")
@SuppressWarnings("unchecked")
public class RewardMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 포상내역관리리스트 카운트 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, String> getRewardMgrListCnt(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, String>) dao.getMap("getRewardMgrListCnt", paramMap);
	}

	/**
	 * 포상내역관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getRewardMgrList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getRewardMgrList", paramMap);
	}

	/**
	 * saveRewardMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRewardMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRewardMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRewardMgr", convertMap);
		}

		return cnt;
	}
}