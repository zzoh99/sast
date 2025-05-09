package com.hr.cpn.payCalculate.payEmpNonDedMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 미공제내역관리 Service
 *
 * @author JM
 *
 */
@Service("PayEmpNonDedMgrService")
public class PayEmpNonDedMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 미공제내역관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayEmpNonDedMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPayEmpNonDedMgrList", paramMap);
	}

	/**
	 * 미공제내역관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayEmpNonDedMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayEmpNonDedMgr", convertMap);
		}

		return cnt;
	}
}