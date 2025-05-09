package com.hr.hrm.psnalEtcMonUpload;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 기타사항업로드(금액) Service
 *
 * @author JSG
 *
 */
@Service("PsnalEtcMonUploadService")
public class PsnalEtcMonUploadService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 기타사항업로드(금액) Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalEtcMonUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalEtcMonUploadList", paramMap);
	}

	/**
	 * 기타사항업로드(금액) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalEtcMonUpload(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalEtcMonUpload", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalEtcMonUpload", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}