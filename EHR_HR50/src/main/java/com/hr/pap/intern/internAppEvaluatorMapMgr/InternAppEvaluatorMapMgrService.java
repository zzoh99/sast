package com.hr.pap.intern.internAppEvaluatorMapMgr;

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
@Service("InternAppEvaluatorMapMgrService")
public class InternAppEvaluatorMapMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 매핑 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternAppEvaluatorMapMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			List<Map<String, Object>> mergeList = (List<Map<String, Object>>)convertMap.get("mergeRows");
			
			/* 평가자 데이터를 삭제처리 (NULL처리)
			 * 1. 해당 평가자를 조회해서 1차평가와 2차평가의 PK값을 조회
			 * 2. 해당하는 자료는 UPDATE로 NULL처리
			 */
			for (Map<String, Object> merge : mergeList) {
				List<Map<String, Object>> evalUserList = (List<Map<String, Object>>) dao.getList("getInternAppEvaluatorMapAppEvalUserList", merge);
				for (Map<String, Object> user : evalUserList) {
					cnt += dao.update("saveInternAppEvaluatorMapMgr", user);
				}
			}
		}

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 매핑 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternAppEvaluatorMapMgr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			List<Map<String, Object>> mergeList = (List<Map<String, Object>>)convertMap.get("mergeRows");
			
			/* 평가자 데이터를 INSERT처리 (NULL을 데이터 기입)
			 * 1. 수습평가일정이 존재하는 경우 등록/삭제 불가
			 * 2. 1차 평가자 2차평가자 NULL인 자료를 조회
			 * 2-2. 해당하는 데이터를 평가자를 업데이트 한다.
			 * 3. 1차평가자 2차평가자 중 데이터가 없는 자료를 조회
			 * 3-2. 해당하는 데이터 평가자를 INSERT 한다.
			 */
			for (Map<String, Object> merge : mergeList) {
				merge.put("appraisalCd", convertMap.get("searchAppraisalCd"));
				List<Map<String, Object>> evalUserList = (List<Map<String, Object>>) dao.getList("getInternAppEvaluatorMapAppEvalUserList2", merge);
				for (Map<String, Object> user : evalUserList) {
					cnt += dao.update("saveInternAppEvaluatorMapMgr2", user);
					continue;
				}
				
				List<Map<String, Object>> evalUserList2 = (List<Map<String, Object>>) dao.getList("getInternAppEvaluatorMapAppEvalUserList3", merge);
				for (Map<String, Object> user : evalUserList2) {
					if (!"0".equalsIgnoreCase(String.valueOf(user.get("appSeq")))) {
						cnt += dao.update("saveInternAppEvaluatorMapMgr2", user);
						continue;
					}
				}
			}
		}
		Log.Debug();
		return cnt;
	}	
}
