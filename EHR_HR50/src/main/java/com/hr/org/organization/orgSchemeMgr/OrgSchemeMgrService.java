package com.hr.org.organization.orgSchemeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.com.ComUtilService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 조직도관리 Service
 *
 * @author CBS
 *
 */
@Service("OrgSchemeMgrService")
public class OrgSchemeMgrService extends ComUtilService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 조직도관리 sheet1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgSchemeMgrSheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgSchemeMgrSheet1List", paramMap);
	}

	/**
	 * 조직도관리 sheet2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgSchemeMgrSheet2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgSchemeMgrSheet2List", paramMap);
	}
	/**
	 * 조직도관리 sheet1 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgSchemeMgrSheet1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgSchemeMgrSheet1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgSchemeMgrSheet1", convertMap);
		}
		
		//EDATE 자동생성 2020.06.03 
		prcComEdateCreate(convertMap, "TORG103", null, null, null);
		
		Log.Debug();
		return cnt;
	}
	/**
	 * 조직도관리 sheet1 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteOrgSchemeMgrSheet1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteOrgSchemeMgrSheet1", paramMap);
	}

	/**
	 * 조직도관리 sheet2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgSchemeMgrSheet2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgSchemeMgrSheet2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgSchemeMgrSheet2", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 조직도관리 sheet2 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteOrgSchemeMgrSheet2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteOrgSchemeMgrSheet2", paramMap);
	}

	/**
	 * 직제 소팅을 위한 정렬 순서 생성
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcOrgSchemeSortCreateCall(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcOrgSchemeSortCreateCall", paramMap);
	}
}