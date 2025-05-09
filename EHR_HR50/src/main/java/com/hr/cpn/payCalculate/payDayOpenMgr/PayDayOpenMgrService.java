package com.hr.cpn.payCalculate.payDayOpenMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * payDayOpenMgr Service
 *
 * @author EW
 *
 */
@Service("PayDayOpenMgrService")
public class PayDayOpenMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * payDayOpenMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayDayOpenMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayDayOpenMgrList", paramMap);
	}

	/**
	 * payDayOpenMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayDayOpenMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayDayOpenMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayDayOpenMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * payDayOpenMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPayDayOpenMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPayDayOpenMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
