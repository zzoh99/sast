package com.hr.pap.config.appGradeSeqCd2;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 배분결과(2차) Service
 *
 * @author EW
 *
 */
@Service("AppGradeSeqCd2Service")
public class AppGradeSeqCd2Service{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 배분결과(2차) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGradeSeqCd2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGradeSeqCd2List", paramMap);
	}

	/**
	 * 배분결과(2차) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGradeSeqCd2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGradeSeqCd2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGradeSeqCd2", convertMap);
		}

		return cnt;
	}
}
