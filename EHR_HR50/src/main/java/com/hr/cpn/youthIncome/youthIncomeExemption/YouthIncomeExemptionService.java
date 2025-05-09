package com.hr.cpn.youthIncome.youthIncomeExemption;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * youthIncomeExemption Service
 *
 * @author EW
 *
 */
@Service("YouthIncomeExemptionService")
public class YouthIncomeExemptionService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * youthIncomeExemption 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getYouthIncomeExemptionList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getYouthIncomeExemptionList", paramMap);
	}

	/**
	 * youthIncomeExemption 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveYouthIncomeExemption(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteYouthIncomeExemption", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveYouthIncomeExemption", convertMap);
		}

		return cnt;
	}
	/**
	 * youthIncomeExemption 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getYouthIncomeExemptionMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getYouthIncomeExemptionMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
