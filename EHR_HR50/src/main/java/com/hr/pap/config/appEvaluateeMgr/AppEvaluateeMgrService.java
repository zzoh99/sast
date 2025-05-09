package com.hr.pap.config.appEvaluateeMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가대상자생성/관리 Service
 *
 * @author JSG
 *
 */
@Service("AppEvaluateeMgrService")
public class AppEvaluateeMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  피평가자관리 조회 Service(평가단계별 날짜조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppEvaluateeMgrMap1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppEvaluateeMgrMap1", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 피평가자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppEvaluateeMgr1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppEvaluateeMgr1", convertMap);
			//cnt += dao.delete("deleteAppEvaluateeMgr1Sub", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppEvaluateeMgr1", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 피평가자관리 전체삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppEvaluateeMgrAll(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.delete("deleteAppEvaluateeMgrAll", paramMap);
		cnt += dao.delete("deleteAppEvaluateeMgrAllSub", paramMap);

		Log.Debug();
		return cnt;
	}

	/**
	 * 평가대상자생성 - 평가대상자생성 - 프로시저(평가대상자)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppEvaluateeMgr1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppEvaluateeMgr1", paramMap);
	}

	/**
	 * 평가대상자생성 - 평가대상자생성 - 프로시저(평가대상자)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppEvaluateeMgr2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppEvaluateeMgr2", paramMap);
	}
}
