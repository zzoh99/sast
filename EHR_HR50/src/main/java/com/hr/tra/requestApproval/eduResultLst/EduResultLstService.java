package com.hr.tra.requestApproval.eduResultLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.dao.ProDao;
import com.hr.common.logger.Log;

/**
 * eduResultLst Service
 *
 * @author EW
 *
 */
@Service("EduResultLstService")
public class EduResultLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ProDao")
	private ProDao proDao;

	/**
	 * eduResultLst 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduResultLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduResultLstList", paramMap);
	}

	/**
	 * eduResultLst 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduResultLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduResultLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduResultLst", convertMap);
		}

		return cnt;
	}
	/**
	 * eduResultLst 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEduResultLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEduResultLstMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
