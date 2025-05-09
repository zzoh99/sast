package com.hr.pap.appCompetency.lDSCompetencyMng;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 리더십역량관리 Service
 *
 * @author JSG
 *
 */
@Service("LDSCompetencyMngService")
public class LDSCompetencyMngService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 리더십역량관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLDSCompetencyMngList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLDSCompetencyMngList1", paramMap);
	}

	/**
	 * 리더십역량관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLDSCompetencyMngList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLDSCompetencyMngList2", paramMap);
	}

	/**
	 * 리더십역량관리 저장 Service(상단)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLDSCompetencyMng1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLDSCompetencyMng1_533", convertMap);
		}
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLDSCompetencyMng1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLDSCompetencyMng1", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 리더십역량관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLDSCompetencyMng2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLDSCompetencyMng2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLDSCompetencyMng2", convertMap);
		}

		return cnt;
	}
}