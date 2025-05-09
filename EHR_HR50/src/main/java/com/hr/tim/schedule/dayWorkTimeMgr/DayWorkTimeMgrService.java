package com.hr.tim.schedule.dayWorkTimeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 일일근무시간설정 Service
 * 
 * @author jcy
 *
 */
@Service("DayWorkTimeMgrService")  
public class DayWorkTimeMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 일일근무시간설정 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDayWorkTimeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		dao.delete("deleteDayWorkTimeMgrAll", convertMap);
		cnt += dao.update("saveDayWorkTimeMgr", convertMap);

		return cnt;
	}
}