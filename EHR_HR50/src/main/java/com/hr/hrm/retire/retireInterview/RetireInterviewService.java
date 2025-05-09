package com.hr.hrm.retire.retireInterview;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직면담 Service
 *
 * @author bckim
 *
 */
@Service("RetireInterviewService")
public class RetireInterviewService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직면담 대상자 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireInterviewList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireInterviewList", paramMap);
	}
	
	/**
	 * 퇴직면담 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireRecodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireRecodeList", paramMap);
	}
	
	/**
	 *  퇴직면담 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireInterview(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetireInterview", convertMap);
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireInterview", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}