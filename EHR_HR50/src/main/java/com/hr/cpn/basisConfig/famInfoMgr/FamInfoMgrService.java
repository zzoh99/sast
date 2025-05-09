package com.hr.cpn.basisConfig.famInfoMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메뉴명 Service
 *
 * @author 이름
 *
 */
@Service("FamInfoMgrService")
public class FamInfoMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 메뉴명 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFamInfoMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFamInfoMgrList", paramMap);
	}
	/**
	 *  메뉴명 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getFamInfoMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getFamInfoMgrMap", paramMap);
	}
	/**
	 * 메뉴명 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveFamInfoMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteFamInfoMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveFamInfoMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 메뉴명 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteFamInfoMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteFamInfoMgr", paramMap);
	}


	/**
	 * 부양가족정보생성
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcFamilyInfoCreateCall(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Log.Debug("obj : "+paramMap);
		return (Map) dao.excute("prcFamilyInfoCreateCall", paramMap);
	}

	/**
	 * 부양가족정보생성
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map procP_CPN_FAM_UPDATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Log.Debug("obj : "+paramMap);
		return (Map) dao.excute("procP_CPN_FAM_UPDATE", paramMap);
	}
}