package com.hr.pap.progress.appResultUpload;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 업적점수결과업로드 Service
 *
 * @author EW
 *
 */
@Service("AppResultUploadService")
public class AppResultUploadService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 업적점수결과업로드 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppResultUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppResultUploadList", paramMap);
	}

	/**
	 * 업적점수결과업로드 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppResultUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppResultUpload", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppResultUpload", convertMap);
		}

		return cnt;
	}
}
