package com.hr.sys.other.sysBoradStdMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * sysBoradStdMgr Service
 *
 * @author EW
 *
 */
@Service("SysBoradStdMgrService")
public class SysBoradStdMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * sysBoradStdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSysBoradStdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSysBoradStdMgrList", paramMap);
	}

	/**
	 * sysBoradStdMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSysBoradStdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSysBoradStdMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSysBoradStdMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * sysBoradStdMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSysBoradStdMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSysBoradStdMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
