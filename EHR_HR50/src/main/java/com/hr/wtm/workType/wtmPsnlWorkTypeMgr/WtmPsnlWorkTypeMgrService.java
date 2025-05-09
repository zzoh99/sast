package com.hr.wtm.workType.wtmPsnlWorkTypeMgr;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.wtm.calc.workTime.WtmCalcWorkTimeService;
import com.hr.wtm.count.wtmDailyCount.WtmDailyCountService;
import com.hr.wtm.workType.wtmWorkTypeMgr.WtmWorkClassTarget;
import org.apache.commons.text.StringEscapeUtils;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import yjungsan.util.StringUtil;

import javax.inject.Inject;
import javax.inject.Named;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 개인근무유형관리 Service
 *
 * @author OJS
 *
 */
@Service("WtmPsnlWorkTypeMgrService")
public class WtmPsnlWorkTypeMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private WtmCalcWorkTimeService wtmCalcWorkTimeService;

	@Autowired
	private WtmDailyCountService wtmDailyCountService;

	public Map<?,?> getWtmPsnlWorkTypeMgrWorkClassList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		Map<String, Object> result = new HashMap();
		result.put("totInfo", dao.getMap("getWtmPsnlWorkTypeMgrTotWorkClassInfo", paramMap));

		List<Map<String, Object>> workClassList = (List<Map<String, Object>>) dao.getList("getWtmPsnlWorkTypeMgrWorkClassList", paramMap);
		List<Map<String, Object>> workClassEmpList = (List<Map<String, Object>>) dao.getList("getWtmPsnlWorkTypeMgrWorkClassEmpList", paramMap);

		// 근무유형 정보에 대표 인원 목록 추가
		for (Map<String, Object> workClass : workClassList) {
			String classCd = (String) workClass.get("workClassCd");
			List<Map<String, Object>> empList = new ArrayList<>();

			for (Map<String, Object> emp : workClassEmpList) {
				if (classCd.equals(emp.get("workClassCd"))) {
					empList.add(emp);
				}
			}
			workClass.put("empList", empList);
		}

		result.put("workClassList", workClassList);

		return result;
	}

	/**
	 * 개인별 근무유형 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWtmPsnlWorkTypeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<Map<String, Object>> list = (List<Map<String, Object>>) dao.getList("getWtmPsnlWorkTypeMgrList", paramMap);
//		List<Map<String, Object>> result = new ArrayList<>();
//
//		// 사번별로 항목들을 그룹화
//		if (!datas.isEmpty()) {
//			Set<String> chkPsnlData = new HashSet<>();
//			for (Object data : datas) {
//				if (data instanceof Map) {
//					Map<String, Object> map = (Map<String, Object>) data;
//
//					String sabun = (String) map.get("sabun");
//
//					if (chkPsnlData.add(sabun)) {
//						// 중복 사번이 없는 경우 신규 입력
//						List<Map<String, Object>> workType = new ArrayList<>();
//						Map<String, Object> workTypeMap = new HashMap<>();
//						workTypeMap.put("workClassCd", (String) map.get("workClassCd"));
//						workTypeMap.put("workClassNm", (String) map.get("workClassNm"));
//						workTypeMap.put("workGroupCd", (String) map.get("workGroupCd"));
//						workTypeMap.put("workGroupNm", (String) map.get("workGroupNm"));
//						workTypeMap.put("sdate", (String) map.get("sdate"));
//						workTypeMap.put("edate", (String) map.get("edate"));
//						workType.add(workTypeMap);
//
//						map.put("workType", workType);
//
//						result.add(map);
//					} else {
//						// 중복 사번이 있는 경우
//						// result 에서 해당 사번의 정보를 가져온다.
//						Map<String, Object> psnlDataMap = result.stream()
//								.filter(item -> sabun.equals(item.get("sabun")))
//								.findFirst()
//								.orElse(null);
//
//						// 기존 정보에 append 한다.
//						List<Map<String, Object>> workType = (List<Map<String, Object>>) psnlDataMap.get("workType");
//						Map<String, Object> workTypeMap = new HashMap<>();
//						workTypeMap.put("workClassCd", (String) map.get("workClassCd"));
//						workTypeMap.put("workClassNm", (String) map.get("workClassNm"));
//						workTypeMap.put("workGroupCd", (String) map.get("workGroupCd"));
//						workTypeMap.put("workGroupNm", (String) map.get("workGroupNm"));
//						workTypeMap.put("sdate", (String) map.get("sdate"));
//						workTypeMap.put("edate", (String) map.get("edate"));
//						workType.add(workTypeMap);
//						psnlDataMap.put("workType", workType);
//					}
//				}
//			}
//		}
		return list;
	}

	/**
	 * 개인별 근무유형 리스트 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getWtmPsnlWorkTypeMgrDet(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> result = new HashMap<>();
		Log.Debug(paramMap.get("searchWorkClassCd").toString());
		Log.Debug(paramMap.get("baseWorkClassCd").toString());
		Log.Debug(":" + paramMap.get("searchWorkClassCd").equals(paramMap.get("baseWorkClassCd")) + ":");
		if(paramMap.get("searchWorkClassCd").equals(paramMap.get("baseWorkClassCd"))){
			result = (Map<String, Object>) dao.getMap("getWtmPsnlWorkTypeMgrDetBase", paramMap);
		}else{
			result = (Map<String, Object>) dao.getMap("getWtmPsnlWorkTypeMgrDet", paramMap);
		}

		return result;
	}

	public List<?> getWtmPsnlWorkClassCdList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmPsnlWorkClassCdList", paramMap);
	}

	public List<?> getWtmPsnlWorkGroupCdList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWtmPsnlWorkGroupCdList", paramMap);
	}

	public List<?> getWtmPsnlWorkTargetList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmPsnlWorkTargetList", paramMap);
	}

	public List<?> getWtmPsnlWorkTargetOrgList(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmPsnlWorkTargetOrgList", paramMap);
	}

	public Map<String, Object> saveWtmPsnlWorkTypeMgr(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int resultCnt = 0;

		// 기존 데이터 삭제
		dao.delete("deleteWtmPsnlOldClass", paramMap);
		dao.delete("deleteWtmPsnlOldGroup", paramMap);

		List<WtmWorkClassPeriod> newWorkClassList = new ArrayList<>();
		List<WtmWorkClassPeriod> delWorkClassList = new ArrayList<>();
		List<WtmWorkGroupPeriod> newWorkGroupList = new ArrayList<>();
		List<WtmWorkGroupPeriod> delWorkGroupList = new ArrayList<>();

		// 신규로 추가하려는 기간과 기존의 근무유형 기간이 겹칠 수 가 있기 때문에 해당 기간에 겹치는 데이터는 삭제 후 다시 생성하기로 한다.
		setWorkClassAndGroupList(paramMap, newWorkClassList, delWorkClassList, newWorkGroupList, delWorkGroupList);

		if (!delWorkGroupList.isEmpty()) {
			paramMap.put("deleteRows", delWorkGroupList);
			resultCnt += dao.delete("deleteWtmPsnlWorkGroups", paramMap);
			// 기 저장되어 반영된 스케줄도 삭제 필요.
			dao.delete("updateWtmPsnlShiftWorkSchedule1", paramMap); // 실제 인정근무 null 로 업데이트
			dao.delete("deleteWtmPsnlShiftWorkSchedule2", paramMap); // 임시저장 및 반영된 교대조근무스케줄 삭제
		}

		if (!delWorkClassList.isEmpty()) {
			paramMap.put("deleteRows", delWorkClassList);
			resultCnt += dao.delete("deleteWtmPsnlWorkClasses", paramMap);
		}

		if (!newWorkClassList.isEmpty()) {
			paramMap.put("mergeRows", newWorkClassList);
			resultCnt += dao.update("saveWtmPsnlWorkClasses", paramMap);
		}

		if (!newWorkGroupList.isEmpty()) {
			paramMap.put("mergeRows", newWorkGroupList);
			resultCnt += dao.update("saveWtmPsnlWorkGroups", paramMap);
		}

		// 일근무집계 다시 수행
		if (!delWorkClassList.isEmpty()) {
			for (WtmWorkClassPeriod delWorkClass : delWorkClassList) {
				// 종료일자가 29991231 일 경우 일근무집계 수행에 너무 많은 시간이 소요되어 현재 저장되어 있는 근무 집계 데이터 바탕으로 재집계 수행
				Map<String, Object> tmpMap = new HashMap<>();
				tmpMap.put("enterCd", delWorkClass.getEnterCd());
				tmpMap.put("sabun", delWorkClass.getSabun());
				tmpMap.put("sdate", delWorkClass.getSdate());
				tmpMap.put("edate", delWorkClass.getEdate());
				Map<String, Object> maxYmd = (Map<String, Object>) dao.getMap("getWtmPsnlWorkClassMaxYmd", tmpMap);
				String edate = StringUtil.stringValueOf(maxYmd.get("maxYmd"));
				delWorkClass.setEdate(edate);
				postSave(delWorkClass.getEnterCd(), delWorkClass.getSabun(), delWorkClass.getSdate(), delWorkClass.getEdate());
			}
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);

		return resultMap;
	}

	private void postSave(String enterCd, String sabun, String sdate, String edate) throws Exception {
		wtmCalcWorkTimeService.setCode(enterCd, false);

		/* 일마감 처리 */
		Map<String, Object> countParam = new HashMap<>();
		countParam.put("ssnEnterCd", enterCd);
		countParam.put("enterCd", enterCd);
		countParam.put("sabun", sabun);
		countParam.put("sdate", sdate);
		countParam.put("edate", edate);
		countParam.put("useBatchMode", "N");
		int countCnt = wtmDailyCountService.prcWtmDailyCount(countParam);
		if (countCnt < 0) {
			throw new HrException("일근무 마감 작업에 실패했습니다.");
		}
	}

	/**
	 * 근무유형 변경에 따른 신규 추가해야할 근무유형/근무조 데이터와 삭제해야할 근무유형/근무조 데이터를 조회
	 *
	 * @param paramMap
	 * @param newWorkClassList 신규 추가해야할 근무유형 데이터
	 * @param delWorkClassList 삭제해야할 근무유형 데이터
	 * @param newWorkGroupList 신규 추가해야할 근무조 데이터
	 * @param delWorkGroupList 삭제해야할 근무조 데이터
	 * @throws Exception
	 */
	public void setWorkClassAndGroupList(Map<String, Object> paramMap
			, List<WtmWorkClassPeriod> newWorkClassList
			, List<WtmWorkClassPeriod> delWorkClassList
			, List<WtmWorkGroupPeriod> newWorkGroupList
			, List<WtmWorkGroupPeriod> delWorkGroupList) throws Exception {

		// 신규로 추가하려는 기간과 기존의 근무유형 기간이 겹칠 수 가 있기 때문에 해당 기간에 겹치는 데이터는 삭제 후 다시 생성하기로 한다.
		List<Map<String, Object>> workClassPeriodList = (List<Map<String, Object>>) dao.getList("getWtmPsnlWorkClassPeriodList", paramMap);
		for (Map<String, Object> workClassPeriod : workClassPeriodList) {
			if ("Y".equals(workClassPeriod.get("shiftWorkYn"))) {
				Map<String, Object> tmpMap = new HashMap<>(paramMap);
				tmpMap.put("workClassCd", workClassPeriod.get("workClassCd"));
				List<Map<String, Object>> workGroupPeriodList = (List<Map<String, Object>>) dao.getList("getWtmPsnlWorkGroupPeriodList", tmpMap);
				workClassPeriod.put("workGroupPeriodList", workGroupPeriodList);
			}
		}

		String edateStr;
		boolean isUntilNextWork = "Y".equals(paramMap.get("untilNextWorkYn")); // 직후 근무유형 전까지 종료일을 설정하는 옵션.
		if (isUntilNextWork) {
			// 직후 근무유형의 시작일자로 해당 근무유형의 종료일을 조회한다.
			Map<String, Object> getNextSdate = (Map<String, Object>) dao.getMap("getWtmPsnlWorkNextClassSdate", paramMap);
			edateStr = (getNextSdate == null || getNextSdate.get("sdate") == null || "".equals(getNextSdate.get("sdate"))) ? "99991231" : DateUtil.convertLocalDateToString(DateUtil.getLocalDate(StringUtil.stringValueOf(getNextSdate.get("sdate"))).minusDays(1));
		} else {
			edateStr = "".equals(StringUtil.stringValueOf(paramMap.get("edate"))) ? "99991231" : StringUtil.stringValueOf(paramMap.get("edate")).replaceAll("[-]", "");
		}

		// 현재 수정하고자 하는 근무유형의 시작일자, 종료일자
		LocalDate sdate = DateUtil.getLocalDate(StringUtil.stringValueOf(paramMap.get("sdate")).replaceAll("[-]", ""));
		LocalDate edate = DateUtil.getLocalDate(edateStr);

		// 추가하려는 기간과 겹치는 데이터가 있는지 확인
		List<WtmWorkClassPeriod> duplicatedList = workClassPeriodList.stream()
				.filter(workClassPeriod -> DateUtil.getLocalDate(StringUtil.stringValueOf(workClassPeriod.get("sdate"))).isBefore(edate)
						&& DateUtil.getLocalDate(StringUtil.stringValueOf(workClassPeriod.get("edate"))).isAfter(sdate))
				.map(workClassPeriod -> {

					WtmWorkClassPeriod classPeriod = new WtmWorkClassPeriod(
							StringUtil.stringValueOf(workClassPeriod.get("enterCd")),
							StringUtil.stringValueOf(workClassPeriod.get("sabun")),
							StringUtil.stringValueOf(workClassPeriod.get("workClassCd")),
							StringUtil.stringValueOf(workClassPeriod.get("sdate")),
							StringUtil.stringValueOf(workClassPeriod.get("edate"))
					);
					classPeriod.setOldSdate(StringUtil.stringValueOf(workClassPeriod.get("oldSdate")));
					classPeriod.setOldEdate(StringUtil.stringValueOf(workClassPeriod.get("oldEdate")));

					List<WtmWorkGroupPeriod> workGroupPeriodList = new ArrayList<>();
					if (workClassPeriod.containsKey("workGroupPeriodList")) {
						List<Map<String, Object>> workGroupPeriodMapList = (List<Map<String, Object>>) workClassPeriod.get("workGroupPeriodList");
						for (Map<String, Object> workGroupPeriodMap : workGroupPeriodMapList) {
							WtmWorkGroupPeriod workGroupPeriod = new WtmWorkGroupPeriod(
									StringUtil.stringValueOf(workGroupPeriodMap.get("enterCd")),
									StringUtil.stringValueOf(workGroupPeriodMap.get("sabun")),
									StringUtil.stringValueOf(workGroupPeriodMap.get("workClassCd")),
									StringUtil.stringValueOf(workGroupPeriodMap.get("workGroupCd")),
									StringUtil.stringValueOf(workGroupPeriodMap.get("sdate")),
									StringUtil.stringValueOf(workGroupPeriodMap.get("edate"))
							);
							workGroupPeriod.setOldSdate(StringUtil.stringValueOf(workGroupPeriodMap.get("oldSdate")));
							workGroupPeriod.setOldEdate(StringUtil.stringValueOf(workGroupPeriodMap.get("oldEdate")));
							workGroupPeriodList.add(workGroupPeriod);
						}

						classPeriod.setWorkGroupPeriodList(workGroupPeriodList);
					}

					return classPeriod;
				})
				.collect(Collectors.toList());

		// 변경데이터 추가
		WtmWorkClassPeriod newWorkClass = new WtmWorkClassPeriod(
				StringUtil.stringValueOf(paramMap.get("ssnEnterCd")),
				StringUtil.stringValueOf(paramMap.get("searchSabun")),
				StringUtil.stringValueOf(paramMap.get("workClassCd")),
				DateUtil.convertLocalDateToString(sdate),
				DateUtil.convertLocalDateToString(edate)
		);
		newWorkClassList.add(newWorkClass);


		if (paramMap.get("workGroupCd") != null && !"".equals(paramMap.get("workGroupCd"))) {
			WtmWorkGroupPeriod newWorkGroup = new WtmWorkGroupPeriod(
					StringUtil.stringValueOf(paramMap.get("ssnEnterCd")),
					StringUtil.stringValueOf(paramMap.get("searchSabun")),
					StringUtil.stringValueOf(paramMap.get("workClassCd")),
					StringUtil.stringValueOf(paramMap.get("workGroupCd")),
					DateUtil.convertLocalDateToString(sdate),
					DateUtil.convertLocalDateToString(edate)
			);
			newWorkGroupList.add(newWorkGroup);
		}

		// 겹치는 데이터가 있을 경우 겹치는 데이터의 원 데이터는 삭제 데이터로 추가. 겹치는 데이터의 시작일자, 종료일자를 조정하여 신규 입력 데이터로 추가.
		for (WtmWorkClassPeriod duplicatedPeriod : duplicatedList) {
			LocalDate periodSdate = duplicatedPeriod.getSdateToLocalDate();
			LocalDate periodEdate = duplicatedPeriod.getEdateToLocalDate();

			if (sdate.isBefore(periodEdate) || sdate.isEqual(periodEdate)) {
				delWorkClassList.add(duplicatedPeriod);

				if (sdate.isAfter(periodSdate)) {
					WtmWorkClassPeriod tmpClassPeriod = duplicatedPeriod.clone();
					tmpClassPeriod.setEdate(DateUtil.convertLocalDateToString(sdate.minusDays(1)));
					newWorkClassList.add(tmpClassPeriod);
				}
			}

			if (edate.isAfter(periodSdate) || edate.isEqual(periodSdate)) {
				delWorkClassList.add(duplicatedPeriod);

				if (edate.isBefore(periodEdate)) {
					WtmWorkClassPeriod tmpClassPeriod = duplicatedPeriod.clone();
					tmpClassPeriod.setSdate(DateUtil.convertLocalDateToString(edate.plusDays(1)));
					newWorkClassList.add(tmpClassPeriod);
				}
			}

			if (!duplicatedPeriod.getWorkGroupPeriodList().isEmpty()) {
				List<WtmWorkGroupPeriod> workGroupPeriodList = duplicatedPeriod.getWorkGroupPeriodList();
				for (WtmWorkGroupPeriod workGroupPeriod : workGroupPeriodList) {
					LocalDate workGroupSdate = workGroupPeriod.getSdateToLocalDate();
					LocalDate workGroupEdate = workGroupPeriod.getEdateToLocalDate();

					if (sdate.isBefore(workGroupEdate) || sdate.isEqual(workGroupEdate)) {
						delWorkGroupList.add(workGroupPeriod);

						if (sdate.isAfter(workGroupSdate)) {
							WtmWorkGroupPeriod tmpGroupPeriod = workGroupPeriod.clone();
							tmpGroupPeriod.setEdate(DateUtil.convertLocalDateToString(sdate.minusDays(1)));
							newWorkGroupList.add(tmpGroupPeriod);
						}
					}

					if (edate.isAfter(workGroupSdate) || edate.isEqual(workGroupSdate)) {
						delWorkGroupList.add(workGroupPeriod);

						if (edate.isBefore(workGroupEdate)) {
							WtmWorkGroupPeriod tmpGroupPeriod = workGroupPeriod.clone();
							tmpGroupPeriod.setSdate(DateUtil.convertLocalDateToString(edate.plusDays(1)));
							newWorkGroupList.add(tmpGroupPeriod);
						}
					}
				}
			}
		}
	}


	public int saveWtmPsnlWorkTarget(Map<String, Object> paramMap) throws Exception {
		int cnt = 0;

		paramMap.put("sdate", StringUtil.stringValueOf(paramMap.get("sdate")).replaceAll("[-]", ""));
		paramMap.put("edate", StringUtil.stringValueOf(paramMap.get("edate")).replaceAll("[-]", ""));

		String[] targets = StringUtil.stringValueOf(paramMap.get("targets")).split(",");
		for (String target : targets) {
			Map<String, Object> tmpParamMap = new HashMap<>(paramMap);
			tmpParamMap.put("searchSabun", target);

			List<WtmWorkClassPeriod> newWorkClassList = new ArrayList<>();
			List<WtmWorkClassPeriod> delWorkClassList = new ArrayList<>();
			List<WtmWorkGroupPeriod> newWorkGroupList = new ArrayList<>();
			List<WtmWorkGroupPeriod> delWorkGroupList = new ArrayList<>();

			// 신규로 추가하려는 기간과 기존의 근무유형 기간이 겹칠 수 가 있기 때문에 해당 기간에 겹치는 데이터는 삭제 후 다시 생성하기로 한다.
			setWorkClassAndGroupList(tmpParamMap, newWorkClassList, delWorkClassList, newWorkGroupList, delWorkGroupList);

			if (!delWorkGroupList.isEmpty()) {
				paramMap.put("deleteRows", delWorkGroupList);
				cnt += dao.delete("deleteWtmPsnlWorkGroups", paramMap);
				// 기 저장되어 반영된 스케줄도 삭제 필요.
				dao.delete("updateWtmPsnlShiftWorkSchedule1", paramMap); // 실제 인정근무 null 로 업데이트
				dao.delete("deleteWtmPsnlShiftWorkSchedule2", paramMap); // 임시저장 및 반영된 교대조근무스케줄 삭제
			}

			if (!delWorkClassList.isEmpty()) {
				paramMap.put("deleteRows", delWorkClassList);
				cnt += dao.delete("deleteWtmPsnlWorkClasses", paramMap);
			}

			if (!newWorkClassList.isEmpty()) {
				paramMap.put("mergeRows", newWorkClassList);
				cnt += dao.update("saveWtmPsnlWorkClasses", paramMap);
			}

			if (!newWorkGroupList.isEmpty()) {
				paramMap.put("mergeRows", newWorkGroupList);
				cnt += dao.update("saveWtmPsnlWorkGroups", paramMap);
			}

			// 일근무집계 다시 수행
			if (!delWorkClassList.isEmpty()) {
				for (WtmWorkClassPeriod delWorkClass : delWorkClassList) {
					// 종료일자가 29991231 일 경우 일근무집계 수행에 너무 많은 시간이 소요되어 현재 저장되어 있는 근무 집계 데이터 바탕으로 재집계 수행
					Map<String, Object> tmpMap = new HashMap<>();
					tmpMap.put("enterCd", delWorkClass.getEnterCd());
					tmpMap.put("sabun", delWorkClass.getSabun());
					tmpMap.put("sdate", delWorkClass.getSdate());
					tmpMap.put("edate", delWorkClass.getEdate());
					Map<String, Object> maxYmd = (Map<String, Object>) dao.getMap("getWtmPsnlWorkClassMaxYmd", tmpMap);
					String edate = StringUtil.stringValueOf(maxYmd.get("maxYmd"));
					delWorkClass.setEdate(edate);
					postSave(delWorkClass.getEnterCd(), delWorkClass.getSabun(), delWorkClass.getSdate(), delWorkClass.getEdate());
				}
			}
		}

		return cnt;
	}

	public int deleteWtmPsnlWorkMgr(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		cnt += dao.delete("deleteWtmPsnlWorkMgr", paramMap);
		return cnt;
	}

	public int deleteWtmPsnlWorkClassTarget(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if (paramMap.containsKey("searchSabun") && paramMap.get("searchSabun") != null && !"".equals(paramMap.get("searchSabun"))) {
			Log.Debug("===== deleteWtmPsnlWorkClassTarget =====");
			Log.Debug(StringEscapeUtils.unescapeHtml4(paramMap.get("searchSabun").toString()));
			JSONParser jsonParser = new JSONParser();
			JSONArray jsonArray = (JSONArray) jsonParser.parse(StringEscapeUtils.unescapeHtml4(paramMap.get("searchSabun").toString()));
			List<String> sabuns = new ArrayList<>();
			for (Object obj : jsonArray) {
				sabuns.add(obj.toString());
			}
			paramMap.put("sabuns", sabuns);
			cnt += dao.delete("deleteWtmPsnlWorkClassTarget", paramMap);
			if(paramMap.containsKey("workGroupCd") && paramMap.get("workGroupCd") != null && !"".equals(paramMap.get("workGroupCd"))){
				dao.delete("deleteWtmPsnlWorkGroupTarget", paramMap);
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
			if(paramMap.get("workGroupCd") != null){
				dao.update("updateShiftContEdate", type);
			}
		}
	}

}