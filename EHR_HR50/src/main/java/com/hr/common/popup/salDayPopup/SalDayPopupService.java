package com.hr.common.popup.salDayPopup;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여일자조회 Service
 *
 * @author EW
 *
 */
@Service("SalDayPopupService")
public class SalDayPopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급여일자조회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSalDayPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSalDayPopupList", paramMap);
	}

	/**
	 * 급여일자조회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSalDayAdminPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSalDayAdminPopupList", paramMap);
	}

	/**
	 * 급여일자조회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSalDayUserPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSalDayUserPopupList", paramMap);
	}

	/**
	 * 급여일자조회 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSalDayPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSalDayPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSalDayPopup", convertMap);
		}

		return cnt;
	}
	/**
	 * 급여일자조회 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSalDayLastestPaymentInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getSalDayLastestPaymentInfoMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 급여일자조회 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> salDayPopupPrc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("salDayPopupPrc", paramMap);
	}
}
