package com.hr.sys.security.widgetMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 위젯관리 Service
 *
 * @author 이름
 *
 */
@Service("WidgetMgrService")
public class WidgetMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 통계차트 정보 (통계코드)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getStatsWidgetInfo(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		Map<String, Object> header=(Map<String, Object>) dao.getMap("getStatsWidgetHeader", paramMap);
		List<Map<String, Object>> data=(List<Map<String, Object>>) dao.getList("getStatsWidgetData", header);

		header.remove("sqlSyntax");
		header.put("data", data);

		return header;
	}
}