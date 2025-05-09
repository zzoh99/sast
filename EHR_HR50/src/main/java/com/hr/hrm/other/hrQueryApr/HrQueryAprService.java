package com.hr.hrm.other.hrQueryApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * hrQueryApr Service
 *
 * @author EW
 *
 */
@Service("HrQueryAprService")
public class HrQueryAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * hrQueryApr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrQueryAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrQueryAprList", paramMap);
	}

	/**
	 * hrQueryApr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHrQueryApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHrQueryApr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHrQueryApr", convertMap);
		}

		return cnt;
	}
	/**
	 * hrQueryApr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHrQueryAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getHrQueryAprMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
