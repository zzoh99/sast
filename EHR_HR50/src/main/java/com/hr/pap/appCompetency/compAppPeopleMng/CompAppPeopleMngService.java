package com.hr.pap.appCompetency.compAppPeopleMng;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 리더십진단대상자관리 Service
 *
 * @author JSG
 *
 */
@Service("CompAppPeopleMngService")
public class CompAppPeopleMngService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 리더십진단대상자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppPeopleMngList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppPeopleMngList1", paramMap);
	}

	/**
	 * 리더십진단대상자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppPeopleMngList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppPeopleMngList2", paramMap);
	}

	/**
	 * 리더십진단대상자관리 저장 Service(상단)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppPeopleMng1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompAppPeopleMng1_527", convertMap);
		}
		/*
		 * if( ((List<?>)convertMap.get("deleteRows")).size() > 0){ cnt +=
		 * dao.delete("deleteCompAppPeopleMng1", convertMap); }
		 */
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompAppPeopleMng1", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 리더십진단대상자관리 저장 Service(상단)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppPeopleMng2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompAppPeopleMng2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompAppPeopleMng2", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 리더십진단대상자관리 저장 Service (대상자생성)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcCompAppPeopleMng(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcCompAppPeopleMng", paramMap);
	}
}