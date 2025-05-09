package com.hr.pap.evaluation.appEvalCommissioner;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 인사위원회 Service
 * 
 * @author jcy
 *
 */
@Service("AppEvalCommissionerService")  
public class AppEvalCommissionerService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 인사위원회 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppEvalCommissionerList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppEvalCommissionerList", paramMap);
	}	
	/**
	 * 평가년도 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getAppEvalCommissionerAppraisalYy(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppEvalCommissionerAppraisalYy", paramMap);
	}	
	/**
	 * 평가척도 등급점수 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getAppEvalCommissionerPerformancePoint(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppEvalCommissionerPerformancePoint", paramMap);
	}
	
	
	/**
	 * 인사위원회 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppEvalCommissioner(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppEvalCommissioner", convertMap);
		}

		Log.Debug();
		return cnt;
	}
	
}