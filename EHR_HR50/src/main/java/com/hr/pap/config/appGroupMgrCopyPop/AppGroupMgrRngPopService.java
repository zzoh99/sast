package com.hr.pap.config.appGroupMgrCopyPop;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가그룹설정 - 평가범위설정 Service
 * 
 * @author jcy
 *
 */
@Service("AppGroupMgrRngPopService")  
public class AppGroupMgrRngPopService{
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * 평가그룹설정 - 평가범위설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrRngPopList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGroupMgrRngPopList2", paramMap);
	}
	
	/**
	 * 평가그룹설정 - 평가범위설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrRngPopList3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGroupMgrRngPopList3", paramMap);
	}	
	
	/**
	 * 평가그룹설정 - 평가범위설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrRngPopList4(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGroupMgrRngPopList4", paramMap);
	}
	
	/**
	 * 평가그룹설정 - 평가범위설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrRngPopList5(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGroupMgrRngPopList5", paramMap);
	}
	
	/**
	 * 평가그룹설정 - 평가범위설정 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGroupMgrRngPopList6(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGroupMgrRngPopList6", paramMap);
	}
	
	/**
	 *  평가그룹설정 - 평가범위설정 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppGroupMgrRngPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppGroupMgrRngPopMap", paramMap);
	}
	
	/**
	 *  평가그룹설정 - 평가범위설정 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppGroupMgrRngPopTempQueryMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppGroupMgrRngPopTempQueryMap", paramMap);
	}
	
	
	
	/**
	 * 평가그룹설정 - 평가범위설정 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGroupMgrRngPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGroupMgrRngPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGroupMgrRngPop", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}