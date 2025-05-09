package com.hr.wtm.workMgr.wtmShiftSchMgr;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.wtm.calc.dto.WtmDailyCountDTO;
import com.hr.wtm.calc.dto.WtmWrkDtlDTO;
import com.hr.wtm.calc.dto.WtmWrkSchDTO;
import com.hr.wtm.calc.key.WtmCalcGroupKey;
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
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 교대조 스케줄 관리 Service
 *
 * @author OJS
 *
 */
@Service
public class WtmShiftSchMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	public List<?> getWorkScheduleList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkScheduleList", paramMap);
	}

	public List<?> getWorkClassSchDetailList(Map<String, Object> paramMap) throws Exception {

		// 선택한 근무유형 소속 직원 리스트
		List<?> empList = (List<?>) dao.getList("getWorkClassSchDetailEmpList", paramMap);
		// 근무스케줄 상세 리스트
		List<Map<String, Object>> detailList = (List<Map<String, Object>>) dao.getList("getWorkClassSchDetailList", paramMap);
		// 공휴일 리스트
		List<Map<String, Object>> holidayList = (List<Map<String, Object>>) dao.getList("getWorkClassSchDetailHolidayList", paramMap);
		// 근태 리스트
		List<Map<String, Object>> attendList = (List<Map<String, Object>>) dao.getList("getWorkClassSchDetailAttendList", paramMap);

		if (!empList.isEmpty()) {
			Set<String> checkedWorkGroupDetail = new HashSet<>();
			List<?> groupPatternList = new ArrayList<>();
			for (Object emp : empList) {
				paramMap.put("workSabun", "");
				if (emp instanceof Map) {
					Map<String, Object> empMap = (Map<String, Object>) emp;
					String workGroupCd = (String) empMap.get("workGroupCd");
					String workSabun = (String) empMap.get("sabun");

					paramMap.put("workSabun", workSabun);
					paramMap.put("workGroupCd", workGroupCd);

					// 불필요한 쿼리 중복 조회을 방지하기 위해 workGroupCd 별로 한 번만 수행하도록 함.
					if (checkedWorkGroupDetail.add(workGroupCd)) {
						groupPatternList = (List<?>) dao.getList("getWorkGroupPatternList", paramMap);
					}

					// 직원벌 설정된 스케줄 정보
					List<Map<String, Object>> details =
							detailList.stream()
									.filter(map -> workSabun.equals(map.get("sabun")))
									.collect(Collectors.toList());

					if (groupPatternList.isEmpty() && details.isEmpty()) {
						// 근무조패턴도 없고 임시저장한 근무스케줄도 없다면.. 새로 세팅해야함.
						empMap.put("schedule", new ArrayList<>());
					} else {

						Map<String, Object> patternParam = new HashMap<>(paramMap);
						String psnlSdate = empMap.get("sdate").toString();
						String psnlEdate = empMap.get("edate").toString();
						String sdate = paramMap.get("sdate").toString();
						String edate = paramMap.get("edate").toString();

						patternParam.put("sdate", psnlSdate.compareTo(sdate) > 0 ? psnlSdate : sdate);
						patternParam.put("edate",  psnlEdate.compareTo(edate) < 0 ? psnlEdate : edate);
						Map<String, Object> schedule = getWorkClassSchDetail(patternParam, groupPatternList, details);
						empMap.put("schedule", schedule.get("schedule"));
					}

					// 공휴일 정보 입력
//					List<Map<String, Object>> holiday =
//							holidayList.stream()
//									.filter(map -> empMap.get("bpCd").equals(map.get("bpCd")))
//									.collect(Collectors.toList());
//					empMap.put("holiday", holiday);

					// 근태 정보 입력
					List<Map<String, Object>> attend =
							attendList.stream()
									.filter(map -> workSabun.equals(map.get("sabun")))
									.collect(Collectors.toList());
					empMap.put("attend", attend);
				}
			}
		}

		return empList;
	}

	/**
	 * 직원별 상세 스케줄 조회
	 * 저장된 스케줄이 없으면 패턴이 적용된 스케줄 리턴, 저장된 스케줄이 있다면 저장된 값 리턴
	 * @param paramMap
	 * @param groupPatternList
	 * @param details
	 * @return 상세 스케줄
	 * @throws Exception
	 */
	public Map<String, Object> getWorkClassSchDetail(Map<String, Object> paramMap, List<?> groupPatternList, List<Map<String, Object>> details) throws Exception {
		List<Map<String, String>> patterns = new ArrayList<>();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");

		if (details.isEmpty()) {
			String sdate = getSdate(groupPatternList);
			LocalDate startDate = LocalDate.parse(paramMap.get("sdate").toString(), formatter);
			LocalDate endDate = LocalDate.parse(paramMap.get("edate").toString(), formatter);
			try{
				patterns = calculatePatternForMonth(LocalDate.parse(sdate, formatter), startDate, endDate, groupPatternList);
				paramMap.put("schedule", patterns);
			} catch (Exception e) {
				Log.Debug();
			}
		} else {
			paramMap.put("schedule", details);
		}

		return paramMap;
	}

	/**
	 * 근무조 스케줄 근무 시간 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getWorkClassSchDetailWorkHours(Map<String, Object> paramMap) throws Exception {

		// 스케줄 리스트
		List<?> scheduleList = (List<?>) dao.getList("getWorkScheduleList", paramMap);
		if (!scheduleList.isEmpty()) {
			for (Object schedule : scheduleList) {
				if (schedule instanceof Map) {
					Map<String, Object> scheduleMap = (Map<String, Object>) schedule;

					int workTimeF = Integer.parseInt(StringUtils.defaultIfEmpty(scheduleMap.get("workTimeF").toString(), "0"));
					int workTimeT = Integer.parseInt(StringUtils.defaultIfEmpty(scheduleMap.get("workTimeT").toString(), "0"));
					int workHours = wtmCalcWorkTimeService.calcMinutes(workTimeF, workTimeT);
					scheduleMap.put("workHours", workHours);

					// 휴게시간 계산
					String breakTimes = scheduleMap.get("breakTimes").toString();
					int breakHours = 0;
					if(!breakTimes.isEmpty()) {
						breakHours = Arrays.stream(breakTimes.split(","))
								.mapToInt(range -> {
									String[] times = range.split("-");
									int start = Integer.parseInt(times[0]);
									int end = Integer.parseInt(times[1]);

									// HHMM 포맷을 분으로 변환
									int startMinutes = ((start / 100) * 60) + (start % 100);
									int endMinutes = ((end / 100) * 60) + (end % 100);

									// 시간 차이 계산 (분 단위)
									int diffMinutes = endMinutes > startMinutes ?
											endMinutes - startMinutes :
											((24 * 60) - startMinutes + endMinutes);

									return diffMinutes;
								})
								.sum();
					}
					scheduleMap.put("breakHours", breakHours);
				}
			}
		}
		return scheduleList;
	}

	/**
	 * 근무스케줄 임시 저장
	 * @param paramMap
	 * @return 저장 건수
	 * @throws Exception
	 */
	public int saveWorkClassSchDetail(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> convertMap = new HashMap<>();
		convertMap.put("sdate", paramMap.get("sdate"));
		convertMap.put("edate", paramMap.get("edate"));
		convertMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
		convertMap.put("workClassCd", paramMap.get("workClassCd"));

		// 근무 DETAIL ID가 없는 경우 신규 ID 생성
		List<Map<String, Object>> schedules = (List<Map<String, Object>>)paramMap.get("schedules");
		schedules.stream().filter(schedule -> schedule.get("wrkDtlId").toString().isEmpty()).forEach(schedule -> schedule.put("wrkDtlId", TsidCreator.getTsid().toString()));
		if (schedules.isEmpty()) {
			throw new HrException("임시저장할 근무스케줄이 존재하지 않습니다.");
		}
		ParamUtils.mergeParams(paramMap, schedules);

		dao.deleteBatchMode("deleteWorkClassSchDetail", (List) schedules); // 스케줄에 반영되지 않은 데이터 삭제
		return dao.updateBatchMode("saveWorkClassSchDetail", schedules);
	}

	/**
	 * 근무스케줄 반영
	 * @param paramMap
	 * @return 반영 건수
	 * @throws Exception
	 */
	public int saveWorkClassSchDetailApply(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;

		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");

		Map<String, Object> convertMap = new HashMap<>();
		convertMap.put("sdate", paramMap.get("sdate"));
		convertMap.put("edate", paramMap.get("edate"));
		convertMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
		convertMap.put("workClassCd", paramMap.get("workClassCd"));
		convertMap.put("searchSabunName", paramMap.get("searchSabunName"));
//		convertMap.put("searchPostYn", "N"); // 전체 반영된 데이터 삭제 후 반영되지 않은 데이터만 TWTM102 에 넣어 TWTM102에 데이터가 조회되지 않아 해당 내용 주석처리.

		dao.deleteBatchMode("deleteWorkClassSchDetailApply", convertMap); // TWTM102 기반영된 데이터 삭제
		dao.deleteBatchMode("deleteOldWorkClassSchDetail", convertMap); // TWTM035 기반영된 데이터 삭제

		// 근무스케줄 상세 리스트
		List<Map<String, Object>> detailList = (List<Map<String, Object>>) dao.getListBatchMode("getWorkClassSchDetailList", convertMap);
		wtmCalcWorkTimeService.setCode(paramMap.get("ssnEnterCd").toString(), true);
		if (!detailList.isEmpty()) {

			// 근무조 스케줄 정보를 바탕으로 근무,휴게시간 계산
			List<WtmWrkSchDTO> wtmWrkSchDTOList = detailList.stream()
					.map(data -> {
						WtmWrkSchDTO wtmWrkSchDTO = new WtmWrkSchDTO();
						wtmWrkSchDTO.setEnterCd((String) data.get("enterCd"));
						wtmWrkSchDTO.setSabun((String) data.get("sabun"));
						wtmWrkSchDTO.setName((String) data.get("name"));
						wtmWrkSchDTO.setYmd((String) data.get("ymd"));
						wtmWrkSchDTO.setPostYn((String) data.get("postYn"));
						wtmWrkSchDTO.setWrkDtlId((String) data.get("wrkDtlId"));
						wtmWrkSchDTO.setWorkClassCd((String) data.get("workClassCd"));
						wtmWrkSchDTO.setWorkSchCd((String) data.get("workSchCd"));
						wtmWrkSchDTO.setWorkTimeF((String) data.get("workTimeF"));
						wtmWrkSchDTO.setWorkTimeT((String) data.get("workTimeT"));
						wtmWrkSchDTO.setBreakTimes((String) data.get("breakTimes"));
						wtmWrkSchDTO.setSystemCdYn((String) data.get("systemCdYn"));
						return wtmWrkSchDTO;
					})
					.collect(Collectors.toList());
			List<WtmWrkDtlDTO> wtmWrkDtlDTOList = wtmCalcWorkTimeService.convertToWtmWrkDtlDTOList(wtmWrkSchDTOList);

			// wtmWrkDtlDTOList를 List<Map<?, ?>> 로 형변환
			List<Map<Object, Object>> workList = wtmWrkDtlDTOList.stream()
					.map(dto -> {
						Map<Object, Object> map = new HashMap<>();
						map.put("ssnEnterCd", dto.getEnterCd());
						map.put("wrkDtlId", dto.getWrkDtlId());
						map.put("ymd", dto.getYmd());
						map.put("sabun", dto.getSabun());
						map.put("workCd", dto.getWorkCd());
						map.put("planSymd", dto.getPlanSymd());
						map.put("planShm", dto.getPlanShm());
						map.put("planEymd", dto.getPlanEymd());
						map.put("planEhm", dto.getPlanEhm());
						map.put("planMm", dto.getPlanMm());
						map.put("ssnSabun", paramMap.get("ssnSabun"));
						return map;
					})
					.collect(Collectors.toList());
			try {
				// 근무시간 한도 체크
				// addWrkList 를 회사코드, 사원별 그룹핑 한다.
				Map<WtmCalcGroupKey, List<WtmWrkDtlDTO>> addWrkListGroup = wtmWrkDtlDTOList.stream()
						.collect(Collectors.groupingBy(dto ->
								new WtmCalcGroupKey(dto.getEnterCd(), dto.getSabun())
						));

				// 근무한도체크를 위한 파라미터 설정
				List<Map<String, Object>> paramList = new ArrayList<>();
				addWrkListGroup.forEach((key, items) -> {
//					LocalDate sdate = LocalDate.parse(convertMap.get("sdate").toString(), dateFormatter);
//					LocalDate edate = LocalDate.parse(convertMap.get("edate").toString(), dateFormatter);

					Map<String, Object> checkLimitParam = new HashMap<>();
					checkLimitParam.put("enterCd", key.getEnterCd());
					checkLimitParam.put("sabun", key.getSabun());
					checkLimitParam.put("sdate", paramMap.get("sdate").toString());
					checkLimitParam.put("edate", paramMap.get("edate").toString());
					checkLimitParam.put("addWrkList", items);
					checkLimitParam.put("excWrkList", null);
					checkLimitParam.put("addGntList", null);
					checkLimitParam.put("excGntList", null);

					paramList.add(checkLimitParam);
				});

				boolean hoursLimitYn = wtmCalcWorkTimeService.checkWorkTimeLimit(paramList, true); // 근무시간 한도 체크
				if(hoursLimitYn) {
					cnt += dao.updateBatchMode("saveWorkClassSchDetailApply", workList);
					dao.updateBatchMode("updateWorkClassSchDetailPostYn", convertMap);
				}
			} catch (HrException e) {
				throw new HrException(e.getMessage());
			}

		}
		return cnt;
	}

	private static String getSdate(List<?> groupPatternList) {
		Object patternObj = groupPatternList.get(0);
		Map patternMap = (Map) patternObj;
		String sdate = patternMap.get("sdate").toString();
		return sdate;
	}

	/**
	 * 기간내 근무조 패턴 계산
	 * @param startDate 시작일자
	 * @param targetStartDate 대상 시작일
	 * @param targetEndDate 대상종료일
	 * @param patterns 근무조 패턴
	 * @return 기간의 근무조 패턴
	 */
	private List<Map<String, String>> calculatePatternForMonth(LocalDate startDate, LocalDate targetStartDate, LocalDate targetEndDate, List patterns) {
		int patternSize = patterns.size(); // 패턴의 전체 크기

		// 근무조 시작일자부터 대상일자 시작일 까지의 일수 계산
		long daysSinceStart = ChronoUnit.DAYS.between(startDate, targetStartDate);
		int startIndex = (int) (daysSinceStart % patternSize);

		List<Map<String, String>> monthlyPattern = new ArrayList<>();
		int currentIndex = startIndex;
		LocalDate currentDate = targetStartDate;

		// 기간내 모든 날짜에 대해 반복
		while (currentDate.isBefore(targetEndDate) || currentDate.equals(targetEndDate)) {
			Object pattern = patterns.get(currentIndex % patternSize);
			Map patternMap = (Map) pattern;

			Map<String, String> schMap = new HashMap<String, String>();
			schMap.put("wrkDtlId", patternMap.get("wrkDtlId").toString());
			schMap.put("postYn", patternMap.get("postYn").toString());
			schMap.put("workSchCd", patternMap.get("workSchCd").toString());
			schMap.put("color", patternMap.get("color").toString());
			schMap.put("workSchSrtNm", StringUtils.isEmpty(patternMap.get("workSchSrtNm").toString()) ? "휴무" : patternMap.get("workSchSrtNm").toString());
			schMap.put("ymd", currentDate.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
			monthlyPattern.add(schMap);

			currentIndex = (currentIndex + 1) % patternSize;
			currentDate = currentDate.plusDays(1);
		}

		return monthlyPattern;
	}

}