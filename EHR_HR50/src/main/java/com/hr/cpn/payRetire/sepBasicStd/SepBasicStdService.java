package com.hr.cpn.payRetire.sepBasicStd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직금기준사항관리 Service
 *
 * @author JM
 *
 */
@Service("SepBasicStdService")
public class SepBasicStdService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직금기준사항관리 퇴직소득공제기준 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepBasicStdIncomeDeductionStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepBasicStdIncomeDeductionStdList", paramMap);
	}

	/**
	 * 퇴직금기준사항관리 퇴직누진근속기준 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepBasicStdProgressiveServiceStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepBasicStdProgressiveServiceStdList", paramMap);
	}

	/**
	 * 퇴직금기준사항관리 퇴직소득공제기준 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepBasicStdIncomeDeductionStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepBasicStdIncomeDeductionStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepBasicStdIncomeDeductionStd", convertMap);
		}

		return cnt;
	}

	/**
	 * 퇴직금기준사항관리 퇴직누진근속기준 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepBasicStdProgressiveServiceStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepBasicStdProgressiveServiceStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepBasicStdProgressiveServiceStd", convertMap);
		}

		return cnt;
	}

	/**
	 * 퇴직금기준사항관리 퇴직소득공제기준 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteSepBasicStdIncomeDeductionStd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.delete("deleteSepBasicStdIncomeDeductionStd", paramMap);
	}
}