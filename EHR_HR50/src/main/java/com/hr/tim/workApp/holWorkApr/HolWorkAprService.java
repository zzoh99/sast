package com.hr.tim.workApp.holWorkApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * holWorkApr Service
 *
 * @author EW
 *
 */
@Service("HolWorkAprService")
public class HolWorkAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * holWorkApr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHolWorkAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHolWorkAprList", paramMap);
	}

	/**
	 * holWorkApr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHolWorkApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHolWorkApr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHolWorkApr", convertMap);
		}

		return cnt;
	}
	/**
	 * holWorkApr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHolWorkAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getHolWorkAprMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
