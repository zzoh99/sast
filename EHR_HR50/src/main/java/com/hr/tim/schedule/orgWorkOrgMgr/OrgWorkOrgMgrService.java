package com.hr.tim.schedule.orgWorkOrgMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.com.ComUtilService;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
/**
 * 근무조관리 Service
 * 
 * @author jcy
 *
 */
@Service("OrgWorkOrgMgrService")  
public class OrgWorkOrgMgrService extends ComUtilService{
	@Inject
	@Named("Dao")
	private Dao dao;
	

	/**
	 * 근무조관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgWorkOrgMgrOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgWorkOrgMgrOrgList", paramMap);
	}
	
	/**
	 * 근무조관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgWorkOrgMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgWorkOrgMgrList", paramMap);
	}
	

	/**
	 * saveOrgWorkOrgMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgWorkOrgMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgWorkOrgMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgWorkOrgMgr", convertMap);
		}
		
		//EDATE 자동생성 2020.06.03 
		prcComEdateCreate(convertMap, "TORG113", "mapTypeCd", "sabun", null);
		

		return cnt;
	}
	
	
}