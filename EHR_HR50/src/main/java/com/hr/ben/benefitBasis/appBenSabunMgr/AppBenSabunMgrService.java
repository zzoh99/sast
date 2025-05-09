package com.hr.ben.benefitBasis.appBenSabunMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * appBenSabunMgr Service
 *
 * @author EW
 *
 */
@Service("AppBenSabunMgrService")
public class AppBenSabunMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * appBenSabunMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppBenSabunMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppBenSabunMgrList", paramMap);
	}

	/**
	 * appBenSabunMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppBenSabunMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppBenSabunMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppBenSabunMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * appBenSabunMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAppBenSabunMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppBenSabunMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
