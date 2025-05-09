package com.hr.hrm.psnalInfo.psnalAssurance;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalAssurance Service
 *
 * @author EW
 *
 */
@Service("PsnalAssuranceService")
public class PsnalAssuranceService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getPsnalAssuranceWarrantyList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalAssuranceWarrantyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalAssuranceWarrantyList", paramMap);
	}
	
	/**
	 * getPsnalAssuranceWarrantyUserList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalAssuranceWarrantyUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalAssuranceWarrantyUserList", paramMap);
	}

	/**
	 * savePsnalAssuranceWarranty 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalAssuranceWarranty(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalAssuranceWarranty", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalAssuranceWarranty", convertMap);
		}

		return cnt;
	}
	
	/**
	 * savePsnalAssuranceWarrantyUser 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalAssuranceWarrantyUser(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalAssuranceWarrantyUser", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalAssuranceWarrantyUser", convertMap);
		}
		
		return cnt;
	}
	
	/**
	 * psnalAssurance 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalAssuranceMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalAssuranceMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
