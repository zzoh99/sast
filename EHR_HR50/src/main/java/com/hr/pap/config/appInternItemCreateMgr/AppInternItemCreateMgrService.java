package com.hr.pap.config.appInternItemCreateMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 촉탁직평가표생성관리 Service
 *
 * @author JCY
 *
 */
@Service("AppInternItemCreateMgrService")
public class AppInternItemCreateMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 촉탁직평가표생성관리 -생성결과- 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppInternItemCreateMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppInternItemCreateMgrList", paramMap);
	}

	/**
	 * 촉탁직평가표생성관리 -생성관리- 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppInternItemCreateMgrList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppInternItemCreateMgrList1", paramMap);
	}


	/**
	 *  촉탁직평가표생성관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppInternItemCreateMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppInternItemCreateMgrMap", paramMap);
	}
	/**
	 * 촉탁직평가표생성관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppInternItemCreateMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppInternItemCreateMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppInternItemCreateMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}


	/**
	 * 촉탁직평가표생성관리 -촉탁직평가표생성 - 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppInternItemCreateMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppInternItemCreateMgr", paramMap);
	}

}