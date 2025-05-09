package com.hr.org.job.jobRegAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 담당직무신청 세부내역 Service
 *
 * @author jy
 *
 */
@Service("JobRegAppDetService")
public class JobRegAppDetService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 담당직무신청 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobRegAppDet(Map<?, ?> paramMap, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobRegAppDetGrid", convertMap);
		}
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.update("deleteJobRegAppDetGrid", convertMap);
		}
		cnt += dao.update("saveJobRegAppDet", paramMap);

		return cnt;
	}
	
	/**
	 * 담당직무신청 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobRegAppDetGrid(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobRegAppDetGrid", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobRegAppDetGrid", convertMap);
		}
		
		return cnt;
	}
	
}