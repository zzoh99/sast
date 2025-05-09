package com.hr.hrm.promotion.promStdMgr.promStdAppr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진급기준관리평가탭 Service
 *
 * @author EW
 *
 */
@Service("PromStdApprService")
public class PromStdApprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 승진급기준관리평가탭 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdApprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdApprList", paramMap);
	}

	/**
	 * 승진급기준관리평가탭 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromStdAppr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromStdAppr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromStdAppr", convertMap);
		}

		return cnt;
	}
}
