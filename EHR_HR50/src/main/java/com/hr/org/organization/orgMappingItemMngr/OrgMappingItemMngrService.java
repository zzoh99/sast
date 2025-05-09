package com.hr.org.organization.orgMappingItemMngr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.com.ComUtilService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 조직구분항목 Service
 *
 * @author RyuSiOong
 *
 */
@Service("OrgMappingItemMngrService")
public class OrgMappingItemMngrService extends ComUtilService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 조직구분항목 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgMappingItemMngrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgMappingItemMngrList", paramMap);
	}
	/**
	 *  조직구분항목 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getOrgMappingItemMngrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getOrgMappingItemMngrMap", paramMap);
	}
	/**
	 * 조직구분항목 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgMappingItemMngr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgMappingItemMngr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgMappingItemMngrFirst", convertMap);
		}
		dao.update("saveOrgMappingItemMngrSecond", convertMap);

		//EDATE 자동생성 2020.06.03 
		prcComEdateCreate(convertMap, "TORG109", "mapTypeCd", "mapCd", null);
		
		
		Log.Debug();
		return cnt;
	}
	/**
	 * 조직구분항목 생성 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertOrgMappingItemMngr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertOrgMappingItemMngr", paramMap);
	}
	/**
	 * 조직구분항목 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateOrgMappingItemMngr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateOrgMappingItemMngr", paramMap);
	}
	/**
	 * 조직구분항목 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteOrgMappingItemMngr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteOrgMappingItemMngr", paramMap);
	}
}