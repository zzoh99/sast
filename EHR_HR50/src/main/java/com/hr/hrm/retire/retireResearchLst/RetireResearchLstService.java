package com.hr.hrm.retire.retireResearchLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * retireResearchLst Service
 *
 * @author EW
 *
 */
@Service("RetireResearchLstService")
public class RetireResearchLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * retireResearchLst 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireResearchLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireResearchLstList", paramMap);
	}

	/**
	 * retireResearchLst 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireResearchLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetireResearchLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireResearchLst", convertMap);
		}

		return cnt;
	}
	/**
	 * retireResearchLst 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getRetireResearchLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getRetireResearchLstMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
