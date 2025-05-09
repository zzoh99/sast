package com.hr.cpn.element.allowEleMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * allowEleMgr Service
 *
 * @author EW
 *
 */
@Service("AllowEleMgrService")
public class AllowEleMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * allowEleMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAllowEleMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAllowEleMgrList", paramMap);
	}

	/**
	 * allowEleMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAllowEleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAllowEleMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAllowEleMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * allowEleMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAllowEleMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAllowEleMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
