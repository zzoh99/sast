package com.hr.cpn.payRetire.sepEleLinkCalcMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직항목링크(계산식) Service
 *
 * @author JM
 *
 */
@Service("SepEleLinkCalcMgrService")
public class SepEleLinkCalcMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직항목링크(계산식) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEleLinkCalcMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEleLinkCalcMgrList", paramMap);
	}

	/**
	 * 퇴직항목링크(계산식) 계산식작성 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEleLinkCalcMgrFormulaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEleLinkCalcMgrFormulaList", paramMap);
	}

	/**
	 * 퇴직항목링크(계산식) DB ITEM검색 팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepEleLinkCalcMgrDbItemList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepEleLinkCalcMgrDbItemList", paramMap);
	}

	/**
	 * 퇴직항목링크(계산식) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepEleLinkCalcMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		int formulaCnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepEleLinkCalcMgr", convertMap);

			// 계산식작성 삭제
			formulaCnt += dao.delete("deleteAllSepEleLinkCalcMgrFormula", convertMap);
			if (cnt <= 0 || formulaCnt <= 0) {
				return 0;
			}
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepEleLinkCalcMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * 퇴직항목링크(계산식) 계산식작성 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepEleLinkCalcMgrFormula(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		int cRuleCnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0 ) {
			cnt += dao.delete("deleteSepEleLinkCalcMgrFormula", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0 ) {
			cnt += dao.update("saveSepEleLinkCalcMgrFormula", convertMap);
		}
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0 || ((List<?>)convertMap.get("mergeRows")).size() > 0 ) {
			// 퇴직항목계산식M의 계산식 UPDATE
			cRuleCnt = dao.delete("updateSepEleLinkCalcMgrCRule", convertMap);
			if (cRuleCnt <= 0) {
				return cRuleCnt;
			}
		}

		return cnt;
	}

	/**
	 * 퇴직항목계산식M의 계산식 UPDATE Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateSepEleLinkCalcMgrCRule(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.delete("updateSepEleLinkCalcMgrCRule", paramMap);
	}
}