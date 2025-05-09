package com.hr.tim.schedule.flexibleWorkOrgMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근무제대상자관리 Service
 *
 * @author
 *
 */
@Service("FlexibleWorkOrgMgrService")
public class FlexibleWorkOrgMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  근무제대상자관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFlexibleWorkOrgMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFlexibleWorkOrgMgrList", paramMap);
	}

	/**
	 *  근무제대상자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveFlexibleWorkOrgMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteFlexibleWorkOrgMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveFlexibleWorkOrgMgr", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	public List<?> getFlexibleWorkOrgMgrTblNm(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getFlexibleWorkOrgMgrTblNm", paramMap);
		Log.Debug();
		return resultList;
	}

	public List<?> getFlexibleWorkOrgMgrScopeCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getFlexibleWorkOrgMgrScopeCd", paramMap);
		Log.Debug();
		return resultList;
	}
}