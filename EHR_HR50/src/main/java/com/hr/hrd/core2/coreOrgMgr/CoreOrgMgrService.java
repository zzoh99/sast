package com.hr.hrd.core2.coreOrgMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * orgTotalMgr Service
 *
 * @author EW
 *
 */
@Service("CoreOrgMgrService")
public class CoreOrgMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * coreOrgMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCoreOrgMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCoreOrgMgrList", paramMap);
	}

	/**
	 * coreOrgManagerList1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCoreOrgManagerList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCoreOrgManagerList1", paramMap);
	}

	/**
	 * coreOrgManagerList2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCoreOrgManagerList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCoreOrgManagerList2", paramMap);
	}

	/**
	 * coreOrgTotalMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCoreOrgMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if (!((List<?>) convertMap.get("mergeRows")).isEmpty()) {
			cnt += dao.update("saveCoreOrgMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * coreOrgManagerList 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCoreOrgManagerList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if(!((List<?>) convertMap.get("deleteRows")).isEmpty()){
			cnt += dao.delete("deleteCoreOrgManagerList", convertMap);
		}
		if(!((List<?>) convertMap.get("mergeRows")).isEmpty()){
			cnt += dao.update("saveCoreOrgManagerList", convertMap);
		}

		return cnt;
	}

	/**
	 * CoreOrgMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getCoreOrgMgrMemoTORG103(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCoreOrgMgrMemoTORG103", paramMap);
	}

	/**
	 * getCoreOrgMgrMaxOrgChartMap 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCoreOrgMgrMaxOrgChartMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCoreOrgMgrMaxOrgChartMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
