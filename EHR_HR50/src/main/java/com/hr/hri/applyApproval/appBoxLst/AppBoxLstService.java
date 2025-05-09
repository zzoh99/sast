package com.hr.hri.applyApproval.appBoxLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * appBoxLst Service
 *
 * @author EW
 *
 */
@Service("AppBoxLstService")
public class AppBoxLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * appBoxLst 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppBoxLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppBoxLstList", paramMap);
	}
	
	public List<?> getAppBoxLstApplCdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppBoxLstApplCdList", paramMap);
	}

	/**
	 * appBoxLst 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppBoxLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppBoxLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppBoxLst", convertMap);
		}

		return cnt;
	}
	/**
	 * appBoxLst 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAppBoxLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppBoxLstMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
