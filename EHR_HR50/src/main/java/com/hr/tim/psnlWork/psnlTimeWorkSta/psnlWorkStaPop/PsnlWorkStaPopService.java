package com.hr.tim.psnlWork.psnlTimeWorkSta.psnlWorkStaPop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnlWorkStaPop Service
 *
 * @author EW
 *
 */
@Service("PsnlWorkStaPopService")
public class PsnlWorkStaPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnlWorkStaPop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlWorkStaPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlWorkStaPopList", paramMap);
	}
	
	/**
	 * psnlWorkStaPop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlWorkStaPopHeaderList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlWorkStaPopHeaderList", paramMap);
	}

	/**
	 * psnlWorkStaPop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnlWorkStaPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnlWorkStaPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnlWorkStaPop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnlWorkStaPop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnlWorkStaPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnlWorkStaPopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
