package com.hr.cpn.payRetire.sepPenTypeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직연금유형관리 Service
 *
 * @author JM
 *
 */
@Service("SepPenTypeMgrService")
public class SepPenTypeMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직연금유형관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepPenTypeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepPenTypeMgrList", paramMap);
	}

	/**
	 * 퇴직연금유형관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepPenTypeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		int edateCnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepPenTypeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepPenTypeMgr", convertMap);
		}

		// 종료일 UPDATE
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){
			edateCnt += dao.update("updateSepPenTypeMgrEdate", convertMap);
		}

		return cnt;
	}
}