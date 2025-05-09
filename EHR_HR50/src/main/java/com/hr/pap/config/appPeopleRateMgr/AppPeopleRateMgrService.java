package com.hr.pap.config.appPeopleRateMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 부서이동대상자평가반영비율 Service
 *
 * @author JCY
 *
 */
@Service("AppPeopleRateMgrService")
public class AppPeopleRateMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 부서이동대상자평가반영비율 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppPeopleRateMgr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppPeopleRateMgr2", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}