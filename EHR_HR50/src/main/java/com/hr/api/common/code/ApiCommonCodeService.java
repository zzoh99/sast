package com.hr.api.common.code;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;


@Service("ApiCommonCodeService")
public class ApiCommonCodeService {

	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getCommonCodeList(Map<?, ?> paramMap, String grpCd) throws Exception {
		Log.Debug();
		Map<String, Object> params = (Map<String, Object>) paramMap;
		params.put("queryId", grpCd);
		params.put("grpCd", grpCd);
		return (List)this.dao.getList("getCommonCodeList", paramMap);
	}

	public List<?> getCommonNSCodeList(Map<?, ?> paramMap, String queryId) throws Exception {
		Log.Debug();
		Map<String, Object> params = (Map<String, Object>) paramMap;
		params.put("queryId", queryId);
		return paramMap != null && paramMap.containsKey("queryId") && paramMap.get("queryId") != null ? (List)this.dao.getList(paramMap.get("queryId").toString(), paramMap) : null;
	}


}