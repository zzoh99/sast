package com.hr.pap.config.appGradeRateStd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 배분기준표 Service
 *
 * @author EW
 *
 */
@Service("AppGradeRateStdService")
public class AppGradeRateStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 배분기준표 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppGradeRateStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppGradeRateStdList", paramMap);
	}

	/**
	 * 배분기준표 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGradeRateStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		/* 평가별 평가등급그룹 관리 기능 추가로 인한 추가 [TPAP218] */
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGradeRateStdForTPAP218", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGradeRateStdForTPAP218", convertMap);
		}

		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGradeRateStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGradeRateStd", convertMap);
		}

		return cnt;
	}
}
