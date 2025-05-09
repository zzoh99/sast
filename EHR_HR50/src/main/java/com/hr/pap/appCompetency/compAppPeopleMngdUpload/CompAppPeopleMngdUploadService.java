package com.hr.pap.appCompetency.compAppPeopleMngdUpload;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 리더십진단대상자Upload Service
 *
 * @author JSG
 *
 */
@Service("CompAppPeopleMngdUploadService")
public class CompAppPeopleMngdUploadService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 리더십진단평가자Upload 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppPeopleMngdUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppPeopleMngdUploadList", paramMap);
	}
	
	
	/**
	 * 리더십진단대상자Upload 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppPeopleMngdUploadList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppPeopleMngdUploadList2", paramMap);
	}


	/**
	 * 리더십진단평가자Upload 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppPeopleMngdUpload(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompAppPeopleMngdUpload", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			// 삭제후 저장한다
			convertMap.put("deleteType", "I");
			cnt += dao.delete("deleteCompAppPeopleMngdUpload", convertMap);
			cnt += dao.update("saveCompAppPeopleMngdUpload", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 리더십진단대상자Upload 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppPeopleMngdUpload2(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompAppPeopleMngdUpload1", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			// 삭제후 저장한다
			convertMap.put("deleteType", "I");
			cnt += dao.delete("deleteCompAppPeopleMngdUpload1", convertMap);
			cnt += dao.update("saveCompAppPeopleMngdUpload1", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}