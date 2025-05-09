package com.hr.cpn.element.eleLinkMonMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * eleLinkMonMgr Service
 *
 * @author EW
 *
 */
@Service("EleLinkMonMgrService")
public class EleLinkMonMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * eleLinkMonMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEleLinkMonMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEleLinkMonMgrList", paramMap);
	}

	/**
	 * eleLinkMonMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEleLinkMonMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEleLinkMonMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEleLinkMonMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * eleLinkMonMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEleLinkMonMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEleLinkMonMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
