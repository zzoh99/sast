package com.hr.org.organization.orgPersonStaList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * orgPersonStaList Service
 *
 * @author EW
 *
 */
@Service("OrgPersonStaListService")
public class OrgPersonStaListService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * orgPersonStaList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgPersonStaListList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgPersonStaListList", paramMap);
	}

	/**
	 * orgPersonStaList 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgPersonStaList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteOrgPersonStaList", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveOrgPersonStaList", convertMap);
		}

		return cnt;
	}
	/**
	 * orgPersonStaList 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getOrgPersonStaListMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getOrgPersonStaListMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
