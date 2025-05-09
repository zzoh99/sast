package com.hr.cpn.payRetroact.retroExceAllowDedMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 소급예외수당관리 Service
 *
 * @author JM
 *
 */
@Service("RetroExceAllowDedMgrService")
public class RetroExceAllowDedMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 소급예외수당관리 Master 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroExceAllowDedMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroExceAllowDedMgrList", paramMap);
	}

	/**
	 * 소급예외수당관리 Detail 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroExceAllowDedMgrDtlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroExceAllowDedMgrDtlList", paramMap);
	}

	/**
	 * 소급예외수당관리 대상일자 팝입 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroExceAllowDedMgrRtrPayActionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroExceAllowDedMgrRtrPayActionList", paramMap);
	}

	/**
	 * 소급예외수당관리 항목명 팝입 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroExceAllowDedMgrElementList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroExceAllowDedMgrElementList", paramMap);
	}

	/**
	 * 소급예외수당관리 Master 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetroExceAllowDedMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetroExceAllowDedMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetroExceAllowDedMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * 소급예외수당관리 Detail 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetroExceAllowDedMgrDtl(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetroExceAllowDedMgrDtl", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetroExceAllowDedMgrDtl", convertMap);
		}

		return cnt;
	}

	/**
	 * 소급예외수당관리 소급대상데이터 생성
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_PAY_RETROACT_MAKE_ITEM(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("RetroExceAllowDedMgrP_CPN_PAY_RETROACT_MAKE_ITEM", paramMap);
	}
}