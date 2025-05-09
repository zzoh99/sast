package com.hr.cpn.personalPay.psnalSalaryMasterUser;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.math.BigDecimal;
import java.util.*;

/**
 * 개인별급여내역 Service
 *
 * @author JM
 *
 */
@Service("PsnalSalaryMasterUserService")
public class PsnalSalaryMasterUserService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 개인 임금 마스터 기본사항 조회
	 */
	public Map<String, Object> getPsnalSalaryMasterUserBasic(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		// 연봉정보

		// 과세정보
		List taxInfoList = (List) dao.getList("getPsnalSalaryMasterUserTaxInfoList", paramMap);

		// 계좌정보
		List accountInfoList = (List) dao.getList("getPsnalSalaryMasterUserAccountInfoList", paramMap);

		// resultMap에 기본사항 정보 모두 담아서 리턴
		resultMap.put("taxInfoList", taxInfoList);
		resultMap.put("accountInfoList", accountInfoList);

		return resultMap;
	}

	/**
	 * 개인 임금 마스터 지급/공제내역 조회
	 */
	public Map<String, Object> getPsnalSalaryMasterUserPay(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		// 지급내역
		paramMap.put("elementType", "A");
		List payList = (List) dao.getList("getPsnalSalaryMasterUserPayList", paramMap);

		// 공제내역
		paramMap.put("elementType", "D");
		List dedList = (List) dao.getList("getPsnalSalaryMasterUserPayList", paramMap);

		resultMap.put("payList", payList);
		resultMap.put("dedList", dedList);

		return resultMap;
	}

	/**
	 * 개인 임금 마스터 연봉이력 조회
	 */
	public Map<String, Object> getPsnalSalaryMasterUserSalary(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> resultMap = new HashMap<String, Object>();

		// 연봉 항목 조회
		List<Map<String, Object>> list = (List) dao.getList("getPsnalSalaryMasterUserSalaryList", paramMap);

		if(list != null && !list.isEmpty()) {

			// 연봉 항목 타이틀 리스트 생성
			Set<Map<String, Object>> uniqueSet = new TreeSet<>(
					Comparator.comparingInt(m -> {
						Object priorityObj = m.get("priority");
						return (priorityObj instanceof BigDecimal) ? ((BigDecimal) priorityObj).intValue() : 0;
					})
			);

			for (Map<String, Object> row : list) {
				Map<String, Object> newRow = new HashMap<>();
				newRow.put("elementCd", row.get("elementCd"));
				newRow.put("elementNm", row.get("elementNm"));
				newRow.put("priority", row.get("priority"));
				uniqueSet.add(newRow);
			}
			List salaryTitleList =  new ArrayList<>(uniqueSet);

			// 연봉 항목별 금액 리스트 생성
			Map<String, Map<String, Object>> groupedData = new HashMap<>();
			for (Map<String, Object> row : list) {
				// sdate 기준으로 그룹화
				String sdate = (String) row.get("sdate");
				groupedData.putIfAbsent(sdate, new HashMap<>());

				Map<String, Object> groupedRow = groupedData.get(sdate);
				groupedRow.put("sdate", sdate);
				groupedRow.put("edate", row.get("edate"));
				groupedRow.put("bigo", row.get("bigo"));
				groupedRow.put("s" + sdate + "e" + row.get("elementCd") + "Mon", row.get("elementMon"));
			}
			List<Map<String, Object>> salaryList =  new ArrayList<>(groupedData.values());
			salaryList.sort(Comparator.comparing(m -> (String) m.get("sdate")));

			resultMap.put("salaryTitleList", salaryTitleList);
			resultMap.put("salaryList", salaryList);
		}

		return resultMap;
	}

	
	/**
	 * 개인 임금 마스터 급여압류 조회
	 */
	public Map<String, Object> getPsnalSalaryMasterUserPayGrns(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 채권현황
		List bondList = (List) dao.getList("getPsnalSalaryMasterUserPayGrnsBondList", paramMap);

		// 공제현황
		List dedList = (List) dao.getList("getPsnalSalaryMasterUserPayGrnsDedList", paramMap);

		resultMap.put("bondList", bondList);
		resultMap.put("dedList", dedList);

		return resultMap;
	}

	/**
	 * 개인 임금 마스터 급여압류 조회
	 */
	public Map<String, Object> getPsnalSalaryMasterUserInsr(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		Map<String, Object> resultMap = new HashMap<String, Object>();

		// 현재불입상태
		List insrStatus = (List) dao.getList("getPsnalSalaryMasterUserInsrStatusList", paramMap);

		// 년도별 건강/요양 보험료 정산
		List insrCalcList = (List) dao.getList("getPsnalSalaryMasterUserInsrCalcList", paramMap);

		resultMap.put("insrStatus", insrStatus);
		resultMap.put("insrCalcList", insrCalcList);

		return resultMap;
	}
	
	/**
	 * 개인 임금 마스터 임금피크 조회
	 */
	public List<?> getPsnalSalaryMasterUserPeak(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalSalaryMasterUserPeakList", paramMap);
	}
	
	/**
	 * 개인 임금 마스터 이력 레이어 조회
	 */
	public List<?> getPsnalSalaryMasterUserHistory(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		if(paramMap.get("type").toString().equalsIgnoreCase("tax")) {
			return (List<?>) dao.getList("getPsnalSalaryMasterUserTaxInfoList", paramMap);
		} else if(paramMap.get("type").toString().equalsIgnoreCase("account")) {
			return (List<?>) dao.getList("getPsnalSalaryMasterUserAccountInfoList", paramMap);
		}
		return null;
	}

}