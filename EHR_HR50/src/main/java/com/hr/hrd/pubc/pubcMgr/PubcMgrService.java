package com.hr.hrd.pubc.pubcMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 사내공모관리 Service
 *
 * @author
 *
 */
@Service("PubcMgrService")
public class PubcMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  사내공모관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPubcMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPubcMgrList", paramMap);
	}

	/**
	 *  사내공모관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePubcMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePubcMgr", convertMap);
			cnt += dao.delete("deletePubcMgrAppTHRI107", convertMap);
			cnt += dao.delete("deletePubcMgrAppTHRI103", convertMap);
			cnt += dao.delete("deletePubcMgrApp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePubcMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}
