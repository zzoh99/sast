package com.hr.pap.config.appInternItemMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 촉탁직평가항목정의 Service
 *
 * @author JCY
 *
 */
@Service("AppInternItemMgrService")
public class AppInternItemMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 촉탁직평가항목정의 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppInternItemMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppInternItemMgrList", paramMap);
	}
	/**
	 *  촉탁직평가항목정의 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppInternItemMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppInternItemMgrMap", paramMap);
	}
	/**
	 * 촉탁직평가항목정의 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppInternItemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppInternItemMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppInternItemMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}