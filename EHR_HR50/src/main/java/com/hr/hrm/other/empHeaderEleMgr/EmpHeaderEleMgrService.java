package com.hr.hrm.other.empHeaderEleMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * empHeaderEleMgr Service
 *
 * @author EW
 *
 */
@Service("EmpHeaderEleMgrService")
public class EmpHeaderEleMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * empHeaderEleMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpHeaderEleMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpHeaderEleMgrList", paramMap);
	}

	/**
	 * empHeaderEleMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpHeaderEleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpHeaderEleMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpHeaderEleMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * empHeaderEleMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpHeaderEleMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmpHeaderEleMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
