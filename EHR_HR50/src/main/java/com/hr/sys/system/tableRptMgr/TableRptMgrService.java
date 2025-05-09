package com.hr.sys.system.tableRptMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * tableRptMgr Service
 *
 * @author EW
 *
 */
@Service("TableRptMgrService")
public class TableRptMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * tableRptMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTableRptMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTableRptMgrList", paramMap);
	}

	/**
	 * tableRptMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTableRptMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTableRptMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTableRptMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * tableRptMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getTableRptMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getTableRptMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
