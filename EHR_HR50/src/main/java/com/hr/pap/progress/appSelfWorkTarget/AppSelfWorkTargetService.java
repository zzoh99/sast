package com.hr.pap.progress.appSelfWorkTarget;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 업무개선도출력 Service
 *
 * @author EW
 *
 */
@Service("AppSelfWorkTargetService")
public class AppSelfWorkTargetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 업무개선도출력 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfWorkTargetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSelfWorkTargetList", paramMap);
	}

	/**
	 * 업무개선도출력 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppSelfWorkTarget(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppSelfWorkTarget", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSelfWorkTarget", convertMap);
		}

		return cnt;
	}
}
