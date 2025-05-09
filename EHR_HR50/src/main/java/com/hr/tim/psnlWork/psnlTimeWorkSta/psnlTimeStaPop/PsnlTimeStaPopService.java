package com.hr.tim.psnlWork.psnlTimeWorkSta.psnlTimeStaPop;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnlTimeStaPop Service
 *
 * @author EW
 *
 */
@Service("PsnlTimeStaPopService")
public class PsnlTimeStaPopService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnlTimeStaPop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlTimeStaPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlTimeStaPopList", paramMap);
	}
	
	/**
	 * psnlAnnualStaPop 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlAnnualStaPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlAnnualStaPopList", paramMap);
	}

	/**
	 * psnlTimeStaPop 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnlTimeStaPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnlTimeStaPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnlTimeStaPop", convertMap);
		}

		return cnt;
	}
	/**
	 * psnlTimeStaPop 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnlTimeStaPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnlTimeStaPopMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
