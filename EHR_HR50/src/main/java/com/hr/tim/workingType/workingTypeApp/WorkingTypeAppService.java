package com.hr.tim.workingType.workingTypeApp;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 근로시간단축 신청 Service
 *
 * @author bckim
 *
 */
@Service("WorkingTypeAppService")
public class WorkingTypeAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	public List<?> getWorkingTypeAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkingTypeAppList", paramMap);
	}

	/**
	 * 근로시간단축 신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkingTypeApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteWorkingTypeApp103", convertMap);
			dao.delete("deleteWorkingTypeApp107", convertMap);
			cnt += dao.delete("deleteWorkingTypeApp", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}