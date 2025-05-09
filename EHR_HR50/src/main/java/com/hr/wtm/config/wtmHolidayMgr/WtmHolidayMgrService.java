package com.hr.wtm.config.wtmHolidayMgr;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.code.CommonCodeService;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;

import com.hr.common.util.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 휴일관리 Service
 *
 * @author bckim
 *
 */
@Service
public class WtmHolidayMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private CommonCodeService commonCodeService;

	/**
	 * 휴일관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getWtmHolidayMgrList(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();

		Map<String, List<WtmHolidayDTO>> groupedData = new HashMap<>();

		List<Map<String, Object>> holidays = (List<Map<String, Object>>) dao.getList("getWtmHolidayMgrList", paramMap);
		holidays.forEach(map -> {
			WtmHolidayDTO holidayDTO1 = WtmHolidayDTO.of(map);

			String solarMonth = holidayDTO1.getMm();
			if (!groupedData.containsKey(solarMonth))
				groupedData.put(solarMonth, new ArrayList<>());

			holidayDTO1.setRpYy("");
			holidayDTO1.setRpMm("");
			holidayDTO1.setRpDd("");

			groupedData.get(solarMonth).add(holidayDTO1);

			// 대체 공휴일 설정
			boolean isSubHoliday = (map.get("rpYy") != null && !"".equals(map.get("rpYy"))
					&& map.get("rpMm") != null && !"".equals(map.get("rpMm"))
					&& map.get("rpDd") != null && !"".equals(map.get("rpDd")));
			if (isSubHoliday) {
				WtmHolidayDTO holidayDTO2 = WtmHolidayDTO.of(map);

				String subMonth = holidayDTO2.getRpMm();
				if (!groupedData.containsKey(subMonth))
					groupedData.put(subMonth, new ArrayList<>());

				groupedData.get(subMonth).add(holidayDTO2);
			}
		});

		// 일자별 sort
		groupedData.keySet().forEach(key -> groupedData.get(key).sort((o1, o2) -> {
			LocalDate o1Date = DateUtil.getLocalDate(o1.getYy() + o1.getMm() + o1.getDd());
			LocalDate o2Date = DateUtil.getLocalDate(o2.getYy() + o2.getMm() + o2.getDd());
			if (o1Date.isAfter(o2Date)) return 1;
			else if (o1Date.isEqual(o2Date)) return 0;
			else return -1;
		}));

		return groupedData;
	}

	/**
	 *  휴일관리 count Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<?> getWtmHolidayMgrCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmHolidayMgrCnt", paramMap);
	}

	/**
	 * 휴일관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmHolidayMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();

		String searchBizPlaceCd = convertMap.get("bizPlace").toString(); // 사업장코드
		List<Map<String, Object>> bizPlaceCds = getBizPlaceCds(searchBizPlaceCd);
		if (bizPlaceCds.isEmpty())
			throw new HrException("저장해야할 사업장 정보가 없습니다.");

		String appDateStr = convertMap.get("searchAppYmd").toString().replaceAll("[-]", ""); // 신청일자
		String appMdStr = getMonth(appDateStr) + getDay(appDateStr); // 신청일자 중 년월
		String appDateYear = getYear(appDateStr); // 신청일자 중 년도
		String repeatEYearStr = appDateYear; // 반복 시 종료년도
		boolean isRepeat = ("Y".equals(convertMap.get("repeatYn")));
		if (isRepeat) {
			repeatEYearStr = convertMap.get("repeatEYear").toString();
		}

		LocalDate repeatEYearDate = DateUtil.getLocalDate(repeatEYearStr + "0101", "yyyyMMdd");
		LocalDate appYearDate = DateUtil.getLocalDate(appDateYear + "0101", "yyyyMMdd");

		if (repeatEYearDate.isBefore(appYearDate))
			throw new HrException("반복 종료년도는 신청일자보다 이전일 수 없습니다.");

		String inputGroupId;
		try {
			inputGroupId = (String) convertMap.get("inputGroupId");
			if (inputGroupId == null || inputGroupId.isEmpty()) {
				inputGroupId = TsidCreator.getTsid().toString();
			}
		} catch(Exception e) {
			inputGroupId = TsidCreator.getTsid().toString();
		}

		// 입력한 정보를 바탕으로 입력한 공휴일을 양력으로 변환
		List<Map<String, Object>> holidays = new ArrayList<>();
		while(!repeatEYearDate.isBefore(appYearDate)) {
			// 매년도마다 양력 캘린더 일자들을 추가한다.

			// 이번 프로세스의 년도
			String year = DateUtil.convertLocalDateToString(appYearDate, "yyyy");

			// 이번 프로세스의 년도 + 일자를 바탕으로 양력일자를 조회
			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("gubun", convertMap.get("gubun"));
			paramMap.put("searchAppYmd", year + appMdStr);
			Map<String, Object> dateInfo = (Map<String, Object>) dao.getMap("getWtmHolidayMgrGeoDate", paramMap);

			String solarYmd = dateInfo.get("sunDate").toString(); // 양력일자

			Map<String, Object> holiday = new HashMap<>(convertMap);
			holiday.put("rpYy", null);
			holiday.put("rpMm", null);
			holiday.put("rpDd", null);

			holiday.put("inputDate", appDateStr);
			holiday.put("inputGroupId", inputGroupId);

			// 설날, 추석처럼 앞 뒤로 하루씩 추가할지 여부
			boolean isAddDays = ("Y".equals(holiday.get("addDaysYn")));
			if (isAddDays) {

				for (int i = -1 ; i <= 1 ; i++) {
					holiday.put("holidayCd", makeHolidayCd(convertMap));

					LocalDate ld = DateUtil.getLocalDate(solarYmd);
					String sunDate = DateUtil.convertLocalDateToString(ld.plusDays(i));

					holiday.put("yy", getYear(sunDate));
					holiday.put("mm", getMonth(sunDate));
					holiday.put("dd", getDay(sunDate));

					for (Map<String, Object> bizPlaceCd : bizPlaceCds) {
						holiday.put("bizPlace", bizPlaceCd.get("code"));

						Map<String, Object> addMap = new HashMap<>(holiday);
						holidays.add(addMap);
					}
				}
			} else {

				holiday.put("holidayCd", makeHolidayCd(convertMap));
				holiday.put("yy", getYear(solarYmd));
				holiday.put("mm", getMonth(solarYmd));
				holiday.put("dd", getDay(solarYmd));

				for (Map<String, Object> bizPlaceCd : bizPlaceCds) {
					holiday.put("bizPlace", bizPlaceCd.get("code"));

					Map<String, Object> addMap = new HashMap<>(holiday);
					holidays.add(addMap);
				}
			}

			// 1년씩 추가
			appYearDate = appYearDate.plusYears(1);
		}


		// 만들어진 양력 캘린더를 바탕으로 대체공휴일을 설정한다.
		List<Map<String, Object>> saveList = new ArrayList<>();
		appYearDate = DateUtil.getLocalDate(appDateYear + "0101", "yyyyMMdd");
		while(!repeatEYearDate.isBefore(appYearDate)) {
			// 매년도마다 기존에 저장된 공휴일 데이터와 추가하는 공휴일 데이터를 병합하여 대체공휴일을 조회한다.

			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
			String year = DateUtil.convertLocalDateToString(appYearDate, "yyyy");
			paramMap.put("searchYear", year);
			List<Map<String, Object>> dbList = (List<Map<String, Object>>) dao.getList("getWtmHolidayMgrList", paramMap);

			// 수정한 데이터와 DB의 데이터를 중복으로 대체공휴일을 지정하면 안되기 때문에
			for (Map<String, Object> bizPlaceCd : bizPlaceCds) {

				// 사용자가 입력한 정보
				List<Map<String, Object>> list1 = holidays.stream()
						.filter(holMap -> bizPlaceCd.get("code").equals(holMap.get("bizPlace")))
						.filter(holMap -> year.equals(holMap.get("yy")))
						.collect(Collectors.toList());

				// DB에서 조회한 정보 중 동일한 사업장이면서 사용자가 수정한 정보는 제외한 데이터
				List<Map<String, Object>> list2 = dbList.stream()
						.filter(dbMap -> ("all".equals(dbMap.get("businessPlaceCd")) || bizPlaceCd.get("code").equals(dbMap.get("businessPlaceCd")))) // 사업장 정보 FILTER
						.filter(dbMap -> list1.stream().noneMatch(tmpMap -> dbMap.get("holidayCd").equals(tmpMap.get("holidayCd")))) // 공휴일 코드가 동일하지 않은 것만 FILTER
						.collect(Collectors.toList());

				List<Map<String, Object>> mergedList = new ArrayList<>(list1);
				mergedList.addAll(list2);

				List<WtmHolidayVO> voList = new ArrayList<>();
				mergedList.forEach(map -> {
					String id = map.get("holidayCd").toString();
					String date = map.get("yy").toString() + map.get("mm").toString() + map.get("dd").toString();
					String name = map.get("holidayNm").toString();
					boolean isLunarEvent = ("2".equals(map.get("gubun")));
					boolean isAddTwoDays = false;
					String subHolidayType = map.get("substituteType").toString();
					String subHolidaySYear = "";
					WtmHolidayVO vo = new WtmHolidayVO(id, date, name, isLunarEvent, isAddTwoDays, subHolidayType, subHolidaySYear);
					vo.setWtmHolidayMap(map);
					voList.add(vo);
				});

				WtmKoreanLegalHoliday klh = new WtmKoreanLegalHoliday(year);
				klh.getSubSolarHolidayList(voList).forEach(wtmHolidayVO -> {
					Map<String, Object> voMap = wtmHolidayVO.getWtmHolidayMap();
					voMap.put("rpYy", wtmHolidayVO.getSubYear());
					voMap.put("rpMm", wtmHolidayVO.getSubMonth());
					voMap.put("rpDd", wtmHolidayVO.getSubDay());
					saveList.add(voMap);
				});
			}

			appYearDate = appYearDate.plusYears(1);
		}

		int cnt = 0;
		if (!saveList.isEmpty()) {
			cnt = dao.create("mergeWtmHolidayMgr", saveList);
		}
		return cnt;

	}

	private String getYear(String ymd) {
		return (ymd != null && !ymd.isEmpty()) ? DateUtil.convertLocalDateToString(DateUtil.getLocalDate(ymd), "yyyy") : "";
	}

	private String getMonth(String ymd) {
		return (ymd != null && !ymd.isEmpty()) ? DateUtil.convertLocalDateToString(DateUtil.getLocalDate(ymd), "MM") : "";
	}

	private String getDay(String ymd) {
		return (ymd != null && !ymd.isEmpty()) ? DateUtil.convertLocalDateToString(DateUtil.getLocalDate(ymd), "dd") : "";
	}

	private List<Map<String, Object>> getBizPlaceCds(String bizPlaceCd) throws Exception {

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("queryId", "getBusinessPlaceCdList");
		boolean isBizPlaceAll = (bizPlaceCd == null || bizPlaceCd.isEmpty() || "all".equals(bizPlaceCd));
		if (!isBizPlaceAll) {
			paramMap.put("searchBusinessPlaceCd", bizPlaceCd);
		}
		return (List<Map<String, Object>>) commonCodeService.getCommonNSCodeList(paramMap);
	}

	private String makeHolidayCd(Map<String, Object> convertMap) throws Exception {
		if (convertMap.containsKey("holidayCd")
				&& convertMap.get("holidayCd") != null
				&& !convertMap.get("holidayCd").equals("")) {

			deleteWtmHolidayMgr(convertMap);

			return convertMap.get("holidayCd").toString();
		}

		LocalDateTime now = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
		String uuid = UUID.randomUUID().toString();

		 return now.format(formatter) + uuid.substring(0, 8);
	}

	/**
	 * 휴일관리 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWtmHolidayMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		//deleteType 으로 구분 (single / following / all)
		return dao.delete("deleteWtmHolidayMgr", convertMap);
	}

	public List<?> getWtmHolidayMgrById(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmHolidayMgrById", paramMap);
	}

	/**
	 * 한국 공휴일 생성 Service
	 *
	 * @param paramMap 파라미터 Map
	 * @return int
	 * @throws Exception
	 */
	public int excWtmHolidayMgrKoreanHolidays(Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		// 우선 해당년도 사업장의 휴일 정보 일괄 삭제
		dao.delete("deleteWtmHolidayMgrAll", paramMap);

		// 데이터 생성
		String ssnEnterCd = (String) paramMap.get("ssnEnterCd");
		String ssnSabun = (String) paramMap.get("ssnSabun");
		String searchBizPlaceCd = (String) paramMap.get("searchBizPlaceCd");
		List<Map<String, Object>> bizPlaceCds = getBizPlaceCds(searchBizPlaceCd);

		String year = (String) paramMap.get("searchYear");
		List<Map<String, Object>> holidays = new ArrayList<>();

		WtmKoreanLegalHoliday koreanLegalHoliday = new WtmKoreanLegalHoliday(year);
		List<WtmHolidayVO> list = koreanLegalHoliday.getAllKoreanHolidaySolarCalendar(); // 한국 공휴일 생성

		list.forEach(wtmHolidayVO -> {
			try {
				String holidayCd = makeHolidayCd(new HashMap<>());
				String inputGroupId = TsidCreator.getTsid().toString();

				for (Map<String, Object> mp : bizPlaceCds) {
					// 사업장 별로 loop
					String businessPlaceCd = (String) mp.get("code");
					Map<String, Object> map = getMapFromWtmHolidayVo(wtmHolidayVO, ssnEnterCd, businessPlaceCd, holidayCd, ssnSabun, inputGroupId);
					holidays.add(map);
				}
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		});

		Log.DebugEnd();
		return dao.create("insertWtmHolidayMgr", holidays);
	}

	private Map<String, Object> getMapFromWtmHolidayVo(WtmHolidayVO wtmHolidayVO, String ssnEnterCd, String businessPlaceCd, String holidayCd, String ssnSabun, String inputGroupId) {
		Map<String, Object> map = new HashMap<>();

		map.put("ssnEnterCd", ssnEnterCd);
		map.put("yy", wtmHolidayVO.getYear());
		map.put("bizPlace", businessPlaceCd);
		map.put("holidayCd", holidayCd);
		map.put("holidayNm", wtmHolidayVO.getName());
		map.put("mm", wtmHolidayVO.getMonth());
		map.put("dd", wtmHolidayVO.getDay());
		map.put("gubun", (wtmHolidayVO.isLunarEvent()) ? "2" : "1");
		map.put("rpYy", wtmHolidayVO.getSubYear());
		map.put("rpMm", wtmHolidayVO.getSubMonth());
		map.put("rpDd", wtmHolidayVO.getSubDay());
		map.put("substituteType", wtmHolidayVO.getSubHolidayType());
		map.put("ssnSabun", ssnSabun);
		map.put("inputDate", wtmHolidayVO.getInputDate());
		map.put("addDaysYn", wtmHolidayVO.isAddTwoDays() ? "Y" : "N");
		map.put("inputGroupId", inputGroupId);

		return map;
	}

	/**
	 * 공휴일관리 삭제 시 타입 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> getWtmHolidayDeleteLayerDeleteType(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return (Map<String, Object>) dao.getMap("getWtmHolidayDeleteLayerDeleteType", paramMap);
	}

	/**
	 * 등록 가능 최대 일자 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<String, Object> getWtmHolidayMgrMaxDate(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return (Map<String, Object>) dao.getMap("getWtmHolidayMgrMaxDate", paramMap);
	}

}