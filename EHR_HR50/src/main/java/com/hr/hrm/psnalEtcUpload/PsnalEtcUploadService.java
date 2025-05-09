package com.hr.hrm.psnalEtcUpload;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 기타사항업로드(기간) Service
 *
 * @author JSG
 *
 */
@Service("PsnalEtcUploadService")
public class PsnalEtcUploadService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 기타사항업로드(기간) Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalEtcUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalEtcUploadList", paramMap);
	}

	/**
	 * 기타사항업로드(기간) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalEtcUpload(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalEtcUpload", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalEtcUpload", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}