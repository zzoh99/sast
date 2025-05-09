package com.hr.pap.config.appCompItemCreateMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 역량평가표생성관리 Service
 * 
 * @author JSG
 *
 */
@Service("AppCompItemCreateMgrService")  
public class AppCompItemCreateMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 *  역량평가표생성관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppCompItemCreateMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppCompItemCreateMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 역량평가표생성관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppCompItemCreateMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppCompItemCreateMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 역량평가표생성관리 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppCompItemCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppCompItemCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 역량평가표생성관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppCompItemCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppCompItemCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 역량평가표생성관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppCompItemCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppCompItemCreateMgr", paramMap);
		Log.Debug();
		return cnt;
	}

}