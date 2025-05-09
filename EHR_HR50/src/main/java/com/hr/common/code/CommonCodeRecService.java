package com.hr.common.code;

import com.hr.common.dao.RecDao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;


@Service("CommonCodeRecService")
public class CommonCodeRecService{

	@Inject
	@Named("RecDao")
	private RecDao recDao;

	public List<?> getCommonCodeListRec(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)recDao.getList("getCommonCodeList", paramMap);
	}
	
	public List<?> getCommonNSCodeListRec(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)recDao.getList(paramMap.get("queryId").toString(), paramMap);
	}
}