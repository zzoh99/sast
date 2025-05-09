package com.hr.pap.config.appFixedItemsMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 역량평가표생성관리 Service
 * 
 * @author JSG
 *
 */
@Service("AppFixedItemsMgrService")  
public class AppFixedItemsMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * getAppFixedItemsMgrList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppFixedItemsMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppFixedItemsMgrList", paramMap);
	}
	/**
	 * 고정항목 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppFixedItemsMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppFixedItemsMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppFixedItemsMgr", convertMap);
		}

		return cnt;
	}
}