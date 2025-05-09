package com.hr.pap.progress.mboUpload;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 개인별성과내역상세upload Service
 */
@Service("MboUploadService")
public class MboUploadService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 성과항목 헤더 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMboUploadElmList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMboUploadElmList", paramMap);
	}
	
	/**
	 * 개인별성과내역상세upload 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMboUpload", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMboUpload", convertMap);
		}
		return cnt;
	}
}
