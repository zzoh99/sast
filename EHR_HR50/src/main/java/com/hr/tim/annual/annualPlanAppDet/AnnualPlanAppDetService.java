package com.hr.tim.annual.annualPlanAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연차휴가계획신청신청 Service
 *
 * @author bckim
 *
 */
@Service("AnnualPlanAppDetService")
public class AnnualPlanAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연차휴가계획신청신청 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualPlanAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualPlanAppDetList", paramMap);
	}
	
	/**
	 * 연차휴가계획신청팝업 중복 체크 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getAnnualPlanAppDetDupCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAnnualPlanAppDetDupCheck", paramMap);
	}
	
	/**
	 * 연차휴가계획신청팝업 중복 체크 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getAnnualPlanAppDetAbleCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAnnualPlanAppDetAbleCheck", paramMap);
	}
	
	/**
	 * 연차계획기준에 따른 연차일수정보 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getAnnualPlanInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAnnualPlanInfo", paramMap);
	}
	
	/**
	 * 연차계획기준 중복체크 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<String, Object> getAnnualPlanAppDetPreAppliedPlan(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("getAnnualPlanAppDetPreAppliedPlan", paramMap);
	}
	
	/**
	 * 연차휴가계획신청신청 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualPlanStandardLast(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAnnualPlanStandardLast", paramMap);
	}
	
	public Map getAnnualPlanAppDetInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAnnualPlanAppDetInfo", paramMap);
	}

	public Map<?, ?> getAnnualPlanAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAnnualPlanAppDetMap", paramMap);
	}
	/**
	 *  연차휴가계획신청신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnnualPlanAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAnnualPlanAppDet", convertMap);
			if(cnt < 1){
				return cnt;
			}
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt=0;
			cnt += dao.update("saveAnnualPlanAppDet", convertMap);
			if(cnt < 1){
				return cnt; 
			}
		}
		Log.Debug();
		return cnt;
	}

	/**
	 *  연차휴가계획신청신청 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnnualPlanCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveAnnualPlanCnt", paramMap);
		if(cnt < 1){
			return cnt;
		}

		Log.Debug();
		return cnt;
	}

}