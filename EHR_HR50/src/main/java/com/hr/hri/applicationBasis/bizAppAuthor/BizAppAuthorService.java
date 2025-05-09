package com.hr.hri.applicationBasis.bizAppAuthor;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * bizAppAuthor Service
 *
 * @author EW
 *
 */
@Service("BizAppAuthorService")
public class BizAppAuthorService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * bizAppAuthor 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBizAppAuthorList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getBizAppAuthorList", paramMap);
	}

	/**
	 * bizAppAuthor 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBizAppAuthor(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBizAppAuthor", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBizAppAuthor", convertMap);
		}

		return cnt;
	}
	/**
	 * bizAppAuthor 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getBizAppAuthorMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getBizAppAuthorMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
