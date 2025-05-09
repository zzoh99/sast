package com.hr.pap.appCompetency.compAppraisal;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 리더십진단 Service
 *
 * @author JSG
 *
 */
@Service("CompAppraisalService")
public class CompAppraisalService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 리더십진단 팝업상단 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppraisalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppraisalList", paramMap);
	}

	
	/**
	 * 리더십진단 팝업상단 다건 조회 Service(부서권한 적용)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTeamCompAppraisalList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTeamCompAppraisalList", paramMap);
	}
	
	/**
	 * 리더십진단  해더 조회(부서장) 그룹별 조회 한투 전용
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTeamHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTeamHeaderList", paramMap);
	}
	
	/**
	 * 리더십진단  리스트 조회(부서장) 그룹별 조회  한투 전용
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTeamList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTeamList", paramMap);
	}
	
	/**
	 * 리더십진단 팝업상단 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppraisalPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppraisalPopList", paramMap);
	}

	/**
	 * 동호회마감관리 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCompAppraisalPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getCompAppraisalPopMap", paramMap);
	}
	
	/**
	 * 리더십진단 저장(완료여부 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppraisal(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompAppraisal", convertMap);
		}
		Log.Debug();
		return cnt;
	}	

	/**
	 * 리더십진단 팝업상단 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppraisalPop1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompAppraisalPop1", convertMap);
		}
		cnt += dao.update("saveCompAppraisalPop2", convertMap);
		Log.Debug();
		return cnt;
	}

	/**
	 * 리더십진단 팝업하단 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppraisalPop2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveCompAppraisalPop2", paramMap);

		Log.Debug();
		return cnt;
	}

	/**
	 * 리더십진단 팝업진단완료 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppraisalPop3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveCompAppraisalPop3", paramMap);

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 하위 부서 다면평가 완료여부 체크 
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCompAppraisalTeamChk(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getCompAppraisalTeamChk", paramMap);
	}
	
	
	/**
	 * 다면평가 코멘트팝업 단건조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCompAppraisalCommentPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.getMap("getCompAppraisalCommentPopMap", paramMap);
	}	
	
	/**
	 * 리더십진단 코멘트팝업 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppraisalCommentPop(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("updateCompAppraisalCommentPop", paramMap);

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 다면평가 알림메일전송을 위한 평가명 정보 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> getCompAppraisalCdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getCompAppraisalCdMap", paramMap);
	}
	
	/**
	 * 다면평가 알림메일전송을 위한 평가자 메일정보 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> getCompAppraisalMailInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getCompAppraisalMailInfoMap", paramMap);
	}
}