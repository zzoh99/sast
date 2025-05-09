package com.hr.hrm.successor.succKeyOrgMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * orgTotalMgr Service
 *
 * @author EW
 *
 */
@Service("SuccKeyOrgMgrService")
public class SuccKeyOrgMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * orgTotalMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccKeyOrgMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccKeyOrgMgrList", paramMap);
	}

	/**
	 * orgTotalMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getorgTotalMgrOrgChartNmTORG103(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getorgTotalMgrOrgChartNmTORG103", paramMap);
	}

	/**
	 * orgTotalMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMeberList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMeberList1", paramMap);
	}

	/**
	 * orgTotalMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMeberList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMeberList2", paramMap);
	}

	/**
	 * orgTotalMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgHistoryList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgHistoryList", paramMap);
	}

	/**
	 * orgTotalMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgChiefList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgChiefList", paramMap);
	}

	/**
	 * orgTotalMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgRNRList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgRNRList", paramMap);
	}

	/**
	 * orgTotalMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgChiefList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgChiefList2", paramMap);
	}

	/**
	 * orgTotalMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSuccKeyOrgMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSuccKeyOrgMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSuccKeyOrgMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * orgTotalMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgChiefList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgChiefList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgChiefList", convertMap);
		}

		return cnt;
	}

	/**
	 * orgTotalMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgChiefList2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgChiefList2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgChiefList2", convertMap);
		}

		return cnt;
	}

	/**
	 * orgTotalMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getorgTotalMgrMemoTORG103(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getorgTotalMgrMemoTORG103", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * getSuccKeyOrgMgrMaxOrgChartMap 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSuccKeyOrgMgrMaxOrgChartMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSuccKeyOrgMgrMaxOrgChartMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	
	/**
	 * getSuccKeyDetailMap 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSuccKeyDetailMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSuccKeyDetailMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getSuccDetailList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSuccKeyDetailList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSuccKeyDetailList", paramMap);
	}
	
	/**
	 * SuccKeyDetai 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSuccKeyDetail(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSuccKeyDetail", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSuccKeyDetail", convertMap);
		}

		return cnt;
	}
	
	/**
	 * SuccKeyDetai 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSuccKeyJob(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("saveSuccKeyJob", paramMap);

		return cnt;
	}

}
