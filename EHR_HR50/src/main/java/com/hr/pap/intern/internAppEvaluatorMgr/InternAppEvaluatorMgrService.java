package com.hr.pap.intern.internAppEvaluatorMgr;

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
@Service("InternAppEvaluatorMgrService")
public class InternAppEvaluatorMgrService{

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
	public Map<?, ?> getInternAppEvaluatorMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getInternAppEvaluatorMgr", paramMap);
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
	public int saveInternAppEvaluatorMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteInternAppEvaluatorMgr", convertMap);
			//cnt += dao.delete("deleteAppEvaluateeMng1Sub", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternAppEvaluatorMgr", convertMap);
		}

		Log.Debug();
		return cnt;
	}
}
