package com.hr.org.job.jobRegApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 담당직무신청 Service
 *
 * @author jy
 *
 */
@Service("JobRegAppService")
public class JobRegAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 담당직무신청 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteJobRegApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteJobRegApp", convertMap);
			cnt += dao.delete("deleteJobRegAppGrid", convertMap);
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}
	
}