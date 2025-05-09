package com.hr.cpn.payBonus.bonusConfirm1;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * BonusConfirm1 Service
 *
 * @author EW
 *
 */
@Service("BonusConfirm1Service")
public class BonusConfirm1Service{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * BonusConfirm1 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBonusConfirm1List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
            return (List<?>) dao.getList("getBonusConfirm1List", paramMap);
	}

	/**
	 * BonusConfirm1 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBonusConfirm1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBonusConfirm1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBonusConfirm1", convertMap);
		}

		return cnt;
	}

	/**
	 * BonusConfirm1 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getBonusConfirm1Map(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getBonusConfirm1Map", paramMap);
		Log.Debug();
		return resultMap;
	}
}
