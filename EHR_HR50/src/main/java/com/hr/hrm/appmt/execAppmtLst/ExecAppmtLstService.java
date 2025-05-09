package com.hr.hrm.appmt.execAppmtLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * execAppmtLst Service
 *
 * @author EW
 *
 */
@Service("ExecAppmtLstService")
public class ExecAppmtLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * execAppmtLst 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExecAppmtLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExecAppmtLstList", paramMap);
	}

	/**
	 * execAppmtLst 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExecAppmtLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExecAppmtLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveExecAppmtLst", convertMap);
		}

		return cnt;
	}
	/**
	 * execAppmtLst 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getExecAppmtLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getExecAppmtLstMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
