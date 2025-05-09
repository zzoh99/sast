package com.hr.pap.evaluation.mboTargetReg;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 목표등록,중간점검등록 Service
 *
 * @author jcy
 *
 */
@Service("MboTargetRegService")
public class MboTargetRegService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  목표등록,중간점검등록 단건 조회 Service (평가자정보 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getMboTargetRegMapAppEmployee(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMboTargetRegMapAppEmployee", paramMap);
	}

	/**
	 * 목표등록,중간점검등록 저장 Service(KPI 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboTargetReg1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMboTargetReg1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMboTargetReg1", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 목표등록,중간점검등록 저장 Service(Competency 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboTargetReg2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMboTargetReg2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMboTargetReg2", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 목표등록,중간점검등록 저장 -  - (승인요청)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcMboTargetReg1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcMboTargetReg1", paramMap);
	}

	/**
	 * 목표등록,중간점검등록 저장 - (승인,반려)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcMboTargetReg2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcMboTargetReg2", paramMap);
	}

	/**
	 * 목표등록,중간점검등록 저장 Service(의견 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMboTargetRegPopCommentReg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveMboTargetRegPopCommentReg", convertMap);

		// 평가단계
		String searchAppStepCd = (String) convertMap.get("searchAppStepCd");
		// 마지막 승인 여부
		String lastApprYn = (String) convertMap.get("lastApprYn");
		// 중간점검평가등급
		String middleAppClassCd = (String) convertMap.get("middleAppClassCd");

		// 중간점검 최종 승인 처리인 경우 TPAP350 테이블의 중간점검평가등급 및 평가의견 업데이트 처리.
		//if("3".equals(searchAppStepCd) && !StringUtils.isEmpty(middleAppClassCd)) {
		if ("3".equals(searchAppStepCd) && "Y".equals(lastApprYn)) {
			cnt += dao.update("updateMboTargetRegMiddleAppInfo", convertMap);
		}

		Log.Debug();
		return cnt;
	}
}