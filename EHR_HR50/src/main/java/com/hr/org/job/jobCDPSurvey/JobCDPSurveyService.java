package com.hr.org.job.jobCDPSurvey;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 희망직무조사 Service
 *
 * @author jy
 *
 */
@Service("JobCDPSurveyService")
public class JobCDPSurveyService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 직무기술서 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobCDPSurveyWish(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobCDPSurveyWish", convertMap);
			cnt += dao.delete("deleteJobCDPSurveyCareer", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobCDPSurveyWish", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 경력개발계획 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobCDPSurveyCareer(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobCDPSurveyCareer", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobCDPSurveyCareer", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
}