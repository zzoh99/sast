package com.hr.wtm.request.wtmWorkAppDet;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.wtm.calc.dto.WtmDailyCountDTO;
import com.hr.wtm.calc.dto.WtmWrkDtlDTO;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.*;

/**
 *  근무신청 세부내역 Service
 */
@Service("WtmWorkAppDetService")
public class WtmWorkAppDetService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	/**
	 * wtmWorkAppDet 근태 신청 내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkAppDetSheet1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkAppDetSheet1List", paramMap);
	}

	/**
	 * 근무신청 세부내역 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmWorkAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		wtmCalcWorkTimeService.setCode(paramMap.get("ssnEnterCd").toString(), false);

		List<Map<String, Object>> insertList = (List) paramMap.get("insDataList");
		List<Map<String, Object>> otBreakList = new ArrayList<>();
		Map applInfo = (Map) dao.getMap("getWtmWorkAppDetApplInfo", paramMap);
		for(Map map : insertList){
			map.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			map.put("ssnSabun", paramMap.get("ssnSabun"));
			map.put("applSeq", paramMap.get("searchApplSeq"));
			map.put("reqType", "I");

			// 적용시간(분) 계산
			int requestMm = 0;
			if(!map.get("sYmd").equals("")
					&& map.containsKey("reqSHm") && !map.get("reqSHm").equals("")
					&& map.containsKey("reqEHm") && !map.get("reqEHm").equals("")){

				String sYmd = map.get("sYmd").toString().replaceAll("-", "");
				String eYmd = map.get("eYmd").toString().replaceAll("-", "");
				String shm = map.get("reqSHm").toString().replaceAll(":", "");
				String ehm = map.get("reqEHm").toString().replaceAll(":", "");

				// 시작시간이 종료시간보다 더 늦은경우
				if(shm.compareTo(ehm) > 0) {
					map.put("sYmd", sYmd);
					eYmd = LocalDateTime.parse(sYmd, DateTimeFormatter.ofPattern("yyyyMMdd")).plusDays(1).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
					map.put("eYmd", eYmd);
				}

				// 시작 시간
				LocalDateTime fromDateTime = LocalDateTime.parse(sYmd + shm, DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
				// 종료 시간
				LocalDateTime toDateTime = LocalDateTime.parse(eYmd + ehm, DateTimeFormatter.ofPattern("yyyyMMddHHmm"));

				// 분차이 계산
				// Duration으로 차이 계산 후 분으로 변환
				requestMm = (int) Duration.between(fromDateTime, toDateTime).toMinutes();

				// 연장근로 신청 여부 확인
				if(paramMap.get("workCd").equals(wtmCalcWorkTimeService.getOtWorkCd())) {
					// 연장근무 휴게시간 기준 조회
					Map<String, Object> searchParam = new HashMap<>();
					searchParam.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
					searchParam.put("date", sYmd);
					searchParam.put("sabun", paramMap.get("searchApplSabun"));
					Map<String, Object> otBreakInfo = (Map<String, Object>) dao.getMap("getWtmWorkAppDetOtBreakInfo", searchParam);
					int otBreakTimeT = 60 * Integer.parseInt(otBreakInfo.getOrDefault("otBreakTimeT", "0").toString());
					int otBreakTimeR = Integer.parseInt(otBreakInfo.getOrDefault("otBreakTimeR", "0").toString());
					
					// 연장근무 휴게시간 삽입
					if (otBreakTimeT > 0 && otBreakTimeR > 0 && requestMm >= otBreakTimeT) {
						// 시작시간부터 계산
						LocalDateTime currentTime = fromDateTime;
						int remainingMinutes = requestMm;

						while (remainingMinutes >= otBreakTimeT) {
							// 연장근무 휴게시간 기준 이후 시점 계산
							LocalDateTime breakStartTime = currentTime.plusMinutes(otBreakTimeT);
							// 연장근무 휴게시간 후의 시점 계산
							LocalDateTime breakEndTime = breakStartTime.plusMinutes(otBreakTimeR);

							Map<String, Object> breakInfo = new HashMap<>();
							breakInfo.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
							breakInfo.put("ssnSabun", paramMap.get("ssnSabun"));
							breakInfo.put("applSeq", paramMap.get("searchApplSeq"));
							breakInfo.put("workCd", wtmCalcWorkTimeService.getBreakWorkCd());
							breakInfo.put("reqType", "I");
							breakInfo.put("sYmd", breakStartTime.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
							breakInfo.put("reqSHm", breakStartTime.format(DateTimeFormatter.ofPattern("HHmm")));
							breakInfo.put("eYmd", breakEndTime.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
							breakInfo.put("reqEHm", breakEndTime.format(DateTimeFormatter.ofPattern("HHmm")));
							breakInfo.put("requestMm", otBreakTimeR);
							breakInfo.put("addWorkTimeYn", "N");
							breakInfo.put("workTimeType", "03"); // 휴게
							otBreakList.add(breakInfo);

							// 다음 계산을 위해 현재 시간과 남은 시간 업데이트
							currentTime = breakEndTime;
							remainingMinutes -= (otBreakTimeT + otBreakTimeR);
						}
					}
				}
			} else {
				int applyHour = Integer.parseInt(StringUtils.defaultIfEmpty(applInfo.get("applyHour").toString(), "0"));
				int appDay = Integer.parseInt(StringUtils.defaultIfEmpty(map.get("appDay").toString(), "0"));
				requestMm = applyHour * 60 * appDay;
			}
			map.put("requestMm", requestMm);
			map.put("addWorkTimeYn", applInfo.get("addWorkTimeYn"));
			map.put("workTimeType", applInfo.get("workTimeType"));
			map.put("deemedYn", applInfo.get("deemedYn"));
		}

		List<Map<String, Object>> deleteList = (List) paramMap.get("delDataList");
		for(Map map : deleteList){
			map.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			map.put("ssnSabun", paramMap.get("ssnSabun"));
			map.put("applSeq", paramMap.get("searchApplSeq"));
			map.put("reqType", "D");
		}
		try {
			if(!insertList.isEmpty()){
				List<Map<String, Object>> tempInsertList = new ArrayList<>(insertList); // 근무시간 한도 및 입력 유효성 체크용
				// 연장근무 휴게시간이 있는 경우, insertData에 추가
				if(!otBreakList.isEmpty()) {
					tempInsertList.addAll(otBreakList);
				}

				// 신청 데이터 유효성 체크
				checkValidation(tempInsertList, deleteList, paramMap);
			}

			cnt = dao.update("saveWtmWorkAppDet1", paramMap);
			dao.delete("deleteWtmWorkAppDet", paramMap);

			if(!insertList.isEmpty()){
				cnt += dao.update("saveWtmWorkAppDet2", insertList);
			}
			if(!deleteList.isEmpty()){
				cnt += dao.update("saveWtmWorkAppDet2", deleteList);
			}
		} catch (HrException e) {
			throw new HrException(e.getMessage());
		}

		return cnt;
	}

	public void checkValidation(List<Map<String, Object>> insertList, List<Map<String, Object>> deleteList, Map<?, ?> paramMap) throws Exception {
		String maxSymd = null;
		String minEymd = null;
		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");

		for(Map<String, Object> insertData : insertList){
			if(!insertData.get("workTimeType").equals(wtmCalcWorkTimeService.getBreakWorkCd())) { // 휴게시간 제외
				// 1. 재직상태 및 근태 신청 대상자 여부 체크
				Map<String, Object> searchParam = new HashMap<>();
				String sYmd = insertData.get("sYmd").toString();
				String eYmd = insertData.get("eYmd").toString();
				searchParam.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
				searchParam.put("sabun", paramMap.get("searchSabun"));
				searchParam.put("applSeq", paramMap.get("searchApplSeq"));
				searchParam.put("workCd", paramMap.get("workCd"));
				searchParam.put("sYmd", sYmd.replaceAll("-", ""));
				searchParam.put("eYmd", eYmd.replaceAll("-", ""));

				String formattedSYmd = DateUtil.convertLocalDateToString(DateUtil.getLocalDate(sYmd, "yyyyMMdd"), "yyyy-MM-dd");
				String formattedEYmd = DateUtil.convertLocalDateToString(DateUtil.getLocalDate(eYmd, "yyyyMMdd"), "yyyy-MM-dd");
				String termOfDates = "[" + formattedSYmd + "-" + formattedEYmd + "]";

				Map statusMap = (Map) dao.getMap("getWtmWorkAppDetStatusAndAuth", searchParam);
				if (statusMap != null) {
					if (!"AA".equals(statusMap.get("statusCd1")) || !"AA".equals(statusMap.get("statusCd2"))) {
						throw new HrException(termOfDates + " 해당 신청기간에 재직상태가 아닙니다.");
					}

					if ("Y".equals(statusMap.get("authYn"))) {
						throw new HrException(termOfDates + " 신청 대상자가 아닙니다");
					}
				} else {
					throw new HrException(termOfDates + " 재직상태 및 근태 신청 대상자 여부 체크에 실패했습니다.");
				}

				// 2. 신청 한도 체크
				Map applInfo = (Map) dao.getMap("getWtmWorkAppDetApplInfo", paramMap);
				double appDay = Double.parseDouble(insertData.get("appDay").toString());

				// 최대신청한도 체크
				if (applInfo.get("maxCnt") != null) {
					double maxCnt = Double.parseDouble(applInfo.get("maxCnt").toString());
					if (appDay > maxCnt) {
						throw new HrException(termOfDates + " 최대 " + maxCnt + "일 이하로 신청 하셔야 합니다.");
					}
				}

				// 신청최소일수 체크
				if (applInfo.get("baseCnt") != null) {
					double baseCnt = Double.parseDouble(applInfo.get("baseCnt").toString());
					if (appDay < baseCnt) {
						throw new HrException(termOfDates + " 최소 " + baseCnt + "일 이상 신청 하셔야 합니다.");
					}
				}

				// 4. 기신청일수 여부 체크
				searchParam.put("deleteList", deleteList);
				Map applDayCnt = (Map) dao.getMap("getWtmWorkAppDetApplDayCnt", searchParam);
				if (!applDayCnt.isEmpty() && applDayCnt.get("cnt") != null && Integer.parseInt(applDayCnt.get("cnt").toString()) > 0) {
					throw new HrException(termOfDates + " 해당 신청기간에 기 신청건이 존재합니다.");
				}

				// 5. 연장근무 신청의 경우, 기본근무시간 이후 신청인지 체크.
				Map baseWorkTime = (Map) dao.getMap("getWtmWorkAppDetBaseWorkTime", searchParam);
				if (baseWorkTime != null && !baseWorkTime.isEmpty()) {
					// 연장근무 휴게시간 기준 조회
					Map<String, Object> otSearchParam = new HashMap<>();
					otSearchParam.put("ssnEnterCd", searchParam.get("ssnEnterCd"));
					otSearchParam.put("date", searchParam.get("sYmd"));
					otSearchParam.put("sabun", searchParam.get("sabun"));
					Map<String, Object> otInfo = (Map<String, Object>) dao.getMap("getWtmWorkAppDetOtBreakInfo", otSearchParam);

					// 6. 연장근무 신청시 기본근무 선소진 여부 확인
					String baseWorkPreUsYn = otInfo.get("baseWorkPreUseYn").toString();
					if("Y".equals(baseWorkPreUsYn)) {
						String weekBeginDay = "MON";
						if(!otInfo.get("weekBeginDay").toString().isEmpty())
							weekBeginDay = otInfo.get("weekBeginDay").toString();

						// 단위기간내 실 근무시간 조회
						LocalDate targetDate = LocalDate.parse(searchParam.get("sYmd").toString(), dateFormatter);
						LocalDate sdate = targetDate.with(TemporalAdjusters.previousOrSame(wtmCalcWorkTimeService.convertToDayOfWeek(weekBeginDay)));
						LocalDate edate = sdate.plusDays(6);

						Map<String, Object> realWorkParam = new HashMap<>();
						realWorkParam.put("enterCd", searchParam.get("ssnEnterCd"));
						realWorkParam.put("sdate", sdate.format(dateFormatter));
						realWorkParam.put("edate", edate.format(dateFormatter));
						realWorkParam.put("sabun", searchParam.get("sabun"));
						Map<String, Object> countMap = wtmCalcWorkTimeService.countDailyWorkTime(realWorkParam, false);

						List<WtmDailyCountDTO> realWorkTimeList = (List<WtmDailyCountDTO>) countMap.get("workSummary");

						// 실 근무시간이 일 근무한도 이상인지 확인
						int dayWkLmt = Integer.parseInt(otInfo.get("dayWkLmt").toString()) * 60;
						int weekWkLmt = Integer.parseInt(otInfo.get("weekWkLmt").toString()) * 60;
						int weekBasicMm = 0;
						for(WtmDailyCountDTO realWorkTime : realWorkTimeList) {
							int basicMm = realWorkTime.getBasicMm();
							weekBasicMm += basicMm;
							if(basicMm < dayWkLmt) {
								throw new HrException(termOfDates + " 해당 신청기간에 기본근무를 먼저 소진 후 연장근무 신청이 가능합니다.");
							}
						}

						if(weekBasicMm < weekWkLmt) {
							throw new HrException(termOfDates + " 해당 신청기간에 기본근무를 먼저 소진 후 연장근무 신청이 가능합니다.");
						}
					}

					String workSchSymd = baseWorkTime.get("symd").toString();
					String workSchShm = baseWorkTime.get("shm").toString();
					String workSchEymd = baseWorkTime.get("eymd").toString();
					String workSchEhm = baseWorkTime.get("ehm").toString();

					if (!workSchSymd.isEmpty() && !workSchShm.isEmpty() && !workSchEymd.isEmpty() && !workSchEhm.isEmpty()) {

						String reqShm = insertData.get("reqSHm").toString();
						String reqEhm = insertData.get("reqEHm").toString();

						// 요청 시작/종료 시간 생성
						LocalDateTime reqStart = LocalDateTime.parse(sYmd + reqShm, DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
						LocalDateTime reqEnd = LocalDateTime.parse(eYmd + reqEhm, DateTimeFormatter.ofPattern("yyyyMMddHHmm"));

						// 근무스케줄 종료시간
						LocalDateTime endDateTime = LocalDateTime.parse(workSchEymd + workSchEhm, DateTimeFormatter.ofPattern("yyyyMMddHHmm"));

						// 요청 시작시간과 종료시간이 모두 비교시간 이후인지 확인
						if (reqStart.isBefore(endDateTime) || reqEnd.isBefore(endDateTime) || reqEnd.isEqual(endDateTime)) {
							throw new HrException(termOfDates + " 연장근무는 근무스케줄(" + workSchShm + "-" + workSchEhm + ") 이후 시간으로 지정 가능합니다.");
						}
					} else {
						throw new HrException(termOfDates + " 해당 신청기간에 근무스케줄이 지정되지 않았습니다.");
					}
				}

				// insertList에서 symd와 eymd의 최대, 최소값 구하기.
				if (maxSymd == null || sYmd.compareTo(maxSymd) > 0) {
					maxSymd = sYmd;
				}
				if (minEymd == null || eYmd.compareTo(minEymd) < 0) {
					minEymd = eYmd;
				}
			}
		}

		if(insertList != null && !insertList.isEmpty()) {
			// 6. 근무시간한도 체크
			// 근무 신청 상세를 WtmWrkDtlDTO 으로 변환
			List<WtmWrkDtlDTO> addWtmWrkList = new ArrayList<>();
			insertList.forEach(insertData -> {
				// 신청기간 조회
				String sYmd = (String) insertData.get("sYmd"); // 신청 시작일
				String eYmd = (String) insertData.get("eYmd"); // 신청 종료일
				LocalDate startDate = LocalDate.parse(sYmd, DateTimeFormatter.ofPattern("yyyyMMdd"));
				LocalDate endDate = LocalDate.parse(eYmd, DateTimeFormatter.ofPattern("yyyyMMdd"));

				// 신청기간만큼 반복문 실행
				for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
					WtmWrkDtlDTO wtmWrkDtlDTO = new WtmWrkDtlDTO();
					wtmWrkDtlDTO.setEnterCd(paramMap.get("ssnEnterCd").toString());
					wtmWrkDtlDTO.setWrkDtlId("");
					wtmWrkDtlDTO.setYmd(date.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
					wtmWrkDtlDTO.setSabun(paramMap.get("searchSabun").toString());
					if(insertData.containsKey("workCd") && insertData.get("workCd") != null && !insertData.get("workCd").toString().isEmpty()) {
						wtmWrkDtlDTO.setWorkCd(insertData.get("workCd").toString());
					} else {
						wtmWrkDtlDTO.setWorkCd(paramMap.get("workCd").toString());
					}

					if(insertData.containsKey("reqSHm") && !insertData.get("reqSHm").toString().isEmpty()) { // 시간차 신청인 경우
						wtmWrkDtlDTO.setPlanSymd(sYmd);
						wtmWrkDtlDTO.setPlanShm((String) insertData.get("reqSHm"));
						wtmWrkDtlDTO.setPlanEymd(eYmd);
						wtmWrkDtlDTO.setPlanEhm((String) insertData.get("reqEHm"));
					} else {
						wtmWrkDtlDTO.setPlanSymd(date.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
						wtmWrkDtlDTO.setPlanEymd(date.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
					}

					wtmWrkDtlDTO.setPlanMm(Integer.parseInt(insertData.get("requestMm").toString()));
					wtmWrkDtlDTO.setAddWorkTimeYn(insertData.get("addWorkTimeYn").toString());
					wtmWrkDtlDTO.setWorkTimeType(insertData.get("workTimeType").toString());
					wtmWrkDtlDTO.setDeemedYn(insertData.get("deemedYn").toString());
					addWtmWrkList.add(wtmWrkDtlDTO);
				}
			});

			// 근무 취소 신청 상세를 WtmWrkDtlDTO 으로 변환
			List<WtmWrkDtlDTO> excWtmWrkList = new ArrayList<>();
			deleteList.forEach(deleteData -> {
				// 취소신청기간 조회
				String sYmd = (String) deleteData.get("sYmd"); // 신청 시작일
				String eYmd = (String) deleteData.get("eYmd"); // 신청 종료일
				LocalDate startDate = LocalDate.parse(sYmd, DateTimeFormatter.ofPattern("yyyyMMdd"));
				LocalDate endDate = LocalDate.parse(eYmd, DateTimeFormatter.ofPattern("yyyyMMdd"));

				// 취소신청기간만큼 반복문 실행
				for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
					WtmWrkDtlDTO wtmWrkDtlDTO = new WtmWrkDtlDTO();
					wtmWrkDtlDTO.setEnterCd(paramMap.get("ssnEnterCd").toString());
					wtmWrkDtlDTO.setWrkDtlId(deleteData.get("wrkDtlId").toString());
					wtmWrkDtlDTO.setYmd(date.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
					wtmWrkDtlDTO.setSabun(paramMap.get("searchSabun").toString());
					wtmWrkDtlDTO.setWorkCd(paramMap.get("workCd").toString());

					if(deleteData.containsKey("reqSHm") && !deleteData.get("reqSHm").toString().isEmpty()) { // 시간차 신청인 경우
						wtmWrkDtlDTO.setPlanSymd(sYmd);
						wtmWrkDtlDTO.setPlanShm((String) deleteData.get("reqSHm"));
						wtmWrkDtlDTO.setPlanEymd(eYmd);
						wtmWrkDtlDTO.setPlanEhm((String) deleteData.get("reqEHm"));
					} else {
						wtmWrkDtlDTO.setPlanSymd(date.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
						wtmWrkDtlDTO.setPlanEymd(date.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
					}

					wtmWrkDtlDTO.setPlanMm(Integer.parseInt(deleteData.get("requestMm").toString()));
					wtmWrkDtlDTO.setAddWorkTimeYn(deleteData.get("addWorkTimeYn").toString());
					wtmWrkDtlDTO.setWorkTimeType(deleteData.get("workTimeType").toString());
					wtmWrkDtlDTO.setRequestUseType(deleteData.get("requestUseType").toString());
					excWtmWrkList.add(wtmWrkDtlDTO);
				}
			});

			// 근무한도체크를 위한 파라미터 설정
			Map<String, Object> checkLimitParam = new HashMap<String, Object>();
			checkLimitParam.put("enterCd", paramMap.get("ssnEnterCd"));				// 회사코드
			checkLimitParam.put("sabun", paramMap.get("searchSabun"));					// 근무한도 체크 사번
			checkLimitParam.put("sdate", maxSymd);	// 근무한도 체크 시작일
			checkLimitParam.put("edate", minEymd);	// 근무한도 체크 종료일
			checkLimitParam.put("addWrkList", addWtmWrkList); 		// TWTM102 데이터 외에 추가할 근무 리스트 -> 신규 신청 리스트
			checkLimitParam.put("excWrkList", excWtmWrkList); 		// TWTM102 데이터에서 제외할 근무 리스트 -> 기존 근무 리스트
			checkLimitParam.put("addGntList", null);		 		// TWTM103 데이터에서 추가할 근태 리스트
			checkLimitParam.put("excGntList", null); 				// TWTM103 데이터에서 제외할 근태 리스트

			List<Map<String, Object>> paramList = new ArrayList<>();
			paramList.add(checkLimitParam);
			boolean hoursLimitYn = wtmCalcWorkTimeService.checkWorkTimeLimit(paramList, false);
			if(!hoursLimitYn) {
				throw new HrException("근무시간 한도 체크에 실패했습니다.");
			}
		}
	}

	/**
	 * getWtmWorkAppDetPlanPopupList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkAppDetPlanPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkAppDetPlanPopupList", paramMap);
	}
	
	/**
	 * wtmWorkAppDet 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkAppDetStdGntList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkAppDetStdGntList", paramMap);
	}
	
	/**
	 * wtmWorkAppDet 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetApplDay(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<Object, Object> resultMap = (Map<Object, Object>) dao.getMap("getWtmWorkAppDetApplDay", paramMap);
/*      // 오류가 발생하여 일단 주석처리..
		String requestDayType = resultMap.get("requestDayType").toString();

		if(requestDayType.equals("A")){
			// 전체
			resultMap.put("excDayCnt", 0);
		} else if (requestDayType.equals("W")) {
			// 평일
		} else if (requestDayType.equals("H")) {
			// 휴일
		}
*/
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * wtmWorkAppDet 단건 조회 2 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetApplDayCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkAppDetApplDayCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * wtmWorkAppDet 단건 조회 3 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getWtmWorkAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkAppDetList", paramMap);
	}
	
	/**
	 * wtmWorkAppDet 변경전 신청서 내용 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetBefore(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkAppDetBefore", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmWorkAppDetHour 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetHour(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkAppDetHour", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmWorkAppDetRestCnt 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetRestCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkAppDetRestCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmWorkAppDetDayCnt 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetDayCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkAppDetDayCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmWorkAppDetStatusCd 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetStatusCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkAppDetStatusCd", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getWtmWorkAppDetPlanPopupMap 단건 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetPlanPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkAppDetPlanPopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}


	/**
	 * 근무신청 일자별 근무시간 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkAppDetWorkHours(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkAppDetWorkHours", paramMap);
	}

	/**
	 * 신청서 수정/삭제를 위한 이전 신청 정보 조회 Service
	 *
	 * @param paramMap {Map} 파라미터
	 * @return Map {Map} 결과값
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkAppDetInfoForUpd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkAppDetInfoForUpd", paramMap);
		Log.Debug();
		return resultMap;
	}
	
}