package com.hr.hrm.appmt.timeOffPatAppmtFamMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 육아휴직 대상자녀 관리 Service
 * @author P19246
 *
 */
@Service("TimeOffPatAppmtFamMgrService")
public class TimeOffPatAppmtFamMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 육아휴직 대상자녀 관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimeOffPatAppmtFamMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimeOffPatAppmtFamMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}
