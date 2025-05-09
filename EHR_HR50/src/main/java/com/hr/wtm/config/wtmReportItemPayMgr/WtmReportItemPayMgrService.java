package com.hr.wtm.config.wtmReportItemPayMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 리포트항목지급관리 Service
 *
 * @author kwook
 *
 */
@Service("WtmReportItemPayMgrService")
public class WtmReportItemPayMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 리포트항목지급관리 리스트 조회
	 */
	public List<Map<String, Object>> getWtmReportItemPayMgrList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getWtmReportItemPayMgrList", paramMap);
	}

	/**
	 * 리포트항목지급관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmReportItemPayMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if (convertMap.containsKey("deleteRows") && convertMap.get("deleteRows") instanceof List && !((List<?>) convertMap.get("deleteRows")).isEmpty()) {
			cnt += dao.delete("deleteWtmReportItemPayMgr", convertMap);
		}

		if (convertMap.containsKey("mergeRows") && convertMap.get("mergeRows") instanceof List && !((List<?>) convertMap.get("mergeRows")).isEmpty()) {
			cnt += dao.update("saveWtmReportItemPayMgr", convertMap);
		}
		return cnt;
	}

	/**
	 * 리포트항목지급관리 리포트항목 코드리스트 조회
	 */
	public List<Map<String, Object>> getWtmReportItemPayMgrItemCdList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getWtmReportItemPayMgrItemCdList", paramMap);
	}
}