package com.hr.pap.appCompetency.compAppraisalIDMng;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 다면평가ID관리 Service
 *
 * @author EW
 *
 */
@Service("CompAppraisalIDMngService")
public class CompAppraisalIDMngService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 다면평가ID관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCompAppraisalIDMngList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCompAppraisalIDMngList", paramMap);
	}

	/**
	 * 다면평가ID관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCompAppraisalIDMng(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteCompAppraisalIDMng", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveCompAppraisalIDMng", convertMap);
		}

		return cnt;
	}
	/**
	 * 다면평가ID관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCompAppraisalIDMngMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getCompAppraisalIDMngMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 다면평가ID관리 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> compAppraisalIDMngPrc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("compAppraisalIDMngPrc", paramMap);
	}

	/**
	 * 리더십진단대상자 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPeopleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppPeopleList", paramMap);
	}
}
