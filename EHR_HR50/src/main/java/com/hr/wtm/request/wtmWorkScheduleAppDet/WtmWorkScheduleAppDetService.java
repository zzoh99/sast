package com.hr.wtm.request.wtmWorkScheduleAppDet;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 부서근무스케쥴신청 Service
 *
 * @author
 *
 */
@Service("WtmWorkScheduleAppDetService")
public class WtmWorkScheduleAppDetService {
	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	/**
	 * 근무스케쥴 신청 헤더 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkScheduleAppDetHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkScheduleAppDetHeaderList", paramMap);
	}

	/**
	 * 근무스케쥴 신청 조회
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkScheduleAppDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getWtmWorkScheduleAppDet", paramMap);
	}

	/**
	 * 근무스케쥴 신청 상세 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkScheduleAppDetDetailList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<Map<Object, Object>> header = (List<Map<Object, Object>>) dao.getList("getWtmWorkScheduleAppDetHeaderList", paramMap);
		List<Map<Object, Object>> data = (List<Map<Object, Object>>) dao.getList("getWtmWorkScheduleAppDetDetailList", paramMap);
		List<Map<Object, Object>> holidays = (List<Map<Object, Object>>) dao.getList("getWtmWorkScheduleAppDetHolidays", paramMap);
		Map workClassInfo = dao.getMap("getWtmWorkScheduleAppDetWorkClass", paramMap);

		String ssnEnterCd = paramMap.get("ssnEnterCd").toString();
		wtmCalcWorkTimeService.setCode(ssnEnterCd, false);

		// 근무일/휴무일 Set 생성
		Set<String> workDays = new HashSet<>(Arrays.asList(workClassInfo.get("workDay").toString().split(",")));
		Set<String> restDays = new HashSet<>(Arrays.asList(workClassInfo.get("weekRestDay").toString().split(",")));

		// 신청데이터 + 기존근무스케줄
		List<Map<Object, Object>> temp = data;
		data = data.stream()
				.filter(map ->
						!("N".equals(map.get("newDataYn")) &&
								temp.stream()
										.anyMatch(m ->
												"Y".equals(m.get("newDataYn")) &&
														m.get("enterCd").equals(map.get("enterCd")) &&
														m.get("sabun").equals(map.get("sabun")) &&
														m.get("ymd").equals(map.get("ymd")) &&
														m.get("workCd").equals(map.get("workCd"))
										)
						)
				)
				.collect(Collectors.toList());


		// 회사코드, 사원번호를 key로 해서 List 생성후, 헤더와 일치하는 key 생성
		Set<String> keys = new HashSet<>();
		List<Map<String, Object>> rowList = data.stream()
				.filter(map -> keys.add(map.get("enterCd") + "|" + map.get("sabun")))
				.map(map -> {
					Map<String, Object> newMap = new HashMap<>();
					newMap.put("enterCd", map.get("enterCd"));
					newMap.put("sabun", map.get("sabun"));
					newMap.put("name", map.get("name"));
					newMap.put("jikweeNm", map.get("jikweeNm"));

					String bpCd = map.get("bpCd").toString();
					// header의 saveName을 key로 사용
					header.forEach(headerMap -> {
						if (headerMap.containsKey("saveName")) {
							String saveName = headerMap.get("saveName").toString();
							String ymd = headerMap.get("ymd").toString();
							newMap.put(saveName, null); // 초기값 null로 생성
							
							// 요일 확인
							LocalDate date = LocalDate.parse(ymd, DateTimeFormatter.ofPattern("yyyyMMdd"));
							String dayOfWeek = date.format(DateTimeFormatter.ofPattern("E", Locale.ENGLISH)).toUpperCase();

							// 근무일/휴무일/주휴일 체크
							if (!workDays.contains(dayOfWeek)) {
								newMap.put(saveName, restDays.contains(dayOfWeek) ? "주휴일" : "휴무일");
							}

							// 공휴일 확인
							Optional<Map<Object, Object>> holidayMap = holidays.stream()
									.filter(holiday -> holiday.get("bpCd").equals(bpCd) && holiday.get("ymd").equals(ymd))
									.findFirst();
							holidayMap.ifPresent(holiday -> newMap.put(saveName, holiday.get("holidayNm")));
						}
					});

					return newMap;
				})
				.collect(Collectors.toList());

		// 신청데이터를 회사코드, 사원번호별로 그룹핑(그룹 key: 회사코드|사번)
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");
		Map<String, Map<String, Object>> enterCdSabunGrpMap = data.stream()
				.collect(Collectors.groupingBy(
						map -> map.get("enterCd") + "|" + map.get("sabun"),
						Collectors.collectingAndThen(
								Collectors.groupingBy(
										map -> map.get("ymd"),  // ymd를 key로 하는 map 생성
										Collectors.mapping(
												map -> {
													// 신청 데이터 가공
													Map<String, Object> timeMap = new HashMap<>();
													LocalDateTime sTimeDate = LocalDateTime.parse(map.get("symd").toString() + map.get("shm").toString(), formatter);
													LocalDateTime eTimeDate = LocalDateTime.parse(map.get("eymd").toString() + map.get("ehm").toString(), formatter);

													timeMap.put("enterCd", map.get("enterCd"));
													timeMap.put("sabun", map.get("sabun"));
													timeMap.put("name", map.get("name"));
													timeMap.put("jikweeNm", map.get("jikweeNm"));
													timeMap.put("date", map.get("ymd"));
													timeMap.put("type", map.get("workCd"));
													timeMap.put("from", sTimeDate);
													timeMap.put("to", eTimeDate);
													timeMap.put("min", Integer.parseInt(map.get("mm").toString()));
													return timeMap;
												},
												Collectors.toList()
										)
								),
								groupedValues -> {
									Map<String, Object> newMap = new HashMap<>();
									// 현재 그룹의 첫 번째 데이터에서 값을 가져옴
									Map<String, Object> firstItem = groupedValues.values().iterator().next().get(0);
									newMap.put("enterCd", firstItem.get("enterCd"));
									newMap.put("sabun", firstItem.get("sabun"));
									newMap.put("name", firstItem.get("name"));
									newMap.put("jikweeNm", firstItem.get("jikweeNm"));
									newMap.put("timeData", groupedValues);  // 전체 날짜 데이터를 저장
									return newMap;
								}
						)
				));

		// 그룹핑한 데이터를 바탕으로 일별 근무시간 구하고, rowList 에 입력
		for(Map<String, Object> row : rowList) {
			String key = row.get("enterCd").toString() + "|" + row.get("sabun").toString();

			int termTimeMin = 0;

			Map<String, List<Map<String, Object>>> timeDateList = (Map<String, List<Map<String, Object>>>) enterCdSabunGrpMap.get(key).get("timeData");
			for (Map.Entry<String, List<Map<String, Object>>> entry : timeDateList.entrySet()) {
				String ymd = entry.getKey();
				List<Map<String, Object>> dataList = entry.getValue();  // 해당 날짜의 데이터 리스트
				// 근무 시작시간
				Optional<LocalDateTime> time = dataList.stream()
						.map(item -> (LocalDateTime) item.get("from"))
						.min(LocalDateTime::compareTo);
				LocalDateTime sWkTimeDate = time.orElse(null);

				// 근무 종료시간
				time = dataList.stream()
						.map(item -> (LocalDateTime) item.get("to"))
						.max(LocalDateTime::compareTo);
				LocalDateTime eWkTimeDate = time.orElse(null);

				// 근무 시작,종료 시간을 바탕으로 총근무시간 계산(총근무시간: 근무 시작 시간 ~ 근무 종료 시간 사이의 시간)
				int totWork = (int) Duration.between(sWkTimeDate, eWkTimeDate).toMinutes();
				int workTime = totWork;

				// 휴게시간 합계
				int breakTimes = calcDedTime(dataList, wtmCalcWorkTimeService.getBreakWorkCd(), sWkTimeDate, eWkTimeDate);
				workTime -= breakTimes; // 근무시간: 총 근무시간 - 휴게시간
				termTimeMin += workTime;

				// 근무시작, 종료시간 입력
				DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
				String sWkTime = sWkTimeDate.format(timeFormatter);
				String eWkTime = eWkTimeDate.format(timeFormatter);

				String saveName = "sn"+ymd;
				if(row.containsKey(saveName)) {
					row.put(saveName, sWkTime + "-" + eWkTime);
				}

				// 성명, 직위
//				row.put("name", dataList.get(0).get("name"));
//				row.put("jikweeNm", dataList.get(0).get("jikweeNm"));
			}
			// 단위 근무시간 합산 처리
			row.put("termTimeHour", termTimeMin/60);
		}

		return rowList;
	}

	/**
	 * 근무스케줄 기 신청 건 체크
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmWorkScheduleAppDetDupCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getWtmWorkScheduleAppDetDupCnt", paramMap);
	}














	/**
	 * 부서근무스케쥴신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmWorkScheduleAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.delete("deleteWtmWorkScheduleAppDetList", convertMap);
		cnt += dao.update("saveWtmWorkScheduleAppDet", convertMap);
		
		ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
		dao.updateBatchMode("saveWtmWorkScheduleAppDetList", (List<Map<?,?>>)convertMap.get("mergeRows"));
		
		
		Log.Debug();
		return cnt;
	}




	// 타입별 차감 시간 계산 함수 (일정 데이터, type, 인정 출근시간, 인정 종료시간)
	public static int calcDedTime(List<Map<String, Object>> data,String type, LocalDateTime startTime, LocalDateTime endTime) {
		int time = 0;
		List<Map<String, Object>> vacationItems = data.stream()
				.filter(item -> type.equals(item.get("type")))
				.collect(Collectors.toList());
		for (Map<String, Object> item : vacationItems) {
			LocalDateTime from = (LocalDateTime) item.get("from");
			LocalDateTime to = (LocalDateTime) item.get("to");

			// 휴게 시작 시간(출근 시간과 비교)
			LocalDateTime calFrom = from.isBefore(startTime) ? startTime : from;
			if(calFrom.isAfter(to)) continue;

			// 휴게 종료 시간(퇴근 시간과 비교)
			LocalDateTime calTo = to.isBefore(endTime) ? to : endTime;

			// 분차이 계산
			time += (int) Duration.between(calFrom, calTo).toMinutes();
		}

		return time;
	}

	// 타입별 시간 계산 함수 (일정 데이터, type, 인정 출근시간, 인정 종료시간)
	public static int calcTime(List<Map<String, Object>> data,String type) {
		return data.stream()
				.filter(item -> type.equals(item.get("type")))
				.mapToInt(item-> (int) item.get("min"))
				.sum();
	}
	
}