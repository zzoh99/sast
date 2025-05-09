package com.hr.wtm.request.wtmAttendTimeAdjAppDet;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 출퇴근시간 변경신청 Service
 */
@Service("WtmAttendTimeAdjAppDetService")
public class WtmAttendTimeAdjAppDetService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	/**
	 * 출퇴근시간 변경신청 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmAttendTimeAdjAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		List<?> appDetList = (List<?>) dao.getList("getWtmAttendTimeAdjAppDetList", paramMap);
		if(appDetList == null || appDetList.isEmpty()) {
			// 신청 내용이 없는 경우, 변경전 출근시간 조회
			appDetList = (List<?>) dao.getList("getWtmAttendTimeAdjAppDetBfTimeList", paramMap);
		}

		return appDetList;
	}

	/**
	 * 출퇴근시간 변경신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmAttendTimeAdjAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int result = 0;
		// 근무시간한도 체크
		String tdYmd = convertMap.get("tdYmd").toString().replaceAll("-", "");

		List<Map<String, Object>> addInOutList = new ArrayList<>();
		List<Map<String, Object>> excInOutList = new ArrayList<>();
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			List<Map<String, Object>> mergeRows = ((List<Map<String, Object>>) convertMap.get("mergeRows"));
			for(Map<String, Object> row : mergeRows){
				if(!"D".equals(row.get("chgType"))){
					Map<String, Object> addInOut = new HashMap<>();
					addInOut.put("enterCd", convertMap.get("ssnEnterCd"));
					addInOut.put("sabun", row.get("sabun"));
					addInOut.put("ymd", row.get("ymd"));
					addInOut.put("inYmd", row.get("afInYmd"));
					addInOut.put("inHm", row.get("afInHm"));
					addInOut.put("outYmd", row.get("afOutYmd"));
					addInOut.put("outHm", row.get("afOutHm"));
					addInOut.put("awayYn", row.get("afAwayYn"));
					addInOutList.add(addInOut);
				}

				if(!"I".equals(row.get("chgType"))){
					Map<String, Object> excInOut = new HashMap<>();
					excInOut.put("enterCd", convertMap.get("ssnEnterCd"));
					excInOut.put("sabun", row.get("sabun"));
					excInOut.put("ymd", row.get("ymd"));
					excInOut.put("inYmd", row.get("bfInYmd"));
					excInOut.put("inHm", row.get("bfInHm"));
					excInOut.put("outYmd", row.get("bfOutYmd"));
					excInOut.put("outHm", row.get("bfOutHm"));
					excInOut.put("awayYn", row.get("bfAwayYn"));
					excInOutList.add(excInOut);
				}
			}
			Map<String, Object> checkLimitParam = new HashMap<String, Object>();
			checkLimitParam.put("enterCd", convertMap.get("ssnEnterCd"));				// 회사코드
			checkLimitParam.put("sabun", convertMap.get("searchApplSabun"));					// 근무한도 체크 사번
			checkLimitParam.put("sdate", tdYmd);	// 근무한도 체크 시작일
			checkLimitParam.put("edate", tdYmd);	// 근무한도 체크 종료일
			checkLimitParam.put("addWrkList", null); 		// TWTM102 데이터 외에 추가할 근무 리스트 -> 신규 신청 리스트
			checkLimitParam.put("excWrkList", null); 		// TWTM102 데이터에서 제외할 근무 리스트 -> 기존 근무 리스트
			checkLimitParam.put("addGntList", null);		// TWTM103 데이터에서 추가할 근태 리스트
			checkLimitParam.put("excGntList", null); 		// TWTM103 데이터에서 제외할 근태 리스트
			checkLimitParam.put("addInOutList", addInOutList); 		// TWTM110 데이터에서 추가할 출퇴근 타각 리스트
			checkLimitParam.put("excInOutList", excInOutList); 		// TWTM110 데이터에서 제외할 출퇴근 타각 리스트

			List<Map<String, Object>> paramList = new ArrayList<>();
			paramList.add(checkLimitParam);
			boolean hoursLimitYn = wtmCalcWorkTimeService.checkWorkTimeLimit(paramList, false);

			if(!hoursLimitYn) {
				throw new HrException("근무시간 한도 체크에 실패했습니다.");
			} else {
				result += dao.update("saveWtmAttendTimeAdjAppDetMaster", convertMap);
				result += dao.update("deleteWtmAttendTimeAdjAppDetDetail", convertMap);
				result += dao.update("saveWtmAttendTimeAdjAppDetDetail", convertMap);
			}
		}
		return result;
	}

	
	/**
	 * 출퇴근시간 변경신청 EndYn 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendTimeAdjAppDetEndYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendTimeAdjAppDetEndYn", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 출퇴근시간 변경신청 SecomTime 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendTimeAdjAppDetBfTime(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendTimeAdjAppDetBfTime", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 출퇴근시간 변경신청 DupCheck 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendTimeAdjAppDetDupCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendTimeAdjAppDetDupCheck", paramMap);
		Log.Debug();
		return resultMap;
	}
}
