package com.hr.pap.evaMain.main;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service("EvaMainService")
public class EvaMainService {
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 목표등록 카드 조회
	 */
	public List<?> getGoalCardList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getGoalCardList", paramMap);
	}

	/**
	 * 목표승인 카드 조회
	 */
	public List<?> getGoalAprCardList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getGoalAprCardList", paramMap);
	}

	/**
	 * Coaching 카드 조회
	 */
	public List<?> getCoachCardList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCoachCardList", paramMap);
	}

	/**
	 * 평가 카드 조회
	 */
	public List<?> getAprCardList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAprCardList", paramMap);
	}

	/**
	 * 평가대상자 기본사항 조회
	 */
	public Map<?, ?> getAppSabunMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppSabunMap", paramMap);
	}

	/**
	 * 목표등록,중간점검등록 다건 조회 Service(의견조회)
	 */
	public List<?> getEvaGoalCommentRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEvaGoalCommentRegList", paramMap);
	}

	/**
	 * 최종평가 평가자 리스트 조회
	 */
	public List<?> getAppSabunList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSabunList", paramMap);
	}

	/**
	 * 등급별 목표 수준 조회
	 */
	public List<?> getEvaMboRegList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEvaMboRegList2", paramMap);
	}

	/**
	 * 목표등록,중간점검등록 등급별 목표수준 저장
	 */
	public int saveEvaMboReg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEvaMboReg", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEvaMboReg", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 최종평가 평가 대상자 리스트 조회
	 */
	public List<?> getEvaAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEvaAprList", paramMap);
	}

	/**
	 * 업적평가 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSelf1", convertMap); // 업적 평가 저장
		}

		Log.Debug();
		return cnt;
	}

	public int saveMboAprGradeCd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveMboAprGradeCd", convertMap); // 업적 등급 저장

		Log.Debug();
		return cnt;
	}

	/**
	 * 역량평가 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboCompApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSelf2", convertMap); // 역량 평가 저장
		}

		Log.Debug();
		return cnt;
	}

	public int saveMboCompAprGradeCd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveMboCompAprGradeCd", convertMap); // 역량 등급 저장

		Log.Debug();
		return cnt;
	}

	/**
	 * 역량, 업적 등급 조회
	 */
	public Map<?, ?> getEvaAprGradeCdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEvaAprGradeCdMap", paramMap);
	}

	public int saveEvaAprGradeCd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if(convertMap.containsKey("mboClassCd") && !convertMap.get("mboClassCd").equals("")){
			cnt += dao.update("saveMboAprGradeCd", convertMap); // 업적 등급 저장
		}
		if(convertMap.containsKey("compClassCd") && !convertMap.get("compClassCd").equals("")){
			cnt += dao.update("saveMboCompAprGradeCd", convertMap); // 역량 등급 저장
		}

		Log.Debug();
		return cnt;
	}
}