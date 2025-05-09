package com.hr.tim.psnlWork.psnlTimeWorkSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * psnlTimeWorkSta Service
 *
 * @author EW
 *
 */
@Service("PsnlTimeWorkStaService")
public class PsnlTimeWorkStaService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * psnlTimeWorkSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlTimeWorkStaList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlTimeWorkStaList1", paramMap);
	}
	
	/**
	 * psnlTimeWorkSta 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlTimeWorkStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlTimeWorkStaList2", paramMap);
	}

	/**
	 * psnlTimeWorkSta 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnlTimeWorkSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnlTimeWorkSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnlTimeWorkSta", convertMap);
		}

		return cnt;
	}
	
	/**
	 * psnlTimeWorkSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnlTimeWorkStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnlTimeWorkStaMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * psnlTimeWorkSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnlTimeWorkStaYmd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnlTimeWorkStaYmd", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * psnlTimeWorkSta 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnlTimeWorkStaCurrYmd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnlTimeWorkStaCurrYmd", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * getPsnlAnnualStaPopList 다건 조회 Service
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
	 * getPsnlTimeStaPopList 다건 조회 Service
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
	 * getPsnlWorkStaPopHeaderList 다건 조회 Service
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
	 * getPsnlWorkStaPopList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnlWorkStaPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnlWorkStaPopList", paramMap);
	}
}
