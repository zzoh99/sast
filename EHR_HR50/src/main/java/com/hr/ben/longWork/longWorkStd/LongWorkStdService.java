package com.hr.ben.longWork.longWorkStd;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근속포상기준관리 Service
 *
 * @author EW
 *
 */
@Service("LongWorkStdService")
public class LongWorkStdService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근속포상기준관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLongWorkStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLongWorkStdList", paramMap);
	}

	/**
	 * 근속포상기준관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLongWorkStd(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLongWorkStd", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLongWorkStd", convertMap);
		}

		return cnt;
	}
	/**
	 * 근속포상기준관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getLongWorkStdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getLongWorkStdMap", paramMap);
		Log.Debug();
		return resultMap;
	}

}
