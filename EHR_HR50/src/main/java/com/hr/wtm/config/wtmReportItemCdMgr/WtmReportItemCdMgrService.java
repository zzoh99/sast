package com.hr.wtm.config.wtmReportItemCdMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 리포트항목관리 Service
 *
 * @author bckim
 *
 */
@Service("WtmReportItemCdMgrService")
public class WtmReportItemCdMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 리포트항목관리 목록 조회
	 */
	public List<Map<String, Object>> getWtmReportItemCdMgrList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getWtmReportItemCdMgrList", paramMap);
	}

	/**
	 * 리포트항목관리 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> getWtmReportItemCdMgrOne(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> map = new HashMap<>();
		Map<String, Object> itemInfo = (Map<String, Object>) dao.getMap("getWtmReportItemCdMgrOne", paramMap);
		map.put("itemInfo", itemInfo);

		if (!itemInfo.isEmpty()) {
			paramMap.put("calcMethod", itemInfo.get("calcMethod"));
			map.put("methodCdList", getWtmReportItemCdMgrMethodCdList(paramMap));
			if ("Y".equals(itemInfo.get("convHourYn"))) {
				paramMap.put("grpCd", "WT0612");
				map.put("unitList", dao.getList("getCommonCodeList", paramMap));
			} else {
				map.put("unitList", new ArrayList<>());
			}
		} else {
			map.put("methodCdList", new ArrayList<>());
			map.put("unitList", new ArrayList<>());
		}

		return map;
	}

	/**
	 * 리포트항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmReportItemCdMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("saveWtmReportItemCdMgr", convertMap);
		return cnt;
	}

	/**
	 * 리포트항목관리 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWtmReportItemCdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if ( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
			cnt = dao.delete("deleteWtmReportItemCdMgr", convertMap);
		}
		return cnt;
	}

	/**
	 * 리포트항목관리 계산방법 코드리스트 조회
	 */
	public List<Map<String, Object>> getWtmReportItemCdMgrMethodCdList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getWtmReportItemCdMgrMethodCdList", paramMap);
	}
}