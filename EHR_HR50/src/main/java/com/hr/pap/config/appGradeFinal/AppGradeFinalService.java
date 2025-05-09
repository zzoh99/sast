package com.hr.pap.config.appGradeFinal;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 배분결과(최종) Service
 *
 * @author EW
 *
 */
@Service("AppGradeFinalService")
public class AppGradeFinalService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 배분결과(최종) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGradeFinalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGradeFinalList", paramMap);
	}

	/**
	 * 배분결과(최종) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGradeFinal(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGradeFinal", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGradeFinal", convertMap);
		}

		return cnt;
	}
}
