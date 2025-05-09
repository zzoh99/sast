package com.hr.cpn.payRetroact.retroEleSetMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 소급대상소득선정 Service
 *
 * @author JM
 *
 */
@Service("RetroEleSetMgrService")
public class RetroEleSetMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 소급대상소득선정 Master 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroEleSetMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroEleSetMgrList", paramMap);
	}

	/**
	 * 소급대상소득선정 Detail 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetroEleSetMgrDtlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getRetroEleSetMgrDtlList", paramMap);
	}

	/**
	 * 소급대상소득선정 Master 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetroEleSetMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetroEleSetMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetroEleSetMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * 소급대상소득선정 Detail 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetroEleSetMgrDtl(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetroEleSetMgrDtl", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetroEleSetMgrDtl", convertMap);
		}

		return cnt;
	}

	/**
	 * 소급대상소득선정 소급대상데이터 생성
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_RETRO_ELE_INS(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("RetroEleSetMgrP_CPN_RETRO_ELE_INS", paramMap);
	}
}