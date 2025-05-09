package com.hr.wtm.config.wtmLeaveCreMgr;

import com.github.f4b6a3.tsid.TsidCreator;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.popup.pwrSrchResultPopup.PwrSrchResultPopupService;
import com.hr.common.util.DateUtil;
import com.hr.common.util.StringUtil;
import com.hr.wtm.config.wtmGntCdMgr.WtmGntCdDTO;
import com.hr.wtm.config.wtmLeaveCreMgr.domain.WtmLeaveCreEmployee;
import com.hr.wtm.config.wtmLeaveCreMgr.domain.WtmLeaveCreate;
import com.hr.wtm.config.wtmLeaveCreMgr.dto.WtmUserLeaveCreDTO;
import com.hr.wtm.config.wtmLeaveCreMgr.dto.WtmUserLeaveCreDetDTO;
import com.hr.wtm.config.wtmLeaveCreMgr.dto.WtmUserLeaveDTO;
import com.hr.wtm.config.wtmLeaveCreStd.WtmLeaveCreOption;
import com.hr.wtm.config.wtmLeaveCreStd.WtmLeaveCreStdService;
import com.hr.wtm.domain.WtmLeaveAppInfo;
import com.hr.wtm.domain.WtmLeaveReCalc;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import javax.inject.Named;
import java.time.LocalDate;
import java.util.*;

/**
 * 휴가생성 Service
 *
 * @author bckim
 *
 */
