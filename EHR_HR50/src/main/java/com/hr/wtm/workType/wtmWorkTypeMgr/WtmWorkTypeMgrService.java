package com.hr.wtm.workType.wtmWorkTypeMgr;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.wtm.calc.dto.WtmWrkDtlDTO;
import com.hr.wtm.calc.dto.WtmWrkSchDTO;
import com.hr.wtm.calc.key.WtmCalcGroupKey;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 근무유형관리 Service
 *
 * @author OJS
 *
 */
@Service("WorkTypeMgrService")
public class WtmWorkTypeMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	/**
	 * 근무유형관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmWorkClassMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkClassMgrList", paramMap);
	}

	public List<?> getWtmWorkClassCdList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmWorkClassCdList", paramMap);
	}

	public Map<String, Object> saveWtmWorkClassMgr(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		String workClassCd = makeNewClassCd(paramMap);
		paramMap.put("workClassCd", workClassCd);

		int resultCnt = dao.update("saveWtmWorkClassMgr", paramMap);

		// 교대근무인경우, TWTM031 시스템 코드 추가(휴무(A)/주휴일(B))
		if(paramMap.get("workTypeCd").equals("D")) {
			dao.update("saveWtmWorkClassDefaultSchCd", paramMap);
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("workClassCd", workClassCd);

		return resultMap;
	}

	public int saveWtmWorkClassUseYn(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return dao.update("saveWtmWorkClassUseYn", paramMap);
	}

	public int deleteWtmWorkClassMgr(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		cnt += dao.delete("deleteWtmWorkClassMgr", paramMap);
		cnt += dao.delete("deleteWtmWorkClassEmp", paramMap);
		cnt += dao.delete("deleteAllWtmWorkSchedule", paramMap);
		cnt += dao.delete("deleteWtmWorkGroupPatterns", paramMap);
		return cnt;
	}

	private String makeNewClassCd(Map<String, Object> paramMap) throws Exception {
		if (paramMap.containsKey("workClassCd")
				&& paramMap.get("workClassCd") != null
				&& !paramMap.get("workClassCd").equals("")) {
			return paramMap.get("workClassCd").toString();
		}

		Map<?, ?> maxClassCdMap = dao.getMap("getMaxWorkClassCd", paramMap);
		String workTypeCd = paramMap.get("workTypeCd").toString();

		int newNum = 1;
		if (maxClassCdMap != null && maxClassCdMap.containsKey("workClassCd")) {
			String lastCode = maxClassCdMap.get("workClassCd").toString();
			String numberPart = lastCode.substring(1);
			newNum = Integer.parseInt(numberPart) + 1;
		}

		return workTypeCd + String.format("%04d", newNum);
	}

	public int saveWorkClassDefYn(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;

		cnt += dao.update("saveWorkClassDefN", paramMap);
		cnt += dao.update("saveWorkClassDefY", paramMap);

		return cnt;
	}

	public List<?> getWorkClassEmpList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkClassEmpList", paramMap);
	}

	public List<?> getWorkScheduleList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkScheduleList", paramMap);
	}

	public List<?> getWorkGroupList(Map<String, Object> paramMap) throws Exception {
		List<?> groupList = (List<?>) dao.getList("getWorkGroupList", paramMap);

		for (Object obj : groupList) {
			Map<String, Object> group = (Map<String, Object>) obj;
			List<?> groupPatternList = (List<?>) dao.getList("getWorkGroupPatternList", group);
			group.put("patterns", groupPatternList);

			List<?> groupEmpList = (List<?>) dao.getList("getWorkGroupEmpList", group);
			group.put("emp", groupEmpList);
		}

		return groupList;
	}

	public int saveWtmWorkSchedule(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		if (!paramMap.containsKey("workSchCd") || paramMap.get("workSchCd") == null || paramMap.get("workSchCd").equals("")) {
			paramMap.put("workSchCd", makeWorkSchCd(paramMap));
		}

		return dao.update("saveWtmWorkSchedule", paramMap);
	}

	public int saveWtmWorkGroup(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;

		if (!paramMap.containsKey("workGroupCd") || paramMap.get("workGroupCd") == null || paramMap.get("workGroupCd").equals("")) {
			paramMap.put("workGroupCd", makeWorkGroupCd(paramMap));
		}

		cnt += dao.update("saveWtmWorkGroup", paramMap);
		cnt += dao.delete("deleteWtmWorkGroupPatterns", paramMap);
		if (paramMap.containsKey("patterns") && paramMap.get("patterns") != null && !"".equals(paramMap.get("patterns"))) {
			List<String> patterns = Arrays.asList(paramMap.get("patterns").toString().split(","));
			paramMap.put("patterns", patterns);

			cnt += dao.update("saveWtmWorkGroupPatterns", paramMap);
		}

		return cnt;
	}

	private String makeWorkSchCd(Map<String, Object> paramMap) throws Exception {
		Map<?, ?> workGroupCd = dao.getMap("getWtmWorkSchCd", paramMap);
		return workGroupCd.get("workSchCd").toString();
	}

	private String makeWorkGroupCd(Map<String, Object> paramMap) throws Exception {
		Map<?, ?> workGroupCd = dao.getMap("getWtmWorkGroupCd", paramMap);
		return workGroupCd.get("workGroupCd").toString();
	}

	public int deleteWtmWorkSchedule(Map<String, Object> paramMap) throws Exception {
		int cnt = 0;
		cnt += dao.delete("deleteWtmWorkSchedule", paramMap);
		cnt += dao.delete("deleteWtmWorkGroupPatterns", paramMap);
		return cnt;
	}

	public int deleteWtmWorkGroup(Map<String, Object> paramMap) throws Exception {
		int cnt = 0;
		cnt += dao.delete("deleteWtmWorkGroup", paramMap);
		cnt += dao.delete("deleteWtmWorkGroupPatterns", paramMap);
		cnt += dao.delete("deleteWtmWorkGroupEmp", paramMap);
		return cnt;
	}

	public List<?> getWtmWorkClassUnassignedEmpList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmWorkClassUnassignedEmpList", paramMap);
	}

	public List<?> getWtmWorkTargetList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmWorkTargetList", paramMap);
	}

	public List<?> getWtmWorkGroupTargetList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmWorkGroupTargetList", paramMap);
	}

	public List<?> getWtmWorkTargetOrgList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmWorkTargetOrgList", paramMap);
	}

	public int saveWtmWorkClassTarget(Map<String, Object> paramMap) throws Exception {
		int cnt = 0;

		List<WtmWorkClassTarget> targets = (List<WtmWorkClassTarget>) paramMap.get("targets");
		for (WtmWorkClassTarget target : targets) {
			if (target.getOldClassCd() != null && !target.getOldClassCd().isEmpty()) {
				Map<String, Object> targetMap = new HashMap<>();
				targetMap.put("target", target);
				targetMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
				targetMap.put("ssnSabun", paramMap.get("ssnSabun"));
				cnt += dao.update("updateOldClassEdate", targetMap);
			}
		}
		cnt += dao.delete("deleteWtmWorkTarget", paramMap);

		if (!targets.isEmpty()) {
			cnt += dao.update("saveWtmWorkTarget", paramMap);
		}
		return cnt;
	}

	public List<?> getWtmWorkShiftTargetList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmWorkShiftTargetList", paramMap);
	}

	public List<?> getWorkGroupEmpList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWorkGroupEmpList", paramMap);
	}

	public int saveWtmWorkClassShiftTarget(Map<String, Object> paramMap) throws Exception {
		int cnt = 0;
		List<WtmWorkClassShiftTarget> targets = (List<WtmWorkClassShiftTarget>) paramMap.get("targets");
		//근무유형대상자관리 업데이트
		// TODO: 교대근무대상자 저장 시 근무유형의 대상자가 모두 삭제되는 오류가 발견되어 해당 내용 주석처리함. 필요 없는 내용이면 추후 삭제 필요. kwook
//		cnt += dao.delete("deleteWtmPsnlWorkTarget", paramMap);
//		if (!targets.isEmpty()) {
//			cnt += dao.update("saveWtmPsnlWorkTarget", paramMap);
//		}
		//근무조원(조직)관리 업데이트
		cnt += dao.delete("deleteWtmWorkClassShiftTarget", paramMap);
		if (!targets.isEmpty()) {
			cnt += dao.update("saveWtmWorkClassShiftTarget", paramMap);
		}
		//날짜 연속성 업데이트
		for (WtmWorkClassShiftTarget target : targets) {
			Map<String, Object> params = new HashMap<>();
			params.put("searchSabun", target.getTargetCd());
			params.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			updateContDate(params);
		}
		return cnt;
	}

	public List<?> getWtmWorkClassApplCdList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmWorkClassApplCdList", paramMap);
	}

	public Map<String, Object> saveWtmWorkClassApplCd(Map<String, Object> paramMap) throws Exception {
		Map resMap = new HashMap<String, Object>();;
		int cnt = 0;
		String applCd = makeNewApplCd(paramMap);
		paramMap.put("applCd", applCd);
		cnt += dao.update("saveWtmWorkClassApplCd", paramMap);
		resMap.put("cnt", cnt);
		resMap.put("applCd", applCd);
		return resMap;
	}

	private String makeNewApplCd(Map<String, Object> paramMap) throws Exception {
		if (paramMap.containsKey("applCd")
				&& paramMap.get("applCd") != null
				&& !paramMap.get("applCd").equals("")) {
			return paramMap.get("applCd").toString();
		}

		Map<?, ?> maxApplCdMap = dao.getMap("getMaxWtmAppCode", paramMap);

		int newNum = 1;
		if (maxApplCdMap != null && maxApplCdMap.containsKey("applCd")) {
			String lastCode = maxApplCdMap.get("applCd").toString();
			String numberPart = lastCode.substring(4);
			newNum = Integer.parseInt(numberPart) + 1;
		}

		return "wtm1" + String.format("%02d", newNum);
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


					Map<String, Object> patternParam = new HashMap<>(paramMap);
					String psnlSdate = empMap.get("sdate").toString();
					String psnlEdate = empMap.get("edate").toString();
					String sdate = paramMap.get("sdate").toString();
					String edate = paramMap.get("edate").toString();

					patternParam.put("sdate", psnlSdate.compareTo(sdate) > 0 ? psnlSdate : sdate);
					patternParam.put("edate",  psnlEdate.compareTo(edate) < 0 ? psnlEdate : edate);
					Map<String, Object> schedule = getWorkClassSchDetail(patternParam, groupPatternList, details);
					empMap.put("schedule", schedule.get("schedule"));

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
		ParamUtils.mergeParams(paramMap, schedules);

		dao.deleteBatchMode("deleteWorkClassSchDetail", convertMap); // 스케줄에 반영되지 않은 데이터 삭제
		return dao.updateBatchMode("saveWorkClassSchDetail", (List<Map<Object, Object>>)paramMap.get("schedules"));
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
		convertMap.put("searchPostYn", "N");

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

	public void updateContDate(Map<String, Object> paramMap) throws Exception {
		//개인 유형 리스트 조회
		List<Map<String, Object>> typeList = (List<Map<String, Object>>) dao.getList("getWtmPsnlWorkList", paramMap);
		//날짜 연속성 업데이트
		for(Map<String,Object> type : typeList) {
			type.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			type.put("ssnSabun", paramMap.get("ssnSabun"));
			dao.update("updatePsnlContEdate", type);
			dao.update("updateShiftContEdate", type);
		}
	}

}