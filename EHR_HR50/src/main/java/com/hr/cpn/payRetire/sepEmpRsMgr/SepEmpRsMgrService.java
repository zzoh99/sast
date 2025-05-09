package com.hr.cpn.payRetire.sepEmpRsMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직금기본내역 Service
 *
 * @author JM
 *
 */
@Service("SepEmpRsMgrService")
public class SepEmpRsMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직금기본내역 좌측 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEmpRsMgrListLeft(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSepEmpRsMgrListLeft", paramMap);
	}

	/**
	 * 퇴직금기본내역 기본사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepEmpRsMgrBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepEmpRsMgrBasicMap", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 급여 항목리스트 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEmpRsMgrAverageIncomePayTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEmpRsMgrAverageIncomePayTitleList", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 급여 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEmpRsMgrAverageIncomePayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEmpRsMgrAverageIncomePayList", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 상여 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEmpRsMgrAverageIncomeBonusList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEmpRsMgrAverageIncomeBonusList", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 연차 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEmpRsMgrAverageIncomeAnnualList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEmpRsMgrAverageIncomeAnnualList", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 퇴직금계산내역 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepEmpRsMgrSeverancePayMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepEmpRsMgrSeverancePayMap", paramMap);
	}


	/**
	 * 퇴직금기본내역 퇴직금계산내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEmpRsMgrSeverancePayCalcList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEmpRsMgrSeverancePayCalcList", paramMap);
	}

	/**
	 * 퇴직금기본내역 퇴직종합정산TAB 지급내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEmpRsMgrRetireCalcPayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEmpRsMgrRetireCalcPayList", paramMap);
	}

	/**
	 * 퇴직금기본내역 퇴직종합정산TAB 공제내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEmpRsMgrRetireCalcDeductionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEmpRsMgrRetireCalcDeductionList", paramMap);
	}

	/**
	 * 퇴직금기본내역 전근무지사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepEmpRsMgrBeforeWorkMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepEmpRsMgrBeforeWorkMap", paramMap);
	}

	/**
	 * 퇴직금기본내역 IRP정보 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepEmpRsMgrIrpInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		dao.delete("deleteSepEmpRsMgrIrpInfo", paramMap);

		int cnt = dao.update("saveSepEmpRsMgrIrpInfo", paramMap);

		return cnt;
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 급여 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepEmpRsMgrAverageIncomePay(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// 퇴직평균임금(급여)[TCPN757] 삭제
			cnt += dao.delete("deleteSepEmpRsMgrAverageIncomePay", convertMap);
			// 퇴직평균임금(급여)_상세내역 [TCPN758] 삭제
			cnt += dao.delete("deleteSepEmpRsMgrAverageIncomePayDtl", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			// 퇴직평균임금(급여)[TCPN757] 저장
			cnt += dao.update("saveSepEmpRsMgrAverageIncomePay", convertMap);
			// 퇴직평균임금(급여)_상세내역 [TCPN758] 삭제
			cnt += dao.delete("deleteSepEmpRsMgrAverageIncomePayDtl", convertMap);
			// 퇴직평균임금(급여)_상세내역 [TCPN758] 저장
			cnt += dao.update("saveSepEmpRsMgrAverageIncomePayDtl", convertMap);
		}
		return cnt;
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 상여 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepEmpRsMgrAverageIncomeBonus(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepEmpRsMgrAverageIncomeBonus", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepEmpRsMgrAverageIncomeBonus", convertMap);
		}
		return cnt;
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 연차 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepEmpRsMgrAverageIncomeAnnual(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepEmpRsMgrAverageIncomeAnnual", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepEmpRsMgrAverageIncomeAnnual", convertMap);
		}
		return cnt;
	}

	/**
	 * 퇴직금재계산
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map<?, ?> prcP_CPN_SEP_PAY_MAIN(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		String[] target = ((String) paramMap.get("checkValues")).split(",");

		Map<?, ?> map  = null;

		if (target != null && target.length > 0 ){
			for ( int i = 0 ; i < target.length ; i++ ){
				String personstring = target[i];
				if (personstring != null) {
					HashMap<String, Object> returnMap 	= new HashMap<String, Object>();
					String[] person = personstring.split("_");
					returnMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
					returnMap.put("ssnSabun", paramMap.get("ssnSabun"));
					returnMap.put("payActionCd", person[0]);
					returnMap.put("businessPlaceCd", "");
					returnMap.put("sabun", person[1]);
					map = (Map<?, ?>) dao.excute("SepEmpRsMgrP_CPN_SEP_PAY_MAIN", returnMap);
				}
			}
		}

		return map;
	}
}