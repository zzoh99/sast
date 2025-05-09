package com.hr.wtm.workMgr.wtmPsnlWorkScheduleMgr;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.wtm.workMgr.wtmShiftSchMgr.WtmShiftSchMgrService;
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
 * 개인근무스케줄관리 Service
 *
 * @author JSG
 *
 
 */

@Service("WtmPsnlWorkScheduleMgrService")
public class WtmPsnlWorkScheduleMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmShiftSchMgrService wtmShiftSchMgrService;
	/**
	 * 개인근무스케줄관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmPsnlWorkScheduleMgrList(Map<String, Object>  paramMap) throws Exception {
		Log.Debug();

//		List<Map<String, Object>> titles = (List<Map<String, Object>>)dao.getList("getWtmPsnlWorkScheduleMgrHeaderList", paramMap);
//		paramMap.put("titles", titles);
		List<Map<String, Object>> list = (List<Map<String, Object>>) dao.getList("getWtmPsnlWorkScheduleMgrList", paramMap);

		// 근무스케줄 상세 리스트
		List<Map<String, Object>> detailList = (List<Map<String, Object>>) dao.getList("getWtmPsnlWorkScheduleMgrDetailList", paramMap);

		paramMap.put("workClassCd", paramMap.get("searchWorkClassCd"));
		if (!list.isEmpty() && !detailList.isEmpty()) {
			Set<String> checkedWorkGroupDetail = new HashSet<>();
			List<?> groupPatternList = new ArrayList<>();
			for (Object emp : list) {
				paramMap.put("workSabun", "");
				if (emp instanceof Map) {
					Map<String, Object> empMap = (Map<String, Object>) emp;
					String workGroupCd = (String) empMap.get("workGroupCd");
					String workSabun = (String) empMap.get("sabun");
					Log.Debug(workSabun);

					paramMap.put("workSabun", workSabun);
					paramMap.put("workGroupCd", workGroupCd);

					// 불필요한 쿼리 중복 조회을 방지하기 위해 workGroupCd 별로 한 번만 수행하도록 함.
					if (checkedWorkGroupDetail.add(workGroupCd)) {
						groupPatternList = (List<?>) dao.getList("getWorkGroupPatternList", paramMap);
					}
					Log.Debug(groupPatternList.toString());

					// 직원벌 설정된 스케줄 정보
					List<Map<String, Object>> details =
							detailList.stream()
									.filter(map -> workSabun.equals(map.get("sabun")))
									.collect(Collectors.toList());


					if (!details.isEmpty()) {
						Log.Debug(details.toString());
						Log.Debug(empMap.toString());
						Log.Debug(paramMap.toString());
						Map<String, Object> patternParam = new HashMap<>(paramMap);
						String psnlSdate = empMap.get("sdate").toString();
						String psnlEdate = empMap.get("edate").toString();
						String sdate = paramMap.get("saveSymd").toString();
						String edate = paramMap.get("saveEymd").toString();

						patternParam.put("sdate", psnlSdate.compareTo(sdate) > 0 ? psnlSdate : sdate);
						patternParam.put("edate",  psnlEdate.compareTo(edate) < 0 ? psnlEdate : edate);
						Log.Debug(patternParam.toString());
						Map<String, Object> scheduleList = getWorkClassSchDetail(patternParam, groupPatternList, details);
//						empMap.put("schedule", schedule.get("schedule"));
//                     , 'sn' || T.SUN_DATE AS SAVE_NAME
//                     , 'color' || T.SUN_DATE AS COLOR_SAVE_NAME
//                     , T.SUN_DATE
//								, 'sn' || T.SUN_DATE || '#_BACK_COLOR' AS BGCOLOR
						for(Map<String, Object> schedule : (List<Map<String, Object>>) scheduleList.get("schedule")){
							Log.Debug(schedule.toString());
							empMap.put("sn" + schedule.get("ymd"), schedule.get("workSchCd"));
//							empMap.put("sn" + schedule.get("ymd") + "#_BACK_COLOR", schedule.get("color"));
						}
					}
				}
			}
		}

		return list;
	}

	/**
	 * 개인근무스케줄관리 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmPsnlWorkScheduleMgrHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmPsnlWorkScheduleMgrHeaderList", paramMap);
	}

	/**
	 * 개인근무스케줄관리- 일일근무시간(sheet2) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmPsnlWorkScheduleMgrDayWorkList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		//개인근무스케줄관리 - 일일근무시간(sheet2) 헤더 다건 조회 
		List<Map<String, Object>> titles = (List<Map<String, Object>>)dao.getList("getWtmPsnlWorkScheduleMgrDayWorkHeaderList", paramMap);
		paramMap.put("titles", titles);

		
		return (List<?>) dao.getList("getWtmPsnlWorkScheduleMgrDayWorkList", paramMap);
	}

	/**
	 * 개인근무스케줄관리 - 일일근무시간(sheet2) 헤더 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmPsnlWorkScheduleMgrDayWorkHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmPsnlWorkScheduleMgrDayWorkHeaderList", paramMap);
	}

	/**
	 * 개인근무스케줄관리 체크
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int getWtmPsnlWorkScheduleMgrCheck(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		Map<?, ?> result = (Map<?, ?>) dao.getOne("getWtmPsnlWorkScheduleMgrCheck", convertMap);
		int cnt = Integer.parseInt(result.get("cnt").toString());

		return cnt;
	}

	/**
	 * 개인근무스케줄관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmPsnlWorkScheduleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWtmPsnlWorkScheduleMgr", convertMap);
		}
		Log.Debug("===== saveWtmPsnlWorkScheduleMgr =====");
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			for(Map<String, Object> mergeRow : ((List<Map<String, Object>>)convertMap.get("mergeRows"))){
				mergeRow.put("wrkDtlId", TsidCreator.getTsid().toString());
			}
			Log.Debug(convertMap.toString());
			cnt += dao.update("saveWtmPsnlWorkScheduleMgr", convertMap);

		}

		return cnt;
	}

		
	public Map<?, ?> getWtmPsnlWorkExtendCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getWtmPsnlWorkExtendCheck", paramMap);
	}	
	
	/**
	 * 개인근무스케줄관리 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWtmPsnlWorkScheduleMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteWtmPsnlWorkScheduleMgr", paramMap);
	}

	/**
	 * callP_TIM_WORK_HOUR_CHG 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_TIM_WORK_HOUR_CHG(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("callP_TIM_WORK_HOUR_CHG", paramMap);
	}

	/**
	 * callP_TIM_MTN_SCHEDULE_CREATE 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_TIM_MTN_SCHEDULE_CREATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("callP_TIM_MTN_SCHEDULE_CREATE", paramMap);
	}
	
	/**
	 * psnlWorkScheduleMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmPsnlWorkScheduleMgrMemo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmPsnlWorkScheduleMgrMemo", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * psnlWorkScheduleMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWtmPsnlWorkScheduleMgrEndYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWtmPsnlWorkScheduleMgrEndYn", paramMap);
		Log.Debug();
		return resultMap;
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

}