package com.hr.pap.config.appClassAssignMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가등급부여기준 Service
 * 
 * @author jcy
 *
 */
@Service("AppClassAssignMgrService")  
public class AppClassAssignMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 평가등급부여기준 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppClassAssignMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppClassAssignMgrList", paramMap);
	}	
	/**
	 *  평가등급부여기준 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppClassAssignMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppClassAssignMgrMap", paramMap);
	}
	/**
	 * 평가등급부여기준 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppClassAssignMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppClassAssignMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppClassAssignMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}