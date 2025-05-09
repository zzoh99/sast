package com.hr.wtm.count.wtmDailyWorkMgr;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import com.hr.wtm.count.wtmDailyCount.WtmDailyCountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 일근무관리 Service
 *
 * @author JSG
 *
 */
@Service("WtmDailyWorkMgrService")
public class WtmDailyWorkMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	@Autowired
	private WtmDailyCountService wtmDailyCountService;

	/**
	 * 일근무관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmDailyWorkMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmDailyWorkMgrList", paramMap);
	}


	/**
	 * 근무 상세 조회 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public List<?> getWtmDailyWorkMgrWrkDtlList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmDailyWorkMgrWrkDtlList", paramMap);
	}


	/**
	 * 출퇴근타각 조회 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public List<?> getWtmDailyWorkMgrInoutList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmDailyWorkMgrInoutList", paramMap);
	}

	/**
	 * 일근무관리 마감여부 업데이트 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int updateWtmDailyWorkMgrCloseYn(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=1;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("updateWtmDailyWorkMgrCloseYn", convertMap);
		}
		return cnt;
	}

	/**
	 * 일근무관리 근무상세 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmDailyWorkMgrWrkDtl(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
			cnt += dao.delete("deleteWtmDailyWorkMgrWrkDtl", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
			List<Map<String, Object>> mergeRows = ((List<Map<String, Object>>) convertMap.get("mergeRows"));
			for(Map<String, Object> row : mergeRows){
				if("".equals(row.get("wrkDtlId"))){
					row.put("wrkDtlId", TsidCreator.getTsid().toString());
				}
				row.put("autoCreYn", "N");
			}
			cnt += dao.update("saveWtmDailyWorkMgrWrkDtl", convertMap);
		}

		if(cnt > 0) {
			postSave(convertMap.get("ssnEnterCd").toString(), convertMap.get("selectSabun").toString(), convertMap.get("selectYmd").toString(), convertMap.get("checkLimitYn").toString());
		}

		return cnt;
	}


	/**
	 * 일근무관리 출퇴근타각 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmDailyWorkMgrInout(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
			cnt += dao.delete("deleteWtmDailyWorkMgrInout", convertMap);
		}

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
			cnt += dao.update("saveWtmDailyWorkMgrInout", convertMap);
		}

		if(cnt > 0) {
			postSave(convertMap.get("ssnEnterCd").toString(), convertMap.get("selectSabun").toString(), convertMap.get("selectYmd").toString(), convertMap.get("checkLimitYn").toString());
		}

		return cnt;
	}

	private void postSave(String enterCd, String sabun, String ymd, String checkLimitYn) throws Exception {
		wtmCalcWorkTimeService.setCode(enterCd, false);

		if("Y".equals(checkLimitYn)){
			/* 근무시간 한도 체크 */
			// 근무한도체크를 위한 파라미터 설정
			Map<String, Object> checkLimitParam = new HashMap<>();
			checkLimitParam.put("enterCd", enterCd);
			checkLimitParam.put("sabun", sabun);
			checkLimitParam.put("sdate", ymd);
			checkLimitParam.put("edate", ymd);
			checkLimitParam.put("addWrkList", null);
			checkLimitParam.put("excWrkList", null);
			checkLimitParam.put("addGntList", null);
			checkLimitParam.put("excGntList", null);

			List<Map<String, Object>> paramList = new ArrayList<>();
			paramList.add(checkLimitParam);

			boolean hoursLimitYn = false;
			hoursLimitYn = wtmCalcWorkTimeService.checkWorkTimeLimit(paramList, false);
			if(!hoursLimitYn) {
				throw new HrException("근무시간 한도 체크에 실패했습니다.");
			}
		}

		/* 일마감 처리 */
		Map<String, Object> countParam = new HashMap<>();
		countParam.put("ssnEnterCd", enterCd);
		countParam.put("enterCd", enterCd);
		countParam.put("sabun", sabun);
		countParam.put("sdate", ymd);
		countParam.put("edate", ymd);
		countParam.put("useBatchMode", "N");
		int countCnt = wtmDailyCountService.prcWtmDailyCount(countParam);
		if (countCnt < 0) {
			throw new HrException("일근무 마감 작업에 실패했습니다.");
		}
	}
}