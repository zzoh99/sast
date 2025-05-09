package com.hr.org.organization.orgMappingPersonSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * orgMappingPersonSta Service
 *
 * @author EW
 *
 */
@Service("OrgMappingPersonStaService")
public class OrgMappingPersonStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * orgMappingPersonSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMappingPersonStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMappingPersonStaList", paramMap);
	}
	
	/**
	 * orgMappingPersonSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMappingPersonStaListNull(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMappingPersonStaListNull", paramMap);
	}

	/**
	 * orgMappingPersonSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgMappingPersonSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgMappingPersonSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgMappingPersonSta", convertMap);
		}

		return cnt;
	}

	/**
	 * orgMappingPersonSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMappingPersonStaTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMappingPersonStaTitleList", paramMap);
	}
}
