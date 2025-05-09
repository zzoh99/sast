package com.hr.tim.workApp.holWorkAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 휴일근무신청 Service
 *
 * @author EW
 *
 */
@Service("HolWorkAppDetService")
public class HolWorkAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 신청자 개인정보 조회
	 */
	public Map<?, ?> getHolWorkAppDetUserInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getHolWorkAppDetUserMap", paramMap); 
		Log.Debug();
		return resultMap;
	}
	
}