@Service
public class WtmLeaveCreMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private PwrSrchResultPopupService pwrSrchResultPopupService;

	@Autowired
	private WtmLeaveCreStdService wtmLeaveCreStdService;

	/**
	 * 휴가생성 조회 Service
	 *
	 * @param paramMap
	 * @return 휴가생성 Map
	 * @throws Exception
	 */
	public List<Map<String, Object>> getWtmLeaveCreMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getWtmLeaveCreMgrList", paramMap);
	}

	/**
	 * 휴가생성 저장 Service
	 *
	 * @param convertMap
	 * @return 저장 count
	 * @throws Exception
	 */
	public int saveWtmLeaveCreMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int result = 0;
		if (!((List<?>) convertMap.get("deleteRows")).isEmpty()) {
			dao.delete("deleteWtmLeaveCreMgr509", convertMap);
			dao.delete("deleteWtmLeaveCreMgr510", convertMap);
			result += dao.delete("deleteWtmLeaveCreMgr", convertMap);
		}
		if (!((List<?>) convertMap.get("mergeRows")).isEmpty()) {
			List<Map<String, Object>> mergeRows = (List<Map<String, Object>>) convertMap.get("mergeRows");
			mergeRows.forEach(map -> {
				if ("".equals(map.get("leaveId"))) {
					map.put("leaveId", TsidCreator.getTsid().toString());
				}
			});
			convertMap.put("mergeRows", mergeRows);
			result += dao.update("saveWtmLeaveCreMgr", convertMap);
		}
		return result;
	}

	/**
	 * 휴가생성 Service
	 *
	 * @param paramMap
	 * @return 저장 count
	 * @throws Exception
	 */
	@Transactional(value = "phrTransactionManager")
	public int excCreateWtmLeaves(Map<String, Object> paramMap) throws Exception {
		Log.Debug();

		String searchYear = (String) paramMap.get("searchYear");
		String gntCd = (String) paramMap.get("gntCd");
		String searchSeq = (String) paramMap.get("searchSeq");

		Log.Debug(" ## 파라미터 [searchYear: " + searchYear + ", gntCd: " + gntCd + ", searchSeq: " + searchSeq + "] ## ");

		// 휴가생성기준 조회
		Map<String, Object> stdMap = (Map<String, Object>) dao.getOne("getWtmLeaveCreStdMap", paramMap);

		// 휴가생성 대상자 조회
		paramMap.put("empRows", getResultQuery(paramMap));
		List<Map<String, Object>> empList = (List<Map<String, Object>>) dao.getList("getWtmLeaveCreEmpYmd", paramMap);

		/**
		 * 연차 생성 순서
		     1. WtmLeaveCreate 객체 생성. 파라미터에는 휴가생성기준 데이터 Map 형태로 전달.
		     2. 연차 생성 대상자 설정. (setEmpList)
		     3. 계산 함수 호출 (calc: 특정기준일로 계산 또는 calcByYear: 특정년도로 계산)
		     4. 계산 이력만 필요한 경우 getLogicList 로 값 조회
		     5. 실제 반영할 연차내역이 필요한 경우 createUserLeaves 로 반영할 연차 데이터 생성.
		     6. getResultList 로 반영할 연차 데이터 조회.
		 */
		WtmLeaveCreOption option = new WtmLeaveCreOption(stdMap);
		WtmLeaveCreate leaveCreate = new WtmLeaveCreate(option);
		leaveCreate.setEmpList(empList);
		leaveCreate.calcByYear(searchYear);
		List<WtmUserLeaveCreDTO> creDTOList = leaveCreate.getLogicList(); // 계산이력

		// 잔여연차 보상형태가 이월인 경우 이월일수 업데이트
		if ("A".equals(leaveCreate.getRewardType())
				|| "A".equals(leaveCreate.getRewardTypeU1y())) {

			creDTOList.forEach(creDTO -> {
				Map<String, Object> map = new HashMap<>();
				map.put("dto", creDTO);
				map.put("rewardYn", ("A".equals(leaveCreate.getRewardType()) ? "Y" : "N"));
				map.put("rewardU1yYn", ("A".equals(leaveCreate.getRewardTypeU1y()) ? "Y" : "N"));
                try {
                    Map<String, Object> frdMap = (Map<String, Object>) dao.getOne("getWtmLeaveCreMgrFrdCnt", map); // 전년도 잔여연차 조회
					if (frdMap != null && !frdMap.isEmpty())
						creDTO.setCarryOverCnt(Double.parseDouble(frdMap.get("frdCnt").toString()));
                } catch (Exception e) {
					e.printStackTrace();
					throw new RuntimeException(e);
                }
            });
		}

		Log.Debug(" ## creDTOList: " + creDTOList);

		// 데이터 저장 start
		int result = 0;
		if (!creDTOList.isEmpty()) {

			Log.Debug(" ## 기존 휴가 데이터 삭제 Start ## ");
			Map<String, Object> delMap = new HashMap<>();
			delMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			delMap.put("ssnSabun", paramMap.get("ssnSabun"));
			delMap.put("searchYear", searchYear);
			delMap.put("gntCd", gntCd);
			delMap.put("searchSeq", searchSeq);
			delMap.put("deleteEmps", leaveCreate.getEmpList());
			dao.delete("deleteWtmLeavesCreateLogicDet", delMap);
			dao.delete("deleteWtmLeavesCreate", delMap);
			dao.delete("deleteWtmLeavesCreateLogic", delMap);
			Log.Debug(" ## 기존 휴가 데이터 삭제 End ## ");


			Log.Debug(" ## 연차생성프로세스 저장 Start ## ");
			Map<String, Object> map = new HashMap<>();
			map.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			map.put("ssnSabun", paramMap.get("ssnSabun"));
			map.put("insertRows", creDTOList);
			result += dao.update("saveWtmLeavesCreateLogic", map); // 연차생성절차 저장
			Log.Debug(" ## 연차생성프로세스 저장 End ## ");

			Log.Debug(" ## 연차생성이력_소정근무제외이력 저장 Start ## ");
			creDTOList.forEach(creDTO -> {
				List<WtmUserLeaveCreDetDTO> creDetDTOList = creDTO.getCreDetDTOList();
				if (!creDetDTOList.isEmpty()) {
					Map<String, Object> map2 = new HashMap<>();
					map2.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
					map2.put("ssnSabun", paramMap.get("ssnSabun"));
					map2.put("leaveId", creDTO.getLeaveId());
					map2.put("insertRows", creDetDTOList);
					try {
						dao.update("saveWtmLeavesCreateLogicDet", map2); // 연차생성이력_소정근무제외이력 저장
					} catch (Exception e) {
						e.printStackTrace();
						throw new RuntimeException(e);
					}
				}
            });
			Log.Debug(" ## 연차생성이력_소정근무제외이력 저장 End ## ");


			Log.Debug(" ## 실제 사용 연차생성 저장 Start ## ");
			// TODO: 자동반영할지 여부도 옵션으로?
			boolean isAutoCreate = true;
			if (isAutoCreate) {
				leaveCreate.createUserLeaves(); // 실제 반영할 연차데이터 생성
				List<WtmUserLeaveDTO> leaveDTOList = leaveCreate.getResultList();
				if (!leaveDTOList.isEmpty()) {
					Map<String, Object> map3 = new HashMap<>();
					map3.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
					map3.put("ssnSabun", paramMap.get("ssnSabun"));
					map3.put("insertRows", leaveDTOList);
					try {
						dao.update("saveWtmLeavesCreate", map3); // 실제 연차 저장
					} catch (Exception e) {
						e.printStackTrace();
						throw new RuntimeException(e);
					}
				}
			}
			Log.Debug(" ## 실제 사용 연차생성 저장 End ## ");
		}

		String stdYmd = searchYear + "1231";
		reCalcLeaves(leaveCreate.getEmpList(), stdYmd);

		return result;
	}

	/**
	 * 조건검색 Seq 로 대상자 리스트 조회
	 * @param paramMap 파라미터
	 * @return 대상자 리스트
	 * @throws Exception
	 */
	private List<Map<String, Object>> getResultQuery(Map<String, Object> paramMap) throws Exception {

		String dfIdvSabun = (String) paramMap.get("ssnSabun");

		Map<String, Object> query = (Map<String, Object>) pwrSrchResultPopupService.getPwrSrchResultPopupQueryMap(paramMap);
		String queryStr = (String) query.get("query");
		if( !StringUtil.isBlank(queryStr) ) {
			if( queryStr.contains(":dfIdvSabun") && !StringUtil.isBlank(dfIdvSabun) ) {
				queryStr = queryStr.replace(":dfIdvSabun", dfIdvSabun);
			}
		}
		paramMap.put("query", queryStr);
		Log.Debug(paramMap.toString());
		try {
			return (List<Map<String, Object>>) pwrSrchResultPopupService.getPwrSrchResultPopupResultDown(paramMap);
		} catch(Exception e) {
			throw new HrException("조회에 실패하였습니다.");
		}
	}

	/**
	 * 특정 대상자만 연차 개수 재계산
	 *
	 * @param enterCd 회사코드
	 * @param sabun 대상자 사번
	 * @param stdYmd 재계산 대상일자. 해당 일자에 사용 가능한 연차 데이터만 재계산을 진행한다.
	 * @throws Exception
	 */
	public int reCalcLeaves(String enterCd, String sabun, String stdYmd) throws Exception {
		WtmLeaveCreEmployee employee = new WtmLeaveCreEmployee(enterCd, sabun, "", "");
		List<WtmLeaveCreEmployee> employees = new ArrayList<>();
		employees.add(employee);
		return reCalcLeaves(employees, stdYmd);
	}

	/**
	 * 연차 대상자들의 연차 개수 재계산
	 *
	 * @param employees 연차 대상자 리스트
	 * @param stdYmd 재계산 대상일자. 해당 일자에 사용 가능한 연차 데이터만 재계산을 진행한다.
	 * @throws Exception
	 */
	public int reCalcLeaves(List<WtmLeaveCreEmployee> employees, String stdYmd) throws Exception {
		List<WtmLeaveAppInfo> appliedLeavesList = getAppliedLeavesList(employees);
		List<WtmUserLeaveDTO> userLeaves = getUserLeaveStatsList(employees);

		WtmLeaveReCalc reCalc = new WtmLeaveReCalc(appliedLeavesList, userLeaves);
		reCalc.reCalc();
		List<WtmUserLeaveDTO> result = reCalc.getResultList(stdYmd);

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("mergeRows", result);
		return dao.update("saveWtmLeavesCreateLeavesUpdate", paramMap); // 재계산된 데이터 저장
	}

	/**
	 * 연차 재계산에 필요한 대상자들의 신청한 근태 리스트를 객체 리스트로 생성
	 *
	 * @param employees 대상자 리스트
	 * @return 대상자들의 신청한 근태 정보 리스트
	 * @throws Exception
	 */
	private List<WtmLeaveAppInfo> getAppliedLeavesList(List<WtmLeaveCreEmployee> employees) throws Exception {

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("emps", employees);

		List<Map<String, Object>> appHistoryList = (List<Map<String, Object>>) dao.getList("getWtmLeaveCreMgrHistory", paramMap); // 대상자들의 근태 신청 리스트 조회
		List<Map<String, Object>> gntCdList = (List<Map<String, Object>>) dao.getList("getWtmLeaveCreGntCdList", new HashMap<>()); // 근태코드 리스트 조회

		List<WtmLeaveAppInfo> appliedLeavesList = new ArrayList<>();
		appHistoryList
				.forEach(map -> {
					try {
						String enterCd = StringUtil.stringValueOf(map.get("enterCd"));
						String gntCd = StringUtil.stringValueOf(map.get("gntCd"));
						Map<String, Object> gntCdMap = gntCdList.stream()
								.filter(map2 -> map2.get("enterCd").equals(enterCd) && map2.get("gntCd").equals(gntCd))
								.findFirst().orElseThrow(() -> new HrException(gntCd + " 오류가 발생하였습니다."));
						WtmGntCdDTO gntCdDTO = new WtmGntCdDTO(gntCdMap);
						WtmLeaveAppInfo appInfo = new WtmLeaveAppInfo(map, gntCdDTO);
						appliedLeavesList.add(appInfo);
					} catch (HrException e) {
						Log.Error(e.getLocalizedMessage());
					}
				});
		return appliedLeavesList;
	}

	/**
	 * 연차 재계산에 필요한 대상자들의 현재 사용가능한 연차 개수 현황 리스트 조회
	 *
	 * @param employees 대상자 리스트
	 * @return 대상자들의 현재 사용가능한 연차 개수 현황 리스트
	 * @throws Exception
	 */
	private List<WtmUserLeaveDTO> getUserLeaveStatsList(List<WtmLeaveCreEmployee> employees) throws Exception {

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("emps", employees);

		List<Map<String, Object>> leaveStats = (List<Map<String, Object>>) dao.getList("getWtmLeaveCreLeaveStats", paramMap); // 생성된 휴가 리스트 조회
		List<WtmUserLeaveDTO> userLeaves = new ArrayList<>();
		leaveStats.forEach(map -> {
			WtmUserLeaveDTO leaveDTO = new WtmUserLeaveDTO(map);
			userLeaves.add(leaveDTO);
		});

		return userLeaves;
	}

	/**
	 * 휴가생성 Service
	 * @param enterCd
	 * @param gntCd
	 * @param searchSeq
	 * @param stdYmd
	 * @param ssnSabun
	 * @throws Exception
	 */
	@Transactional
	public void excCreateWtmLeavesByDaily(String enterCd, String gntCd, String searchSeq, String stdYmd, String ssnSabun) throws Exception {
		Log.Debug();

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("ssnEnterCd", enterCd);
		paramMap.put("gntCd", gntCd);
		paramMap.put("searchSeq", searchSeq);
		paramMap.put("srchSeq", searchSeq);
		paramMap.put("ssnSearchType", "A");
		paramMap.put("ssnGrpCd", "10");
		paramMap.put("ssnSabun", ssnSabun);

		Log.Debug(" ## 파라미터 [enterCd: " + enterCd + ", stdYmd: " + stdYmd + ", gntCd: " + gntCd + ", searchSeq: " + searchSeq + "] ## ");

		// 휴가생성기준 조회
		Map<String, Object> stdMap = (Map<String, Object>) dao.getOne("getWtmLeaveCreStdMap", paramMap);

		// 휴가생성 대상자 조회
		paramMap.put("empRows", getResultQuery(paramMap));
		List<Map<String, Object>> empList = (List<Map<String, Object>>) dao.getList("getWtmLeaveCreEmpYmd", paramMap);

		/**
		 * 연차 생성 순서
		 1. WtmLeaveCreate 객체 생성. 파라미터에는 휴가생성기준 데이터 Map 형태로 전달.
		 2. 연차 생성 대상자 설정. (setEmpList)
		 3. 계산 함수 호출 (calc: 특정기준일로 계산 또는 calcByYear: 특정년도로 계산)
		 4. 계산 이력만 필요한 경우 getLogicList 로 값 조회
		 5. 실제 반영할 연차내역이 필요한 경우 createUserLeaves 로 반영할 연차 데이터 생성.
		 6. getResultList 로 반영할 연차 데이터 조회.
		 */
		WtmLeaveCreOption option = new WtmLeaveCreOption(stdMap);
		WtmLeaveCreate leaveCreate = new WtmLeaveCreate(option);
		leaveCreate.setEmpList(empList);
		leaveCreate.calc(stdYmd);
		List<WtmUserLeaveCreDTO> creDTOList = leaveCreate.getLogicList(); // 계산이력

		// 잔여연차 보상형태가 이월인 경우 이월일수 업데이트
		if ("A".equals(leaveCreate.getRewardType())
				|| "A".equals(leaveCreate.getRewardTypeU1y())) {

			creDTOList.forEach(creDTO -> {
				Map<String, Object> map = new HashMap<>();
				map.put("enterCd", creDTO.getEnterCd());
				map.put("sabun", creDTO.getSabun());
				map.put("gntCd", creDTO.getGntCd());
				map.put("useSYmd", creDTO.getUseSYmd());
				map.put("rewardYn", ("A".equals(leaveCreate.getRewardType()) ? "Y" : "N"));
				map.put("rewardU1yYn", ("A".equals(leaveCreate.getRewardTypeU1y()) ? "Y" : "N"));
				try {
					Map<String, Object> frdMap = (Map<String, Object>) dao.getOne("getWtmLeaveCreMgrFrdCnt", map); // 전년도 잔여연차 조회
					if (frdMap != null && !frdMap.isEmpty())
						creDTO.setCarryOverCnt(Double.parseDouble(frdMap.get("frdCnt").toString()));
				} catch (Exception e) {
					e.printStackTrace();
					throw new RuntimeException(e);
				}
			});
		}

		Log.Debug(" ## creDTOList: " + creDTOList);

		// 데이터 저장 start
		if (!creDTOList.isEmpty()) {

			Log.Debug(" ## 기존 휴가 데이터 삭제 Start ## ");
			Map<String, Object> delMap = new HashMap<>();
			delMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			delMap.put("ssnSabun", paramMap.get("ssnSabun"));
			delMap.put("searchYm", DateUtil.convertLocalDateToString(DateUtil.getLocalDate(stdYmd), "yyyyMM"));
			delMap.put("gntCd", gntCd);
			delMap.put("searchSeq", searchSeq);
			delMap.put("deleteEmps", leaveCreate.getEmpList());
			dao.delete("deleteWtmLeavesCreateLogicDet", delMap);
			dao.delete("deleteWtmLeavesCreateLogic", delMap);
			dao.delete("deleteWtmLeavesCreate", delMap);
			Log.Debug(" ## 기존 휴가 데이터 삭제 End ## ");


			Log.Debug(" ## 연차생성이력 저장 Start ## ");
			Map<String, Object> map = new HashMap<>();
			map.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			map.put("ssnSabun", paramMap.get("ssnSabun"));
			map.put("insertRows", creDTOList);
			dao.update("saveWtmLeavesCreateLogic", map); // 연차생성이력 저장
			Log.Debug(" ## 연차생성이력 저장 End ## ");

			Log.Debug(" ## 연차생성이력_소정근무제외이력 저장 Start ## ");
			creDTOList.forEach(creDTO -> {
				List<WtmUserLeaveCreDetDTO> creDetDTOList = creDTO.getCreDetDTOList();
				if (!creDetDTOList.isEmpty()) {
					Map<String, Object> map2 = new HashMap<>();
					map2.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
					map2.put("ssnSabun", paramMap.get("ssnSabun"));
					map2.put("leaveId", creDTO.getLeaveId());
					map2.put("insertRows", creDetDTOList);
					try {
						dao.update("saveWtmLeavesCreateLogicDet", map2); // 연차생성이력_소정근무제외이력 저장
					} catch (Exception e) {
						e.printStackTrace();
						throw new RuntimeException(e);
					}
				}
			});
			Log.Debug(" ## 연차생성이력_소정근무제외이력 저장 End ## ");


			Log.Debug(" ## 실제 사용 연차생성 저장 Start ## ");
			// TODO: 자동반영할지 여부도 옵션으로?
			boolean isAutoCreate = true;
			if (isAutoCreate) {
				leaveCreate.createUserLeaves(); // 실제 반영할 연차데이터 생성
				List<WtmUserLeaveDTO> leaveDTOList = leaveCreate.getResultList();
				if (!leaveDTOList.isEmpty()) {
					Map<String, Object> map3 = new HashMap<>();
					map3.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
					map3.put("ssnSabun", paramMap.get("ssnSabun"));
					map3.put("insertRows", leaveDTOList);
					try {
						dao.update("saveWtmLeavesCreate", map3); // 실제 연차 저장
					} catch (Exception e) {
						e.printStackTrace();
						throw new RuntimeException(e);
					}
				}
			}
			Log.Debug(" ## 실제 사용 연차생성 저장 End ## ");
		}
	}

	/**
	 * 휴가생성_레이어 휴가생성 정보 조회 Service
	 *
	 * @param paramMap
	 * @return 휴가생성 Map
	 * @throws Exception
	 */
	public Map<String, Object> getWtmLeaveCreMgrLayerStdInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return wtmLeaveCreStdService.getWtmLeaveCreStdMap(paramMap);
	}




	@Scheduled(cron = "${isu.wtm.leave.create.cron}")
	public void leaveCreate() {
		try {
			List<Map<String, Object>> enterAllList = (List<Map<String, Object>>) dao.getList("getEnterCdAllList", new HashMap<>());
			enterAllList.forEach(map -> {
				map.put("ssnEnterCd", map.get("code"));
                try {
                    List<Map<String, Object>> stdAllList = (List<Map<String, Object>>) dao.getList("getWtmLeaveCreStdAllList", map);
					stdAllList.forEach(stdMap -> {
						String enterCd = (String) stdMap.get("enterCd");
						String gntCd = (String) stdMap.get("gntCd");
						String searchSeq = stdMap.get("searchSeq").toString();
						String stdYmd = DateUtil.convertLocalDateToString(LocalDate.now());
                        try {
                            excCreateWtmLeavesByDaily(enterCd, gntCd, searchSeq, stdYmd, "BATCH");
                        } catch (Exception e) {
                            throw new RuntimeException(e);
                        }
                    });
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
			});
		} catch (InterruptedException e) {
			e.printStackTrace();
			Log.Error(" * Thread 가 강제 종료되었습니다. " + e.getLocalizedMessage());
		} catch (Exception e) {
			e.printStackTrace();
			Log.Error(" * Batch 시스템이 예기치 않게 종료되었습니다. " + e.getLocalizedMessage());
		}
	}
}