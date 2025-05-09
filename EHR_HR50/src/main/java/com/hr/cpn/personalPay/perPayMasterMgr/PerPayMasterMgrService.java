package com.hr.cpn.personalPay.perPayMasterMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여기본사항 Service
 *
 * @author JM
 *
 */
@Service("PerPayMasterMgrService")
public class PerPayMasterMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급여기본사항 기본사항TAB 연봉정보 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayMasterMgrAnnualIncomeMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayMasterMgrAnnualIncomeMap", paramMap);
	}

	/**
	 * 급여기본사항 기본사항TAB 과세정보 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayMasterMgrTaxInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayMasterMgrTaxInfoMap", paramMap);
	}

	/**
	 * 급여기본사항 기본사항TAB 수당기준 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayMasterMgrAllowYnInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayMasterMgrAllowYnInfoMap", paramMap);
	}

	/**
	 * 급여기본사항 기본사항TAB 임금피크 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayMasterMgrPeekInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayMasterMgrPeekInfoMap", paramMap);
	}

	/**
	 * 급여기본사항 기본사항TAB 고정수당 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrfixAllowanceList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrfixAllowanceList", paramMap);
	}

	/**
	 * 급여기본사항 기본사항TAB 과세정보 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrTaxInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrTaxInfoList", paramMap);
	}

	/**
	 * 급여기본사항 기본사항TAB 계좌정보 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrAccountInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrAccountInfoList", paramMap);
	}

	/**
	 * 급여기본사항 지급/공제 예외사항TAB 지급 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrPayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrPayList", paramMap);
	}

	/**
	 * 급여기본사항 지급/공제 예외사항TAB 공제 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrDeductionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrDeductionList", paramMap);
	}

	/**
	 * 급여기본사항 연봉이력TAB 연봉이력 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrAnnualIncomeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrAnnualIncomeList", paramMap);
	}

	/**
	 * 급여기본사항 퇴직금중간정산TAB 퇴직금예외기간 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrExceptionTermList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrExceptionTermList", paramMap);
	}

	/**
	 * 급여기본사항 퇴직금중간정산TAB 중간정산내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrInterimPayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrInterimPayList", paramMap);
	}

	/**
	 * 급여기본사항 급여압류TAB 채권현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrBondStateList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrBondStateList", paramMap);
	}

	/**
	 * 급여기본사항 급여압류TAB 공제현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrDeductionStateList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrDeductionStateList", paramMap);
	}

	/**
	 * 급여기본사항 사회보험TAB 현재불입상태 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrPayStatusList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrPayStatusList", paramMap);
	}

	/**
	 * 급여기본사항 사회보험TAB 년도별 건강/요양보험료정산 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrPremiumCalcList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrPremiumCalcList", paramMap);
	}

	/**
	 * 급여기본사항 대출현황TAB 대출현황 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrLoanStateList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrLoanStateList", paramMap);
	}

	/**
	 * 급여기본사항 대출현황TAB 항목별 상환내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerPayMasterMgrRepayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getPerPayMasterMgrRepayList", paramMap);
	}

	/**
	 * 급여기본사항 기본사항TAB 과세정보 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerPayMasterMgrTaxInfo(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0) {
			cnt += dao.delete("deletePerPayMasterMgrTaxInfo", convertMap);

		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
			cnt += dao.update("savePerPayMasterMgrTaxInfo", convertMap);

		}
		if(cnt!=0) {
			cnt += dao.update("updatePerPayMasterMgrTaxInfoEdate", convertMap);
		}

		return cnt;
	}

	/**
	 * 급여기본사항 기본사항TAB 수당기준 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerPayMasterMgrAllowYnInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("savePerPayMasterMgrAllowYnInfo", paramMap);

		return cnt;
	}

	/**
	 * 급여기본사항 기본사항TAB 계좌정보 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerPayMasterMgrAccountInfo(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerPayMasterMgrAccountInfo", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePerPayMasterMgrAccountInfo", convertMap);
		}

		return cnt;
	}

	/**
	 * 급여기본사항 지급/공제 예외사항TAB 지급/공제 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerPayMasterMgrPayDeduction(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerPayMasterMgrPayDeduction", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePerPayMasterMgrPayDeduction", convertMap);
		}

		return cnt;
	}


	/**
	 * 급여기본사항 기본사항TAB 퇴직금추가계액 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerPayMasterMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getPerPayMasterMgrMap", paramMap);
	}

    public List<?> getYearCombo(Map<?, ?> paramMap) throws Exception {
        Log.Debug();

        return (List<?>) dao.getList("getYearCombo", paramMap);
    }

    public List<?> getPerPayMasterMgrSalaryPeak(Map<?, ?> paramMap) throws Exception {
        Log.Debug();

        return (List<?>) dao.getList("getPerPayMasterMgrSalaryPeak", paramMap);
    }

    public List<?> getPerPayMasterMgrSalaryPeakCalc(Map<?, ?> paramMap) throws Exception {
        Log.Debug();

        return (List<?>) dao.getList("getPerPayMasterMgrSalaryPeakCalc", paramMap);
    }

    public int savePerPayMasterMgrSalaryPeak(Map convertMap) throws Exception {
        Log.Debug();
        int cnt = 0;
        if (((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deletePerPayMasterMgrSalaryPeak", convertMap);
        }
        if (((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("savePerPayMasterMgrSalaryPeak", convertMap);
        }

        return cnt;
    }

}