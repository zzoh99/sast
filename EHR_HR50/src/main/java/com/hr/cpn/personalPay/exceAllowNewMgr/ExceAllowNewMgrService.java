package com.hr.cpn.personalPay.exceAllowNewMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 예외수당/공제관리 Service
 *
 * @author 이름
 *
 */
@Service("ExceAllowNewMgrService")
public class ExceAllowNewMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 예외수당/공제관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExceAllowNewMgrFirstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExceAllowNewMgrFirstList", paramMap);
	}

	/**
	 * 예외수당/공제관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExceAllowNewMgrSecondList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExceAllowNewMgrSecondList", paramMap);
	}

	/**
	 *  예외수당/공제관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getExceAllowNewMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getExceAllowNewMgrMap", paramMap);
	}
	/**
	 * 예외수당/공제관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExceAllowNewMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// Detail
			cnt += dao.delete("deleteExceAllowNewMgrFirstDetail", convertMap);
			// Master
			cnt += dao.delete("deleteExceAllowNewMgrFirst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveExceAllowNewMgrFirst", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 예외수당/공제관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExceAllowNewMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExceAllowNewMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveExceAllowNewMgrFirst", convertMap);
			cnt += dao.update("saveExceAllowNewMgrSecond", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}