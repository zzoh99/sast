package com.hr.pap.config.appRateMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 종합평가반영비율 Service
 * 
 * @author JCY
 *
 */
@Service("AppRateMgrService")  
public class AppRateMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 종합평가반영비율 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppRateMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getAppRateMgrList", paramMap);
		Log.Debug();
		return resultList;
	}	
	
	/**
	 *  종합평가반영비율 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppRateMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppRateMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 종합평가반영비율 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppRateMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppRateMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppRateMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 종합평가반영비율 - 종합평가반영비율복사 팝업 - 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppRateMgrCopyPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
			cnt += dao.delete("deleteAppRateMgrCopyPop", convertMap);
			cnt += dao.create("insertAppRateMgrCopyPop", convertMap);
		Log.Debug();
		return cnt;
	}
	
	
	/**
	 * 종합평가반영비율 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppRateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppRateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 종합평가반영비율 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppRateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppRateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 종합평가반영비율 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppRateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppRateMgr", paramMap);
		Log.Debug();
		return cnt;
	}
}