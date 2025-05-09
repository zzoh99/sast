package com.hr.hrd.pubc.pubcApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 사내공모신청 Service
 *
 * @author JSG
 *
 */
@Service("PubcAppService")
public class PubcAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 사내공모신청 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPubcAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPubcAppList", paramMap);
	}

	/**
	 * 사내공모 내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPubcAppList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPubcAppList2", paramMap);
	}
	
	/**
	 * 사내공모신청 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePubcApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePubcApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}

}