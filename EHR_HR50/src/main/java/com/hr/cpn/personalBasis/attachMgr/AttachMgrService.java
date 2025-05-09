package com.hr.cpn.personalBasis.attachMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 압류관리 Service
 *
 * @author JM
 *
 */
@Service("AttachMgrService")
public class AttachMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 압류관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAttachMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getAttachMgrList", paramMap);
	}

	/**
	 * 압류관리 압류세부내역 압류사건별공탁정보 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAttachMgrDepositInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getAttachMgrDepositInfoList", paramMap);
	}

	/**
	 * 압류관리 압류세부내역 팝업 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAttachMgrDtl(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("saveAttachMgrDtl", convertMap);

		return cnt;
	}

	/**
	 * 압류관리 압류관리 저장(삭제) Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAttachMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		int depositCnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAttachMgr", convertMap);

			// 압류관리_압류사건별공탁정보 삭제
			depositCnt += dao.delete("deleteAllAttachMgrDepositInfo", convertMap);
		}

		return cnt;
	}

	/**
	 * 압류관리 압류세부내역 압류사건별공탁정보 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAttachMgrDepositInfo(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAttachMgrDepositInfo", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAttachMgrDepositInfo", convertMap);
		}

		return cnt;
	}
}