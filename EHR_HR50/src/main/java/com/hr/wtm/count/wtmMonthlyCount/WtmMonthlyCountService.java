package com.hr.wtm.count.wtmMonthlyCount;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.popup.pwrSrchResultPopup.PwrSrchResultPopupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.Map;


/**
 * 월근태/근무집계 Service
 *
 * @author bckim
 *
 */
@Service("WtmMonthlyCountService")
public class WtmMonthlyCountService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private PwrSrchResultPopupService pwrSrchResultPopupService;

	/**
	 * 월근태/근무집계 정보 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmMonthlyCountStatus(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getWtmMonthlyCountStatus", paramMap);
	}

	/**
	 * 월근태/근무집계(작업) 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> excWtmMonthlyCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.excute("excWtmMonthlyCount", paramMap);
	}

	/**
	 * 월근태/근무집계(작업취소) 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> excWtmMonthlyCountCancel(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.excute("excWtmMonthlyCountCancel", paramMap);
	}

	/**
	 * 월근태/근무집계(마감) Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateWtmMonthlyCountClose(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateWtmMonthlyCountClose", paramMap);
		return cnt;
	}

	/**
	 * 월근태/근무집계(마감취소) Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateWtmMonthlyCountCloseCancel(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateWtmMonthlyCountCloseCancel", paramMap);
		return cnt;
	}
}