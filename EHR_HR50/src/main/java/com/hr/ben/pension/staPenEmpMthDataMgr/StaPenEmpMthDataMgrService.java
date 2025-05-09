package com.hr.ben.pension.staPenEmpMthDataMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 국민연금 고지금액관리 Service
 *
 * @author JM
 *
 */
@Service("StaPenEmpMthDataMgrService")
public class StaPenEmpMthDataMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 국민연금 고지금액관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getStaPenEmpMthDataMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("Service : StaPenEmpMthDataMgrService.getStaPenEmpMthDataMgrList");

		return (List<?>) dao.getList("getStaPenEmpMthDataMgrList", paramMap);
	}

	/**
	 * 국민연금 고지금액관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStaPenEmpMthDataMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug("Service : StaPenEmpMthDataMgrService.saveStaPenEmpMthDataMgr");

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteStaPenEmpMthDataMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveStaPenEmpMthDataMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * 국민연금 전체삭제
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteStaPenEmpMthDataMgrAll(Map<?, ?> paramMap) throws Exception {
		Log.Debug("staPenEmpMthDataMgrService.deleteAnnualSalaryPeopleMngrAll Start");
		int cnt = dao.delete("deleteStaPenEmpMthDataMgrAll", paramMap);
		Log.Debug("staPenEmpMthDataMgrService.deleteAnnualSalaryPeopleMngrAll End");
		return cnt;
	}
}