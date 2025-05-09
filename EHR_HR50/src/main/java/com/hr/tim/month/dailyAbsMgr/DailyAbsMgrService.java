package com.hr.tim.month.dailyAbsMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 결근처리 Service
 *
 * @author EW
 *
 */
@Service("DailyAbsMgrService")
public class DailyAbsMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * 결근처리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDailyAbsMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			
			cnt += dao.delete("deleteDailyAbsMgr", convertMap);
			cnt += dao.update("saveDailyAbsMgr", convertMap);
			dao.excute("prcDailyAbsMgr", convertMap);
		}
		
		return cnt;
	}
}
