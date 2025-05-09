package com.hr.cpn.basisConfig.payTblGrpMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.dao.ProDao;
import com.hr.common.logger.Log;

/**
 * payTblGrpMgr Service
 *
 * @author EW
 *
 */
@Service("PayTblGrpMgrService")
public class PayTblGrpMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ProDao")
	private ProDao proDao;

	/**
	 * payTblGrpMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTblGrpMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTblGrpMgrList", paramMap);
	}

	/**
	 * payTblGrpMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTblGrpMgrList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTblGrpMgrList2", paramMap);
	}

	
	/**
	 * payTblGrpMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayTblGrpMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayTblGrpMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayTblGrpMgr", convertMap);
		}

		return cnt;
	}	/**
	 * payTblGrpMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayTblGrpMgr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayTblGrpMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayTblGrpMgr2", convertMap);
		}

		return cnt;
	}
	/**
	 * payTblGrpMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPayTblGrpMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPayTblGrpMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
