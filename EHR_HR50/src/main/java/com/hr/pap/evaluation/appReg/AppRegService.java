package com.hr.pap.evaluation.appReg;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
/**
 * 평가(임직원공통) Service
 *
 * @author kwook
 *
 */
@Service("AppRegService")
public class AppRegService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 평가(임직원공통) 평가년도 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppRegAppYearList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppRegAppYearList", paramMap);
	}

	/**
	 * 평가(임직원공통) 평가차수 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Object> getAppRegAppSeqList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		List<Object> retList = new ArrayList<>();

		// 본인평가 정보 조회
		for (Map<String, Object> map : (List<Map<String, Object>>) dao.getList("getAppOrgCdListMboTarget", paramMap)) {
			paramMap.put("searchAppSeqCd", "0");
			paramMap.put("searchAppOrgCd", map.get("code"));
			Map<String, Object> appSelfInfo = (Map<String, Object>) dao.getMap("getAppRegAppSeqSelfMap", paramMap);
			if (appSelfInfo != null && !appSelfInfo.isEmpty())
				retList.add(appSelfInfo);
		}

		// N차 평가 정보 조회
		for (Map<String, Object> map : (List<Map<String, Object>>) dao.getList("getAppSeqCdListMbo", paramMap)) {
			paramMap.put("searchAppSeqCd", map.get("code"));
			Map<String, Object> appNthInfo = (Map<String, Object>) dao.getMap("getAppRegAppSeqNthMap", paramMap);
			System.out.println(appNthInfo.toString());
			if (appNthInfo != null && !appNthInfo.isEmpty())
				retList.add(appNthInfo);
		}

		return retList;
	}

	/**
	 *  평가(임직원공통) 평가단계 본인평가 업적 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppRegAppSelfPerfMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppRegAppSelfPerfMap", paramMap);
	}

	/**
	 *  평가(임직원공통) 평가단계 본인평가 역량 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppRegAppSelfCompMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppRegAppSelfCompMap", paramMap);
	}

	/**
	 *  평가(임직원공통) N차평가 대상자 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppRegAppNthEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppRegAppNthEmpList", paramMap);
	}

	/**
	 *  평가(임직원공통) N차평가 업적 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppRegAppNthPerfMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppRegAppNthPerfMap", paramMap);
	}

	/**
	 *  평가(임직원공통) N차평가 역량 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppRegAppNthCompMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppRegAppNthCompMap", paramMap);
	}

	/**
	 * 평가(임직원공통) 본인평가 업적 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppRegAppSelfPerf(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppRegAppSelfPerf", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 평가(임직원공통) 본인평가 역량 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppRegAppSelfComp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppRegAppSelfComp", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 평가(임직원공통) N차평가 업적 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppRegAppNthPerf(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppRegAppNthPerf", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 평가(임직원공통) N차평가 역량 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppRegAppNthComp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppRegAppNthComp", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 본인평가 저장 -  - (평가완료)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppRegAppSelf(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppRegAppSelf", paramMap);
	}
}