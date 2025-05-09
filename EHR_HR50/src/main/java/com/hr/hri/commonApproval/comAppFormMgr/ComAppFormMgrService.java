package com.hr.hri.commonApproval.comAppFormMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 공통신청서양식관리 Service
 * 
 * @author 이름
 *
 */
@Service("ComAppFormMgrService")  
public class ComAppFormMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveComAppFormMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteComAppFormMgr", convertMap);
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveComAppFormMgr", convertMap);
			
			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
			dao.batchUpdate("updateComAppFormMgr", (List<Map<?,?>>)convertMap.get("mergeRows"));
		}

		
		Log.Debug();
		return cnt;
	}
}