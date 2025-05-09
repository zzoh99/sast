package com.hr.hri.applicationBasis.appCodeMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

@Service("AppCodeMgrService") 
public class AppCodeMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getAppCodeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppCodeMgrList", paramMap);
	}
	
	public int saveAppCodeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppCodeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppCodeMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}	
	
	public List<?> getAppCodeMgrPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppCodeMgrPopupList", paramMap);
	}
	
	public int saveAppCodeMgrPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppCodeMgrPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppCodeMgrPopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 유의사항 저장 Service(첨부파일 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppAttFile(Map<?, ?> paramMap) throws Exception {
		Log.Debug("AppCodeMgrService.saveAppAttFile Start");
		int cnt=0;

		cnt += dao.update("saveAppAttFile2", paramMap);

		Log.Debug("AppCodeMgrService.saveAppAttFile End");
		return cnt;
	}

	public List<?> getAppCodeSearchSeqList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppCodeSearchSeqList", paramMap);
	}
}