package com.hr.hrm.job.jobQualificationPopup;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * JobQualificationPopup Service
 *
 * @author jy
 *
 */
@Service("JobQualificationPopupService")
public class JobQualificationPopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * JobQualificationPopup 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobQualificationPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobQualificationPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobQualificationPopup", convertMap);
		}

		return cnt;
	}
}
