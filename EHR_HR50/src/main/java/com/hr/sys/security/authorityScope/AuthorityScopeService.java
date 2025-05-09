package com.hr.sys.security.authorityScope;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * authorityScope Service
 *
 * @author EW
 *
 */
@Service("AuthorityScopeService")
public class AuthorityScopeService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * authorityScope 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAuthorityScopeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAuthorityScopeList", paramMap);
	}

	/**
	 * authorityScope 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAuthorityScope(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAuthorityScope", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAuthorityScope", convertMap);
		}

		return cnt;
	}
	/**
	 * authorityScope 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAuthorityScopeMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAuthorityScopeMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
