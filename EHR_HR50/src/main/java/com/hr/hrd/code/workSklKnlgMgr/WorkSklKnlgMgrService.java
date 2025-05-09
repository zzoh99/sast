package com.hr.hrd.code.workSklKnlgMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 조직도관리 Service
 *
 * @author CBS
 *
 */
@Service("WorkSklKnlgMgrService")
public class WorkSklKnlgMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;


	public List<?> getWorkSklMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkSklMgrList", paramMap);
	}

	public List<?> getWorkKnlgMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkKnlgMgrList", paramMap);
	}

	public List<?> getTRMRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTRMRegList", paramMap);
	}


	public List<?> getTRMEduPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTRMEduPopupList", paramMap);
	}



	public List<?> getAppOrgSchemeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppOrgSchemeMgrList", paramMap);
	}

	/**
	 * 조직도관리 sheet2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTRM(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTRM", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTRM", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 *  TRM조회화면 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkSklKnlgMgrList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;

		String searchBizType = convertMap.get("searchBizType").toString();
		
		if("S".equals(searchBizType)){
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("deleteTcdpw514", convertMap);
			}
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				cnt += dao.update("saveTcdpw514", convertMap);
			}
		}else {
			if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
				cnt += dao.delete("deleteTcdpw513", convertMap);
			}
			if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				cnt += dao.update("saveTcdpw513", convertMap);
			}
		}
		
		Log.Debug();
		
		return cnt;
	}

}