package com.hr.ben.resort.resortSeasonMgrPop;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 리조트 성수기 관리 팝업 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("ResortSeasonMgrPopService")
public class ResortSeasonMgrPopService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 리조트 신청건 예약상태 변경 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveResortSeasonMgrPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
			cnt += dao.delete("saveResortSeasonMgrPop1", convertMap);
			cnt += dao.delete("saveResortSeasonMgrPop2", convertMap);

		return cnt;
	}
}