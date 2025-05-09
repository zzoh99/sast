package com.hr.cpn.payRetire.sepCalcBasicMgr;
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
@Service("SepCalcBasicMgrService")
public class SepCalcBasicMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직금기본내역 기본사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepCalcBasicMgrBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepCalcBasicMgrBasicMap", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 급여 항목리스트 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcBasicMgrAverageIncomePayTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcBasicMgrAverageIncomePayTitleList", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 급여 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcBasicMgrAverageIncomePayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcBasicMgrAverageIncomePayList", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 상여 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcBasicMgrAverageIncomeBonusList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcBasicMgrAverageIncomeBonusList", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 연차 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcBasicMgrAverageIncomeAnnualList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcBasicMgrAverageIncomeAnnualList", paramMap);
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 퇴직금계산내역 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepCalcBasicMgrSeverancePayMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepCalcBasicMgrSeverancePayMap", paramMap);
	}


	/**
	 * 퇴직금기본내역 퇴직금계산내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcBasicMgrSeverancePayCalcList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcBasicMgrSeverancePayCalcList", paramMap);
	}

	/**
	 * 퇴직금기본내역 퇴직종합정산TAB 지급내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcBasicMgrRetireCalcPayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcBasicMgrRetireCalcPayList", paramMap);
	}

	/**
	 * 퇴직금기본내역 퇴직종합정산TAB 공제내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepCalcBasicMgrRetireCalcDeductionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepCalcBasicMgrRetireCalcDeductionList", paramMap);
	}

	/**
	 * 퇴직금기본내역 전근무지사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSepCalcBasicMgrBeforeWorkMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSepCalcBasicMgrBeforeWorkMap", paramMap);
	}

	/**
	 * 퇴직금기본내역 IRP정보 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepCalcBasicMgrIrpInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		dao.delete("deleteSepCalcBasicMgrIrpInfo", paramMap);

		int cnt = dao.update("saveSepCalcBasicMgrIrpInfo", paramMap);

		return cnt;
	}

	/**
	 * 퇴직금기본내역 평균임금TAB 급여 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepCalcBasicMgrAverageIncomePay(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// 퇴직평균임금(급여)[TCPN757] 삭제
			cnt += dao.delete("deleteSepCalcBasicMgrAverageIncomePay", convertMap);
			// 퇴직평균임금(급여)_상세내역 [TCPN758] 삭제
			cnt += dao.delete("deleteSepCalcBasicMgrAverageIncomePayDtl", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			// 퇴직평균임금(급여)[TCPN757] 저장
			cnt += dao.update("saveSepCalcBasicMgrAverageIncomePay", convertMap);
			// 퇴직평균임금(급여)_상세내역 [TCPN758] 삭제
			cnt += dao.delete("deleteSepCalcBasicMgrAverageIncomePayDtl", convertMap);
			// 퇴직평균임금(급여)_상세내역 [TCPN758] 저장
			cnt += dao.update("saveSepCalcBasicMgrAverageIncomePayDtl", convertMap);
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
	public int saveSepCalcBasicMgrAverageIncomeBonus(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepCalcBasicMgrAverageIncomeBonus", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepCalcBasicMgrAverageIncomeBonus", convertMap);
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
	public int saveSepCalcBasicMgrAverageIncomeAnnual(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepCalcBasicMgrAverageIncomeAnnual", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepCalcBasicMgrAverageIncomeAnnual", convertMap);
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
	public Map prcP_CPN_SEP_PAY_MAIN(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("SepCalcBasicMgrP_CPN_SEP_PAY_MAIN", paramMap);
	}
}