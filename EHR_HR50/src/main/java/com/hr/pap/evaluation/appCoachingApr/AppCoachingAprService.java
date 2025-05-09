package com.hr.pap.evaluation.appCoachingApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * Coaching관리 Service
 * 
 * @author JCY
 *
 */
@Service("AppCoachingAprService")  
public class AppCoachingAprService{
	@Inject
	@Named("Dao")
	private Dao dao;

	
	public int saveCoachingAprPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveCoachingAprPop", convertMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 중복체크 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getCoachingAprDupChk(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getCoachingAprDupChk", paramMap);
	}
}