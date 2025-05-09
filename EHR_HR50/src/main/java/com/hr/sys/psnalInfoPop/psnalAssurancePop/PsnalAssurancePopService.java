package com.hr.sys.psnalInfoPop.psnalAssurancePop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnalAssurancePop Service
 *
 * @author EW
 *
 */
@Service("PsnalAssurancePopService")
public class PsnalAssurancePopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnalAssurancePop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalAssurancePopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalAssurancePopList", paramMap);
	}

	/**
	 * psnalAssurancePop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalAssurancePop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalAssurancePop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalAssurancePop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnalAssurancePop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalAssurancePopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalAssurancePopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
