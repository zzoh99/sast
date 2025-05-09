package com.hr.hrm.other.hrQueryApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * hrQueryApp Service
 *
 * @author EW
 *
 */
@Service("HrQueryAppService")
public class HrQueryAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * hrQueryApp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrQueryAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrQueryAppList", paramMap);
	}

	/**
	 * hrQueryApp 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHrQueryApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHrQueryApp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHrQueryApp", convertMap);
		}

		return cnt;
	}
	/**
	 * hrQueryApp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHrQueryAppMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getHrQueryAppMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
