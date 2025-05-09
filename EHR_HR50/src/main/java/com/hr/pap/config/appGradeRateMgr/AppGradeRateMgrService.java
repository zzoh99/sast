package com.hr.pap.config.appGradeRateMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가배분 Service
 *
 * @author EW
 *
 */
@Service("AppGradeRateMgrService")
public class AppGradeRateMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 평가배분 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppGradeRateMgr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		/* 평가별 평가등급그룹 관리 기능 추가로 인한 추가 [TPAP218] */
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGradeRateMgr2ForTPAP222", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGradeRateMgr2ForTPAP222", convertMap);
		}

		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppGradeRateMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppGradeRateMgr2", convertMap);
		}

		return cnt;
	}
}
