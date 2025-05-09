package com.hr.hrm.psnalEtcMthUpload;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 기타사항업로드(지급율) Service
 *
 * @author JSG
 *
 */
@Service("PsnalEtcMthUploadService")
public class PsnalEtcMthUploadService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 기타사항업로드(지급율) Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalEtcMthUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalEtcMthUploadList", paramMap);
	}

	/**
	 * 기타사항업로드(지급율) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalEtcMthUpload(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalEtcMthUpload", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalEtcMthUpload", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}