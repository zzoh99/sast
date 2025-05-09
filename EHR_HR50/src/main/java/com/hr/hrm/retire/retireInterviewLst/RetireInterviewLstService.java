package com.hr.hrm.retire.retireInterviewLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * retireInterviewLst Service
 *
 * @author EW
 *
 */
@Service("RetireInterviewLstService")
public class RetireInterviewLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * retireInterviewLst 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireInterviewLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireInterviewLstList", paramMap);
	}

	/**
	 * retireInterviewLst 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireInterviewLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetireInterviewLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireInterviewLst", convertMap);
		}

		return cnt;
	}
	/**
	 * retireInterviewLst 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getRetireInterviewLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getRetireInterviewLstMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
