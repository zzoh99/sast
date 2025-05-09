package com.hr.ben.unempInsurance.empInsMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 고용보험기본사항 Service
 *
 * @author JM
 *
 */
@Service("EmpInsMgrService")
public class EmpInsMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 고용보험기본사항 기본사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpInsMgrBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getEmpInsMgrBasicMap", paramMap);
	}

	/**
	 * 고용보험기본사항 변동내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpInsMgrChangeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getEmpInsMgrChangeList", paramMap);
	}

	/**
	 * 고용보험기본사항 불입내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpInsMgrPaymentList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getEmpInsMgrPaymentList", paramMap);
	}

	/**
	 * 고용보험기본사항 기본사항TAB 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpInsMgrBasic(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("saveEmpInsMgrBasic", paramMap);

		return cnt;
	}

	/**
	 * 고용보험기본사항 변동내역TAB 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpInsMgrChange(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpInsMgrChange", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpInsMgrChange", convertMap);
		}

		return cnt;
	}

	/**
	 * 고용보험기본사항 불입내역TAB 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpInsMgrPayment(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpInsMgrPayment", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpInsMgrPayment", convertMap);
		}

		return cnt;
	}

	/**
	 * 고용보험기본사항 변동내역TAB 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteEmpInsMgrChange(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.delete("deleteEmpInsMgrChange", paramMap);
	}

	/**
	 * 고용보험기본사항 불입내역TAB 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteEmpInsMgrPayment(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.delete("deleteEmpInsMgrPayment", paramMap);
	}

	/**
	 * 본인부담금 가져오기 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpInsMgrF_BEN_NP_SELF_MON(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getEmpInsMgrF_BEN_NP_SELF_MON", paramMap);
	}
}