package com.hr.cpn.payBonus.bonusConfirm2;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * BonusConfirm2 Service
 *
 * @author EW
 *
 */
@Service("BonusConfirm2Service")
public class BonusConfirm2Service{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * BonusConfirm2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBonusConfirm2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
            return (List<?>) dao.getList("getBonusConfirm2List", paramMap);
	}

	/**
	 * BonusConfirm2 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveBonusConfirm2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteBonusConfirm2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveBonusConfirm2", convertMap);
		}

		return cnt;
	}

	/**
	 * BonusConfirm2 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getBonusConfirm2Map(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getBonusConfirm2Map", paramMap);
		Log.Debug();
		return resultMap;
	}
}
