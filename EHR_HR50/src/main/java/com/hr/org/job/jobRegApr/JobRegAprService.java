package com.hr.org.job.jobRegApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 담당직무승인 Service
 *
 * @author jy
 *
 */
@Service("JobRegAprService")
public class JobRegAprService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 담당직무승인 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveJobRegApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveJobRegApr", convertMap);
		}

		return cnt;
	}
	
}