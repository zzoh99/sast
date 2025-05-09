package com.hr.wtm.request.wtmAttendAppDet;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *  근태신청 세부내역 Service
 */
@Service("WtmAttendAppDetService")
public class WtmAttendAppDetService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * wtmAttendAppDet 근태 신청 내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmAttendAppDetSheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmAttendAppDetSheet1List", paramMap);
	}

	/**
	 * 근태신청 세부내역 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmAttendAppDet(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;

		List<Map<String, Object>> insertList = (List) paramMap.get("insDataList");
		for(Map map : insertList){
			map.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			map.put("ssnSabun", paramMap.get("ssnSabun"));
			map.put("applSeq", paramMap.get("searchApplSeq"));
			map.put("sabun", paramMap.get("searchApplSabun"));
			map.put("reqType", "I");
		}

		List<Map<String, Object>> deleteList = (List) paramMap.get("delDataList");
		for(Map map : deleteList){
			map.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			map.put("ssnSabun", paramMap.get("ssnSabun"));
			map.put("applSeq", paramMap.get("searchApplSeq"));
			map.put("sabun", paramMap.get("searchApplSabun"));
			map.put("reqType", "D");
		}

		paramMap.put("sabun", paramMap.get("searchApplSabun"));

		try {
			if(!insertList.isEmpty()){
				// 신청 데이터 유효성 체크
				checkValidation(insertList, deleteList, paramMap);
			}

			cnt = dao.update("saveWtmAttendAppDet1", paramMap);
			dao.delete("deleteWtmAttendAppDet", paramMap);

			if(!insertList.isEmpty()){
				cnt += dao.update("saveWtmAttendAppDet2", insertList);
			}
			if(!deleteList.isEmpty()){
				cnt += dao.update("saveWtmAttendAppDet2", deleteList);
			}
		} catch (HrException e) {
			throw new HrException(e.getMessage());
		}

		return cnt;
	}

	public void checkValidation(List<Map<String, Object>> insertList, List<Map<String, Object>> deleteList, Map<?, ?> paramMap) throws Exception {

		// 1. 발생 근태 사용인 경우, 발생근태 사용기간 확인 및 적용일수 합계와 잔여 휴가 비교
		Map leaveInfo = (Map) dao.getMap("getWtmAttendAppDetDayCnt", paramMap);
		if(leaveInfo != null){
			// 오류 메시지가 있는 경우
			if(!"".equals(leaveInfo.get("valChk"))) {
				throw new HrException(leaveInfo.get("valChk").toString());
			}

			// 잔여휴가 확인
			if("Y".equals(leaveInfo.get("vacationYn")) && "N".equals(leaveInfo.get(("minusAllowYn")))) {
				// 잔여휴가
				double restCnt = Double.parseDouble(leaveInfo.get("restCnt").toString());

				// 휴가신청 총 적용일수
				double insAppDay = insertList.stream()
						.map(map -> map.get("appDay"))
						.filter(appDay -> appDay != null && !appDay.toString().trim().isEmpty())
						.mapToDouble(appDay -> Double.parseDouble(appDay.toString()))
						.sum();

				// 휴가취소 총 적용일수
				double delAppDay = 0;
				if (!deleteList.isEmpty()) {
					delAppDay = deleteList.stream()
							.map(map -> map.get("appDay"))
							.filter(appDay -> appDay != null && !appDay.toString().trim().isEmpty())
							.mapToDouble(appDay -> Double.parseDouble(appDay.toString()))
							.sum();
				}

				if(restCnt - insAppDay + delAppDay < 0) {
					throw new HrException("잔여휴가일수가 부족합니다.");
				}
			}
		}

		for(Map<String, Object> insertData : insertList){
			// 2. 재직상태 및 근태 신청 대상자 여부 체크
			Map<String, Object> searchParam = new HashMap<>();
			String sYmd = insertData.get("sYmd").toString();
			String eYmd = insertData.get("eYmd").toString();
			searchParam.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			searchParam.put("sabun", paramMap.get("searchSabun"));
			searchParam.put("applSeq", paramMap.get("searchApplSeq"));
			searchParam.put("gntCd", paramMap.get("gntCd"));
			searchParam.put("leaveId", paramMap.get("leaveId"));
			searchParam.put("sYmd", sYmd.replaceAll("-", ""));
			searchParam.put("eYmd", eYmd.replaceAll("-", ""));

			String formattedSYmd = DateUtil.convertLocalDateToString(DateUtil.getLocalDate(sYmd, "yyyyMMdd"), "yyyy-MM-dd");
			String formattedEYmd = DateUtil.convertLocalDateToString(DateUtil.getLocalDate(eYmd, "yyyyMMdd"), "yyyy-MM-dd");
			String termOfDates = "[" + formattedSYmd + "-" + formattedEYmd + "]";

			Map statusMap = (Map) dao.getMap("getWtmAttendAppDetStatusAndAuth", searchParam);
			if(statusMap != null){
				if(!"AA".equals(statusMap.get("statusCd1")) || !"AA".equals(statusMap.get("statusCd2")) ){
					throw new HrException(termOfDates + " 해당 신청기간에 재직상태가 아닙니다.");
				}

				if("Y".equals(statusMap.get("authYn"))){
					throw new HrException(termOfDates + " 신청 대상자가 아닙니다");
				}
			} else {
				throw new HrException(termOfDates + " 재직상태 및 근태 신청 대상자 여부 체크에 실패했습니다.");
			}

			// 3. 신청 한도 체크
			// 최대신청한도 체크
			double appDay = Double.parseDouble(insertData.get("appDay").toString());
			if(leaveInfo.get("maxCnt") != null) {
				double maxCnt = Double.parseDouble(leaveInfo.get("maxCnt").toString());
				if(appDay > maxCnt) {
					throw new HrException(termOfDates + " 최대 " +  maxCnt + "일 이하로 신청 하셔야 합니다.");
				}
			}

			// 신청최소일수 체크
			if(leaveInfo.get("baseCnt") != null) {
				double baseCnt = Double.parseDouble(leaveInfo.get("baseCnt").toString());
				if(appDay < baseCnt) {
					throw new HrException(termOfDates + " 최소 " +  baseCnt + "일 이상 신청 하셔야 합니다.");
				}
			}

			if(appDay == 0) {
				throw new HrException(termOfDates + " 휴일은 신청할 수 없습니다.");
			}

			// 4. 기신청일수 여부 체크
			searchParam.put("deleteList", deleteList);
			Map applDayCnt = (Map) dao.getMap("getWtmAttendAppDetApplDayCnt", searchParam);
			if(!applDayCnt.isEmpty() && applDayCnt.get("cnt") != null && Integer.parseInt(applDayCnt.get("cnt").toString()) > 0) {
				throw new HrException(termOfDates + " 해당 신청기간에 기 신청건이 존재합니다.");
			}
		}
	}

	/**
	 * getWtmAttendAppDetPlanPopupList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmAttendAppDetPlanPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmAttendAppDetPlanPopupList", paramMap);
	}
	
	/**
	 * wtmAttendAppDet 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmAttendAppDetStdGntList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmAttendAppDetStdGntList", paramMap);
	}
	
	/**
	 * wtmAttendAppDet 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetHolidayCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetHolidayCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * wtmAttendAppDet 단건 조회 2 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetApplDayCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetApplDayCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * wtmAttendAppDet 단건 조회 3 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getWtmAttendAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmAttendAppDetList", paramMap);
	}
	
	/**
	 * wtmAttendAppDet 변경전 신청서 내용 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetBefore(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetBefore", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmAttendAppDetHour 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetHour(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetHour", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmAttendAppDetRestCnt 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetRestCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetRestCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmAttendAppDetDayCnt 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetDayCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetDayCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmAttendAppDetStatusCd 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetStatusCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetStatusCd", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmAttendAppDetPlanPopupMap 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetPlanPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetPlanPopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}


	/**
	 * 근태신청일자별 근무시간 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmAttendAppDetWorkHours(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmAttendAppDetWorkHours", paramMap);
	}

	/**
	 * wtmAttendAppDet 신청서 수정/삭제를 위한 이전 신청 정보 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmAttendAppDetInfoForUpd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmAttendAppDetInfoForUpd", paramMap);
		Log.Debug();
		return resultMap;
	}
	
}