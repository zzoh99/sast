package com.hr.hrm.retire.retireMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직설문항목관리 Service
 *
 * @author EW
 *
 */
@Service("RetireMgrService")
public class RetireMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직설문항목관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireMgrList", paramMap);
	}

	/**
	 * 퇴직설문항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetireMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireMgr", convertMap);
		}

		return cnt;
	}
}
