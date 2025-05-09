package com.hr.wtm.workMgr.wtmWorkCalendar;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.wtm.calc.dto.WtmDailyCountDTO;
import com.hr.wtm.calc.dto.WtmWrkDtlDTO;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 근태/근무캘린더 Service
 *
 * @author OJS
 *
 */
@Service
public class WtmWorkCalendarService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	/**
	 * WtmWorkCalendar 출/퇴근 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkCalendarInOutList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		List<Map<String, Object>> inOutList1 = (List<Map<String, Object>>) dao.getList("getWtmWorkCalendarInOutList1", paramMap); // 실제 출퇴근기록
		List<Map<String, Object>> inOutList2 = (List<Map<String, Object>>) dao.getList("getWtmWorkCalendarInOutList2", paramMap); // 근무스케줄
		List<Map<String, Object>> inOutList3 = (List<Map<String, Object>>) dao.getList("getWtmWorkCalendarInOutList3", paramMap); // 근무유형 default 값
		List<Map<String, Object>> inOutList4 = (List<Map<String, Object>>) dao.getList("getWtmWorkCalendarInOutList4", paramMap); // 출퇴근시간 변경신청 내역

		Map<String, Object> holidaySearchMap = new HashMap<>();
		holidaySearchMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
		holidaySearchMap.put("searchSabun", paramMap.get("searchSabun"));
		holidaySearchMap.put("sdate", paramMap.get("searchSYmd"));
		holidaySearchMap.put("edate", paramMap.get("searchEYmd"));
		List<Map<String, Object>> holidayList = (List<Map<String, Object>>) dao.getList("getWtmWorkCalendarHolidays", holidaySearchMap);

		// 근무유형 default 값은 근무일에 해당하는 데이터만 남긴다.
		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		List<Map<String, Object>> inOutList3Temp = new ArrayList<>(inOutList3);
		for(Map<String, Object> inOut : inOutList3Temp) {
			LocalDate date = LocalDate.parse(inOut.get("ymd").toString(), dateFormatter);
			String dayStr = wtmCalcWorkTimeService.convertToDayOfWeekStr(date.getDayOfWeek());

			// 근무유형 설정의 근무요일에 속하는지 확인
			String workDayStr = inOut.get("workDay").toString();
			boolean isWorkDay = workDayStr.contains(",")
					? Arrays.asList(workDayStr.split(",")).contains(dayStr)
					: dayStr.equals(workDayStr);

			// 근무요일이 아니면 삭제
			if(!isWorkDay) {
				inOutList3.remove(inOut);
			} else {
				if(holidayList != null && !holidayList.isEmpty()) {
					boolean isHoliday = holidayList.stream()
							.anyMatch(map -> map.get("ymd").equals(inOut.get("ymd").toString()) || map.get("rpYmd").equals(inOut.get("ymd").toString()));
					if(isHoliday) {
						inOutList3.remove(inOut);
					}
				}
			}
		}

		List<Map<String, Object>> inOutList = new ArrayList<>();
		inOutList.addAll(inOutList1);
		inOutList.addAll(inOutList2);
		inOutList.addAll(inOutList3);

		Map<Object, Map<String, Object>> resultMap = new HashMap<>();
		for (Map<String, Object> item : inOutList) {
			// 중복된 값을 제거하기 위한 key 설정 (회사코드|사원번호|일자)
			String key = item.get("enterCd") + "|" + item.get("sabun") + "|" + item.get("ymd");

			// 중복된 값중 우선순위가 가장 높은것만 남긴다.
			int priority = Integer.parseInt(item.get("priority").toString());
			if (!resultMap.containsKey(key) ||
					Integer.parseInt(resultMap.get(key).get("priority").toString()) > priority) {
				resultMap.put(key, item);
			}
		}

		List<Map<String, Object>> resultList = new ArrayList<>(resultMap.values());
		resultList.addAll(inOutList4);

		return resultList;
	}

	/**
	 * WtmWorkCalendar 근무 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkCalendarWorkList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkCalendarWorkList", paramMap);
	}

	/**
	 * WtmWorkCalendar 근무 리스트 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkCalendarAttendList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkCalendarAttendList", paramMap);
	}

	/**
	 * 잔여 휴가 내역 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkCalendarVacationMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkCalendarVacationMap", paramMap);
		return resultMap;
	}

	/**
	 * 출퇴근시간변경 신청 삭제
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWtmCalendarAttendTimeAdjApp(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		int cnt = 0;

		Map<String, Object> appMasterInfo = (Map<String, Object>) dao.getMap("getApprovalMgrTHRI103", paramMap);
		String ssnSabun = (String) paramMap.get("ssnSabun");
		String ssnAdminYn = (String) paramMap.get("ssnAdminYn");

		if (!"Y".equals(ssnAdminYn)
				&& (ssnSabun.equals(appMasterInfo.get("applSabun")) || ssnSabun.equals(appMasterInfo.get("applInSabun")))) {
			// TODO: 우선 삭제 할 수 있는 권한은 관리자이거나 대상자, 신청자만 가능하도록 함.
			throw new HrException("삭제할 수 있는 권한이 없습니다.");
		}

		dao.delete("deleteWtmAttendTimeAdjAppDetMaster", paramMap); //delete TWTM321
		cnt += dao.delete("deleteWtmAttendTimeAdjAppDetDetail", paramMap); //delete TWTM322
		dao.delete("deleteApprovalMgrMater", paramMap); //delete THRI103
		dao.delete("deleteApprovalMgrAgreeUser", paramMap);  //delete THRI107
		Log.DebugEnd();
		return cnt;
	}

	/**
	 * 근태 신청 삭제
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWtmAttendCalendar(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		int cnt = 0;

		Map<String, Object> appMasterInfo = (Map<String, Object>) dao.getMap("getApprovalMgrTHRI103", paramMap);
		String ssnSabun = (String) paramMap.get("ssnSabun");
		String ssnAdminYn = (String) paramMap.get("ssnAdminYn");

		if (!"Y".equals(ssnAdminYn)
				&& (ssnSabun.equals(appMasterInfo.get("applSabun")) || ssnSabun.equals(appMasterInfo.get("applInSabun")))) {
			// TODO: 우선 삭제 할 수 있는 권한은 관리자이거나 대상자, 신청자만 가능하도록 함.
			throw new HrException("삭제할 수 있는 권한이 없습니다.");
		}

		dao.delete("deleteWtmAttendCalendarMaster", paramMap); //delete TWTM301
		cnt += dao.delete("deleteWtmAttendCalendarDetail", paramMap); //delete TWTM302
		dao.delete("deleteApprovalMgrMater", paramMap); //delete THRI103
		dao.delete("deleteApprovalMgrAgreeUser", paramMap);  //delete THRI107
		Log.DebugEnd();
		return cnt;
	}

	/**
	 * 근무 신청 삭제
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWtmWorkCalendar(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = 0;

		Map<String, Object> appMasterInfo = (Map<String, Object>) dao.getMap("getApprovalMgrTHRI103", paramMap);
		String ssnSabun = (String) paramMap.get("ssnSabun");
		String ssnAdminYn = (String) paramMap.get("ssnAdminYn");

		if (!"Y".equals(ssnAdminYn)
				&& (ssnSabun.equals(appMasterInfo.get("applSabun")) || ssnSabun.equals(appMasterInfo.get("applInSabun")))) {
			// TODO: 우선 삭제 할 수 있는 권한은 관리자이거나 대상자, 신청자만 가능하도록 함.
			throw new HrException("삭제할 수 있는 권한이 없습니다.");
		}

		dao.delete("deleteWtmWorkCalendarMaster", paramMap); //delete TWTM311
		cnt += dao.delete("deleteWtmWorkCalendarDetail", paramMap); //delete TWTM312
		dao.delete("deleteApprovalMgrMater", paramMap); //delete THRI103
		dao.delete("deleteApprovalMgrAgreeUser", paramMap);  //delete THRI107
		Log.DebugEnd();
		return cnt;
	}

	public Map<?, ?> getWtmWorkCalendarWorkTimeMap(Map<String, Object> paramMap) throws Exception{
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkCalendarWorkTimeMap", paramMap);
		return resultMap;
	}

	/**
	 * 신청자 근무유형 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkCalendarWorkClass(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmWorkCalendarWorkClass", paramMap);
		return resultMap;
	}


	/**
	 * 전체 근태 코드 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getWtmWorkCalendarGntCdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkCalendarGntCdList", paramMap);
	}


	/**
	 * 전체 근무 코드 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getWtmWorkCalendarWorkCdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkCalendarWorkCdList", paramMap);
	}

	/**
	 * 기준 코드 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkCalendarBaseCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
        return dao.getMap("getWtmWorkCalendarBaseCd", paramMap);
	}

	/**
	 * 회사 휴일 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkCalendarHolidays(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkCalendarHolidays", paramMap);
	}

	/**
	 * 근무스케줄 신청일자 기준 근무달력 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?>[] getReqWorkScheduleDayList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		List<?>[] list = new ArrayList[2];

		Map<?, ?> resultMap = dao.getMap("getWtmWorkCalendarWorkClass", paramMap);

		if(!resultMap.isEmpty()) {
			List<Map<String, Object>> dateRange = new ArrayList<>();
			List<Map<?, ?>> schList = new ArrayList<>();

			if("W".equals(paramMap.get("applUnit"))) {
				String sdateStr = resultMap.get("sdate").toString();
				String weekBeginDay = resultMap.get("weekBeginDay").toString();
				String searchYmdStr = paramMap.get("searchYmd").toString().replaceAll("-", "");
				int unit = Integer.parseInt(paramMap.get("searchApplUnit").toString());

				// 시작일과 목표일 파싱
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
				LocalDate sdate = LocalDate.parse(sdateStr, formatter);
				LocalDate searchYmd = LocalDate.parse(searchYmdStr, formatter);

				// 첫 번째 해당 요일 찾기
				DayOfWeek dayOfWeek = wtmCalcWorkTimeService.convertToDayOfWeek(weekBeginDay);
				LocalDate firstDate = sdate.with(TemporalAdjusters.nextOrSame(dayOfWeek));

				// 목표 날짜가 속한 구간 찾기
				LocalDate rangeStart = firstDate;

				while (rangeStart.isBefore(searchYmd)) {
					LocalDate nextDate = rangeStart.plusWeeks(unit);
					if (searchYmd.isBefore(nextDate)) {
						break;
					}
					rangeStart = nextDate;
				}

				// 구간의 모든 날짜 생성
				LocalDate unitEndDate = rangeStart.plusWeeks(unit); // 단위기간 종료일
				LocalDate edate = LocalDate.parse(resultMap.get("edate").toString(), formatter).plusDays(1); // 근무유형 종료일
				LocalDate psnlEdate = LocalDate.parse(resultMap.get("psnlEdate").toString(), formatter).plusDays(1); // 개인별근무유형종료일

				// 단위기간 종료일, 근무유형 종료일, 개인별근무유형종료일 중 가장 이른 날짜를 실제 종료일로 설정한다.
				LocalDate endDate = Collections.min(Arrays.asList(unitEndDate, edate, psnlEdate));

				for (LocalDate date = rangeStart; date.isBefore(endDate); date = date.plusDays(1)) {
					Map dayMap = new HashMap<String, Object>();
					dayMap.put("ymd", date.format(formatter));
					dayMap.put("date", date.getDayOfMonth());
					dayMap.put("day", date.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.KOREAN));

					dateRange.add(dayMap);
				}

				LocalDate psnlSdate = LocalDate.parse(resultMap.get("psnlSdate").toString(), formatter); // 개인 근무유형 시작일
				String sYmd = rangeStart.format(formatter);
				if (psnlSdate.isAfter(rangeStart)) {
					sYmd = psnlSdate.format(formatter);
				}
				String eYmd = endDate.format(formatter);

				paramMap.put("sYmd", sYmd);
				paramMap.put("eYmd", eYmd);
			} else if("M".equals(paramMap.get("applUnit"))) {
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
				String searchYmdStr = paramMap.get("searchYmd").toString().replaceAll("-", "");
				LocalDate searchDate = LocalDate.parse(searchYmdStr, formatter);
				int unit = Integer.parseInt(paramMap.get("searchApplUnit").toString());

				/* 단위기간 종료일, 근무유형 종료일, 개인별근무유형종료일 중 가장 이른 날짜를 실제 종료일로 설정한다. */
				// 단위기간 종료일 찾기(기준일자 + 단위기간월 의 마지막 날짜)
				LocalDate unitEndDate = searchDate.plusMonths(unit-1).withDayOfMonth(searchDate.plusMonths(unit-1).lengthOfMonth());

				// 근무유형 종료일
				LocalDate edate = LocalDate.parse(resultMap.get("edate").toString(), formatter).plusDays(1); // 근무유형 종료일

				// 개인별근무유형종료일
				LocalDate psnlEdate = LocalDate.parse(resultMap.get("psnlEdate").toString(), formatter).plusDays(1); // 개인별근무유형종료일

				// 최종 종료일
				LocalDate endDate = Collections.min(Arrays.asList(unitEndDate, edate, psnlEdate));

				/* 단위기간 시작일, 개인근무유형시작일 중 더 늦은 날짜를 실제 시작일로 설정한다. */
				LocalDate psnlSdate = LocalDate.parse(resultMap.get("psnlSdate").toString(), formatter); // 개인 근무유형 시작일
				LocalDate unitSdate = searchDate.withDayOfMonth(1);
				String sYmd = unitSdate.format(formatter);
				if (psnlSdate.isAfter(unitSdate)) {
					sYmd = psnlSdate.format(formatter);
				}
				String eYmd = endDate.format(formatter);

				paramMap.put("sYmd", sYmd);
				paramMap.put("eYmd", eYmd);

				Map rangeMap = new HashMap<String, Object>();
				rangeMap.put("sYmd", sYmd);
				rangeMap.put("eYmd", eYmd);
				dateRange.add(rangeMap);
			}

			// 구간의 근무 스케줄 가져오기
			schList = (List<Map<?, ?>>) dao.getList("getReqWorkScheduleSchList", paramMap);
			list[0] = dateRange;
			list[1] = schList;
		}


		return list;
	}

	/**
	 * 근무스케줄 신청 저장
	 */
	public int saveWtmReqWorkSchedule(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		// 입력 데이터 변환
		List<Map<Object, Object>> dataList = (List<Map<Object, Object>>) paramMap.get("insSchedules");
		List<Map<Object, Object>> allSchedules = (List<Map<Object, Object>>) paramMap.get("schedules");
		String ssnEnterCd = paramMap.get("ssnEnterCd").toString();
		String ssnSabun = paramMap.get("ssnSabun").toString();
		String applSeq = paramMap.get("applSeq").toString();

		dataList = dataList.stream().map(data -> {
			Map<Object, Object> tmpData = new HashMap<>(data);
			tmpData.put("ssnEnterCd", ssnEnterCd);
			tmpData.put("ssnSabun", ssnSabun);
			tmpData.put("applSeq", applSeq);
			tmpData.put("shm", data.get("shh").toString() + data.get("smm").toString());
			tmpData.put("ehm", data.get("ehh").toString() + data.get("emm").toString());
			tmpData.put("wrkDtlId", TsidCreator.getTsid().toString());
			return tmpData;
		}).collect(Collectors.toList());

		allSchedules = allSchedules.stream().map(data -> {
			data.put("ssnEnterCd", ssnEnterCd);
			data.put("ssnSabun", ssnSabun);
			data.put("shm", data.get("shh").toString() + data.get("smm").toString());
			data.put("ehm", data.get("ehh").toString() + data.get("emm").toString());
			return data;
		}).collect(Collectors.toList());

		try {
			wtmCalcWorkTimeService.setCode(ssnEnterCd, true); // 기본근무코드, 휴게코드 세팅
			
			// 근무스케줄 내역을 WtmWrkDtlDTO 으로 변환
			List<WtmWrkDtlDTO> allWtmWrkDtlDTOList = allSchedules.stream()
					.filter(data -> !"GNT".equals(data.get("type").toString().toUpperCase()))
					.map(data -> {
						WtmWrkDtlDTO wtmWrkDtlDTO = new WtmWrkDtlDTO();
						wtmWrkDtlDTO.setEnterCd((String) data.get("ssnEnterCd"));
						wtmWrkDtlDTO.setWrkDtlId((String) data.get("wrkDtlId"));
						wtmWrkDtlDTO.setYmd((String) data.get("ymd"));
						wtmWrkDtlDTO.setSabun((String) data.get("sabun"));
						wtmWrkDtlDTO.setName((String) data.get("name"));
						wtmWrkDtlDTO.setWorkCd((String) data.get("attCd"));
						wtmWrkDtlDTO.setPlanSymd((String) data.get("symd"));
						wtmWrkDtlDTO.setPlanShm((String) data.get("shm"));
						wtmWrkDtlDTO.setPlanEymd((String) data.get("eymd"));
						wtmWrkDtlDTO.setPlanEhm((String) data.get("ehm"));
						wtmWrkDtlDTO.setPlanMm(Integer.parseInt(data.get("mm").toString()));
						wtmWrkDtlDTO.setAddWorkTimeYn(wtmCalcWorkTimeService.getBaseWorkCd().equals(data.get("attCd")) ? "Y" : "N");
						wtmWrkDtlDTO.setWorkTimeType(wtmCalcWorkTimeService.getBaseWorkCd().equals(data.get("attCd")) ? "01" : "03"); // 근무시간종류: 기본 or 휴게
						wtmWrkDtlDTO.setRequestUseType("NA");
						return wtmWrkDtlDTO;
					})
					.collect(Collectors.toList());

			// 저장 조건 체크
			boolean chkConditionYn = checkWorkSchCondition(allWtmWrkDtlDTOList, paramMap, true);

			// 저장 조건 체크 후 저장.
			if(chkConditionYn) {
				cnt += dao.updateBatchMode("saveWtmReqWorkSchedule", paramMap);
				paramMap.put("dataList", dataList);
				cnt += dao.updateBatchMode("saveWtmReqWorkScheduleDetail", paramMap);
			}

			// 근무스케줄 신청 상세를 WtmWrkDtlDTO 으로 변환
			List<WtmWrkDtlDTO> addWtmWrkList = dataList.stream()
					.map(data -> {
						WtmWrkDtlDTO wtmWrkDtlDTO = new WtmWrkDtlDTO();
						wtmWrkDtlDTO.setEnterCd((String) data.get("ssnEnterCd"));
						wtmWrkDtlDTO.setWrkDtlId((String) data.get("wrkDtlId"));
						wtmWrkDtlDTO.setYmd((String) data.get("ymd"));
						wtmWrkDtlDTO.setSabun((String) data.get("sabun"));
						wtmWrkDtlDTO.setName((String) data.get("name"));
						wtmWrkDtlDTO.setWorkCd((String) data.get("attCd"));
						wtmWrkDtlDTO.setPlanSymd((String) data.get("symd"));
						wtmWrkDtlDTO.setPlanShm((String) data.get("shm"));
						wtmWrkDtlDTO.setPlanEymd((String) data.get("eymd"));
						wtmWrkDtlDTO.setPlanEhm((String) data.get("ehm"));
						wtmWrkDtlDTO.setPlanMm(Integer.parseInt(data.get("mm").toString()));
						wtmWrkDtlDTO.setAddWorkTimeYn(wtmCalcWorkTimeService.getBaseWorkCd().equals(data.get("attCd")) ? "Y" : "N");
						wtmWrkDtlDTO.setWorkTimeType(wtmCalcWorkTimeService.getBaseWorkCd().equals(data.get("attCd")) ? "01" : "03"); // 근무시간종류: 기본 or 휴게
						wtmWrkDtlDTO.setRequestUseType("NA");
						return wtmWrkDtlDTO;
					})
					.collect(Collectors.toList());

			// 근무상세 근무스케줄 변경전 내역
			List<Map<String, Object>> bfWorkDetailList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmWorkCalendarBfWorkList", paramMap);
			List<WtmWrkDtlDTO> excWtmWrkList = bfWorkDetailList.stream()
					.map(data -> {
						WtmWrkDtlDTO wtmWrkDtlDTO = new WtmWrkDtlDTO();
						wtmWrkDtlDTO.setEnterCd((String) data.get("enterCd"));
						wtmWrkDtlDTO.setWrkDtlId((String) data.get("wrkDtlId"));
						wtmWrkDtlDTO.setYmd((String) data.get("ymd"));
						wtmWrkDtlDTO.setSabun((String) data.get("sabun"));
						wtmWrkDtlDTO.setName((String) data.get("name"));
						wtmWrkDtlDTO.setWorkCd((String) data.get("workCd"));
						wtmWrkDtlDTO.setPlanSymd((String) data.get("planSymd"));
						wtmWrkDtlDTO.setPlanShm((String) data.get("planShm"));
						wtmWrkDtlDTO.setPlanEymd((String) data.get("planEymd"));
						wtmWrkDtlDTO.setPlanEhm((String) data.get("planEhm"));
						wtmWrkDtlDTO.setPlanMm(Integer.parseInt(data.get("planMm").toString()));
						wtmWrkDtlDTO.setAddWorkTimeYn((String) data.get("addWorkTimeYn"));
						wtmWrkDtlDTO.setWorkTimeType((String) data.get("workTimeType"));
						wtmWrkDtlDTO.setRequestUseType((String) data.get("requestUseType"));
						return wtmWrkDtlDTO;
					})
					.collect(Collectors.toList());


			// 근무한도체크를 위한 파라미터 설정
			Map<String, Object> checkLimitParam = new HashMap<String, Object>();
			checkLimitParam.put("enterCd", ssnEnterCd);				// 회사코드
			checkLimitParam.put("sabun", ssnSabun);					// 근무한도 체크 사번
			checkLimitParam.put("sdate", paramMap.get("sdate").toString().replaceAll("-", ""));	// 근무한도 체크 시작일
			checkLimitParam.put("edate", paramMap.get("edate").toString().replaceAll("-", ""));	// 근무한도 체크 종료일
			checkLimitParam.put("addWrkList", addWtmWrkList); 		// TWTM102 데이터 외에 추가할 근무 리스트 -> 신규 신청 리스트
			checkLimitParam.put("excWrkList", excWtmWrkList); 		// TWTM102 데이터에서 제외할 근무 리스트 -> 기존 근무 리스트
			checkLimitParam.put("addGntList", null);		 		// TWTM103 데이터에서 추가할 근태 리스트
			checkLimitParam.put("excGntList", null); 				// TWTM103 데이터에서 제외할 근태 리스트

			List<Map<String, Object>> paramList = new ArrayList<>();
			paramList.add(checkLimitParam);

			// 근무시간 한도 체크 함수 실행
			boolean hoursLimitYn = wtmCalcWorkTimeService.checkWorkTimeLimit(paramList, true);
			

			/*// 근무시간 한도 체크 할 단위 기간 조회
			Map searchMap = new HashMap<>();
			searchMap.put("ssnEnterCd", ssnEnterCd);
			searchMap.put("sdate", paramMap.get("sdate"));
			searchMap.put("edate", paramMap.get("edate"));
			searchMap.put("workClassCd", paramMap.get("workClassCd"));

			Map unitMap = wtmCalcWorkTimeService.getWorkTimeUnitRange(searchMap, true);
			paramMap.put("unitSdate", unitMap.get("unitSdate"));
			paramMap.put("unitEdate", unitMap.get("unitEdate"));

			// 단위 기간 전체의 근무 상세 내역
			List<Map<String, Object>> workDetailList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmWorkCalendarWorkDetailList", paramMap);

			// 근무상세 근무스케줄 변경전 내역
			List<Map<String, Object>> bfWorkDetailList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmWorkCalendarBfWorkList", paramMap);

			// 근무상세 내역에서 근무스케줄 변경 전 내역을 신청한 근무스케줄 데이터로 대체한다.
			workDetailList.removeAll(bfWorkDetailList);

			// workDetailList의 각 항목을 WtmWrkDtlDTO로 변환하여 추가
			workDetailList.forEach(data -> {
				WtmWrkDtlDTO wtmWrkDtlDTO = new WtmWrkDtlDTO();
				wtmWrkDtlDTO.setEnterCd((String) data.get("enterCd"));
				wtmWrkDtlDTO.setWrkDtlId((String) data.get("wrkDtlId"));
				wtmWrkDtlDTO.setYmd((String) data.get("ymd"));
				wtmWrkDtlDTO.setSabun((String) data.get("sabun"));
				wtmWrkDtlDTO.setName((String) data.get("name"));
				wtmWrkDtlDTO.setWorkCd((String) data.get("workCd"));
				wtmWrkDtlDTO.setPlanSymd((String) data.get("planSymd"));
				wtmWrkDtlDTO.setPlanShm((String) data.get("planShm"));
				wtmWrkDtlDTO.setPlanEymd((String) data.get("planEymd"));
				wtmWrkDtlDTO.setPlanEhm((String) data.get("planEhm"));
				wtmWrkDtlDTO.setPlanMm(Integer.parseInt(data.get("planMm").toString()));
				wtmWrkDtlDTO.setAddWorkTimeYn((String) data.get("addWorkTimeYn"));
				wtmWrkDtlDTO.setWorkTimeType((String) data.get("workTimeType"));
				wtmWrkDtlDTO.setRequestUseType((String) data.get("requestUseType"));
				wtmWrkDtlDTOList.add(wtmWrkDtlDTO);
			});

			// 근태상세 내역
			List<Map<String, Object>> gntDetailList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmWorkCalendarGntList", paramMap); // 근태상세
			// 근태 상세 조회 결과를 WtmGntDtlDTO 으로 변환
			List<WtmGntDtlDTO> wtmGntDtlDTOList = gntDetailList.stream()
					.map(data -> {
						WtmGntDtlDTO wtmGntDtlDTO = new WtmGntDtlDTO();
						wtmGntDtlDTO.setEnterCd((String) data.get("enterCd"));
						wtmGntDtlDTO.setGntDtlId((String) data.get("gntDtlId"));
						wtmGntDtlDTO.setYmd((String) data.get("ymd"));
						wtmGntDtlDTO.setSabun((String) data.get("sabun"));
						wtmGntDtlDTO.setName((String) data.get("name"));
						wtmGntDtlDTO.setGntCd((String) data.get("gntCd"));
						wtmGntDtlDTO.setSymd((String) data.get("symd"));
						wtmGntDtlDTO.setShm((String) data.get("shm"));
						wtmGntDtlDTO.setEymd((String) data.get("eymd"));
						wtmGntDtlDTO.setEhm((String) data.get("ehm"));
						wtmGntDtlDTO.setMm(Integer.parseInt(data.get("mm").toString()));
						return wtmGntDtlDTO;
					})
					.collect(Collectors.toList());

			// 일별 근무,휴게시간 합산
			List<WtmDayCalcTimeDTO> wtmDayCalcTimeDTOList = wtmCalcWorkTimeService.sumWtmDayWorkTime(wtmWrkDtlDTOList, null, wtmGntDtlDTOList);
			// 근무시간 한도 체크
			boolean hoursLimitYn = wtmCalcWorkTimeService.checkWorkLimit(wtmDayCalcTimeDTOList, paramMap, true);
*/
			if(!hoursLimitYn) {
				throw new HrException("근무시간 한도 체크에 실패했습니다.");
			}
		} catch (HrException e) {
			throw new HrException(e.getMessage());
		}

		return cnt;
	}

	/**
	 * 근무스케쥴 신청 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmReqWorkScheduleDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmReqWorkScheduleDet", paramMap);
	}

	/**
	 * 근무스케줄 조건 충족여부 계산
	 * @param wtmWrkDtlDTOList 일별 근무 스케줄 리스트
	 * @return 근무스케줄 조건 충족여부
	 * @throws Exception 근무스케줄 조건 미충족 대상자 알림용 Exception
	 */
	public boolean checkWorkSchCondition(List<WtmWrkDtlDTO> wtmWrkDtlDTOList, Map<String, Object> paramMap, boolean isBatch) throws Exception {
		Map<String, Object> workClassInfo = null;
		List<Map<String, Object>> holidayList = null;

		if(isBatch) {
			workClassInfo = (Map<String, Object>) dao.getMapBatchMode("getWtmWorkClassCd", paramMap);
			holidayList = (List<Map<String, Object>>) dao.getListBatchMode("getWtmWorkCalendarHolidays", paramMap);
		} else {
			workClassInfo = (Map<String, Object>) dao.getMap("getWtmWorkClassCd", paramMap);
			holidayList = (List<Map<String, Object>>) dao.getList("getWtmWorkCalendarHolidays", paramMap);
		}

		String sdate = paramMap.get("sdate").toString().replaceAll("-", "");
		String edate = paramMap.get("edate").toString().replaceAll("-", "");

		// 일별 근무,휴게시간 합산
		List<WtmDailyCountDTO> wtmDailyCountDTOList = wtmCalcWorkTimeService.sumWtmDayWorkTime(wtmWrkDtlDTOList);

		if(!workClassInfo.isEmpty()) {
			DateTimeFormatter dateFormatter1 = DateTimeFormatter.ofPattern("yyyyMMdd");
			DateTimeFormatter dateFormatter2 = DateTimeFormatter.ofPattern("yyyy.MM.dd");

			/* 1. 근무 시작 시간 유효성 체크 */
			// 1-1.근무유형의 근무시작시간과 근무스케줄의 근무시작시간의 값이 다른 경우 Exception 처리.
			String workTimeF = workClassInfo.get("workTimeF").toString();
			if(!workTimeF.isEmpty()) {
				Optional<WtmWrkDtlDTO> shmMatchCheck = wtmWrkDtlDTOList.stream()
						.filter(dto-> dto.getWorkCd().equals(wtmCalcWorkTimeService.getBaseWorkCd()) && !dto.getPlanShm().equals(workTimeF))
						.findFirst();

				if(shmMatchCheck.isPresent()) {
					WtmWrkDtlDTO dto = shmMatchCheck.get();
					LocalDate date = LocalDate.parse(dto.getYmd(), dateFormatter1);
					String formattedDate = date.format(dateFormatter2);
					String nameStr = dto.getName().isEmpty() ? "" : dto.getName() + "님이 ";
					throw new HrException("[근무시작시간 미충족]" + nameStr + formattedDate+ " 일 근무시작시간을 미충족 하였습니다. (계획: " + dto.getPlanShm() + "/ 표준:" + workTimeF + ")");
				}
			}

			// 1-2. 근무유형의 출근가능시간 범위를 벗어난 경우 Exception 처리.
			String startWorkTimeF = workClassInfo.get("startWorkTimeF").toString();
			String startWorkTimeT = workClassInfo.get("startWorkTimeT").toString();
			if(!startWorkTimeF.isEmpty()) {
				Optional<WtmWrkDtlDTO> shmMatchCheck = wtmWrkDtlDTOList.stream()
						.filter(dto-> dto.getWorkCd().equals(wtmCalcWorkTimeService.getBaseWorkCd()) && Integer.parseInt(startWorkTimeF) > Integer.parseInt(dto.getPlanShm()))
						.findFirst();

				if(shmMatchCheck.isPresent()) {
					WtmWrkDtlDTO dto = shmMatchCheck.get();
					LocalDate date = LocalDate.parse(dto.getYmd(), dateFormatter1);
					String formattedDate = date.format(dateFormatter2);
					String nameStr = dto.getName().isEmpty() ? "" : dto.getName() + "님이 ";
					throw new HrException("[근무시작시간 미충족]" + nameStr + formattedDate+ " 일 출근가능시간 범위를 벗어났습니다. (계획: " + dto.getPlanShm() + "/ 출근시간 범위: " + startWorkTimeF + " ~ " + startWorkTimeT + ")");
				}
			}

			if(!startWorkTimeT.isEmpty()) {
				Optional<WtmWrkDtlDTO> shmMatchCheck = wtmWrkDtlDTOList.stream()
						.filter(dto-> dto.getWorkCd().equals(wtmCalcWorkTimeService.getBaseWorkCd()) && Integer.parseInt(startWorkTimeT) < Integer.parseInt(dto.getPlanShm()))
						.findFirst();

				if(shmMatchCheck.isPresent()) {
					WtmWrkDtlDTO dto = shmMatchCheck.get();
					LocalDate date = LocalDate.parse(dto.getYmd(), dateFormatter1);
					String formattedDate = date.format(dateFormatter2);
					String nameStr = dto.getName().isEmpty() ? "" : dto.getName() + "님이 ";
					throw new HrException("[근무시작시간 미충족]" + nameStr + formattedDate+ " 일 출근가능시간 범위를 벗어났습니다. (계획: " + dto.getPlanShm() + "/ 출근시간 범위:" + startWorkTimeF + " ~ " + startWorkTimeT + ")");
				}
			}

			/* 2. 코어타임 유효성 체크 */
			String coreTimeF = workClassInfo.get("coreTimeF").toString();
			String coreTimeT = workClassInfo.get("coreTimeT").toString();
			if(!coreTimeF.isEmpty() && !coreTimeT.isEmpty()) {
				Optional<WtmWrkDtlDTO> coreTimeMatchCheck = wtmWrkDtlDTOList.stream()
						.filter(dto-> dto.getWorkCd().equals(wtmCalcWorkTimeService.getBaseWorkCd()) && !(Integer.parseInt(coreTimeF) > Integer.parseInt(dto.getPlanShm()) && Integer.parseInt(coreTimeT) < Integer.parseInt(dto.getPlanEhm())))
						.findFirst();

				if(coreTimeMatchCheck.isPresent()) {
					WtmWrkDtlDTO dto = coreTimeMatchCheck.get();
					LocalDate date = LocalDate.parse(dto.getYmd(), dateFormatter1);
					String formattedDate = date.format(dateFormatter2);
					String nameStr = dto.getName().isEmpty() ? "" : dto.getName() + "님이 ";
					throw new HrException("[코어타임 미충족]" + nameStr + formattedDate+ " 일 코어타임 범위를 벗어났습니다. (코어타임:" + coreTimeF + " ~ " + coreTimeT + ")");
				}
			}

			/* 3. 근무 종료시간 체크 */
			// 근무유형의 근무종료시간과 근무스케줄의 근무종료시간의 값이 다른 경우 Exception 처리.
			String workTimeT = workClassInfo.get("workTimeF").toString();
			if(!workTimeT.isEmpty()) {
				Optional<WtmWrkDtlDTO> shmMatchCheck = wtmWrkDtlDTOList.stream()
						.filter(dto-> dto.getWorkCd().equals(wtmCalcWorkTimeService.getBaseWorkCd()) && !dto.getPlanEhm().equals(workTimeT))
						.findFirst();

				if(shmMatchCheck.isPresent()) {
					WtmWrkDtlDTO dto = shmMatchCheck.get();
					LocalDate date = LocalDate.parse(dto.getYmd(), dateFormatter1);
					String formattedDate = date.format(dateFormatter2);
					String nameStr = dto.getName().isEmpty() ? "" : dto.getName() + "님이 ";
					throw new HrException("[근무종료시간 미충족]" + nameStr + formattedDate+ " 일 근무종료시간을 미충족 하였습니다. (계획: " + dto.getPlanEhm() + "/ 표준:" + workTimeT + ")");
				}
			}

			/* 4. 근무일수 체크 */
			// 근무시간을 입력하지 않은 날짜가 있는지 확인.
			DateTimeFormatter formatYmd = dateFormatter1;
			LocalDate startDate = LocalDate.parse(sdate, formatYmd);
			LocalDate endDate = LocalDate.parse(edate, formatYmd);
			LocalDate today = LocalDate.now();
			LocalDate tomorrow = today.plusDays(1);

			// 만약 당일근무변경가능여부가 Y 인 경우, 시작일과 오늘날짜 중 더 이후의 날짜를 입력여부 체크 시작일로 설정
			if("Y".equals(workClassInfo.get("startWorkTimeF").toString())) {
				startDate = Collections.max(Arrays.asList(startDate, today));
			} else {
				// 시작일과 내일날짜 중 더 이후의 날짜를 입력여부 체크 시작일로 설정
				startDate = Collections.max(Arrays.asList(startDate, tomorrow));
			}

			// 시작일 ~ 종료일까지의 근무시간 입력 여부를 확인한다.
			int workDays = 0; // 근무일수
			for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
				String currentYmd = date.format(formatYmd);

				boolean isHoliday = holidayList.stream().anyMatch(holiday -> holiday.get("ymd").equals(currentYmd)); // 공휴일 여부
				String workDay = workClassInfo.get("workDay").toString();
				String currentDay = date.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH).toUpperCase();
				boolean isDayOff = !(Arrays.asList(workDay.split(",")).contains(currentDay));

				// 휴일(공휴일,주휴일,휴무일)이 아닌데 근무시간이 입력되지 않은 경우, Exception 처리
				if(!(isHoliday || isDayOff)) {
					workDays++; // 근무일수 + 1
					boolean workDaysChk = wtmDailyCountDTOList.stream()
							.anyMatch(dto -> dto.getYmd().equals(currentYmd) && dto.getBasicMm() > 0);

					if(!workDaysChk) {
						throw new HrException("[근무 미등록] " + date.format(dateFormatter2) + " 일 근무 스케줄이 입력되지 않았습니다.");
					}
				}
			}

			/* 5. 근무시간 체크 */
			String weekBeginDay = "MON";
			if(workClassInfo.get("intervalCd").toString().isEmpty() && !workClassInfo.get("workHours").toString().isEmpty()) {
				// 5-1. 근무유형관리-근무시간기준에 단위기간 값이 없는 근무유형은 입력한 근무시간이 표준근무시간과 일치하는지 체크
				// => 근무시간기준에 단위기간이 없다는건 하루에 표준 근무시간을 무조건 충족 해야한다는 말과 동일.

				// 표준근무시간(분기준): 표준근무시간 * 60
				int stdWorkMins = Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfo.get("workHours").toString(), "0")) * 60;

				// 오늘 이후 날짜 중 표준 근무시간을 충족하지 못하는 케이스가 있는지 확인
				String todayDate = LocalDate.now().format(dateFormatter1);
				Optional<WtmDailyCountDTO> dayMatchCheck = wtmDailyCountDTOList.stream()
						.filter(dto -> dto.getBasicMm() != stdWorkMins && dto.getYmd().compareTo(todayDate) > 0)
						.findFirst();

				if(dayMatchCheck.isPresent()) {
					// 표준 근무시간을 충족하지 못하는 케이스가 있다면 Exception 처리
					WtmDailyCountDTO dto = dayMatchCheck.get();

					LocalDate date = LocalDate.parse(dto.getYmd(), dateFormatter1);
					StringBuilder errMsg = new StringBuilder();
					errMsg.append("[일 근무시간 미충족]\n")
							.append(date.format(dateFormatter2))
							.append("일 표준 근무시간을 미충족 하였습니다.\n")
							.append("오류사번: ")
							.append(dto.getSabun())
							.append(String.format(" (계획: %.1f시간 / 표준 근무시간: %.1f시간)\n",
									(double)dto.getBasicMm()/60, (double)stdWorkMins/60 ));
					throw new HrException(errMsg.toString());
				}
			} else if (!workClassInfo.get("intervalCd").toString().isEmpty() && !workClassInfo.get("workHours").toString().isEmpty()) {
				// 5-2. 근무시간기준 단위 기간이 존재하는 경우, 표준근무시간 * 근무일수로 근무시간 충족여부 계산 => 선택근무제인경우에만.
				double totWorkHours = workDays * Integer.parseInt(StringUtils.defaultIfEmpty(workClassInfo.get("workHours").toString(), "0")) * 60;
				double totPlanWorkHours = wtmDailyCountDTOList.stream()
						.mapToDouble(dto -> dto.getBasicMm())
						.sum();

				if(totWorkHours > totPlanWorkHours) {
					throw new HrException("[일 근무시간 미충족] 표준 근무시간을 미충족 하였습니다."+ "(계획: " + (double)totPlanWorkHours/60 + "시간 / 표준 근무시간:" + ((double)totWorkHours/60) + "시간)");
				}
			}
		}

		return true;
	}
}