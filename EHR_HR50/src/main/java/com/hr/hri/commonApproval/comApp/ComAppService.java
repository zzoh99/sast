package com.hr.hri.commonApproval.comApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 공통신청 Service
 *
 * @author EW
 *
 */
@Service("ComAppService")
public class ComAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 공통신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteComApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteComApp", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
	

	public Map<?, ?> getComAppApplNm(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getComAppApplNm", paramMap );
	}
}
