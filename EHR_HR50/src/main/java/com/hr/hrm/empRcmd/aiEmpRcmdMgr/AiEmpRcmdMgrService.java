package com.hr.hrm.empRcmd.aiEmpRcmdMgr;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 인원명부항목정의 Service
 *
 * @author 이름
 *
 */
@Service("AiEmpRcmdMgrService")
public class AiEmpRcmdMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * AiEmpRcmdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAiEmpRcmdMgrType(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAiEmpRcmdMgrType", paramMap);
	}

	/**
	 * AiEmpRcmdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAiEmpRcmdMgrTypeMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAiEmpRcmdMgrTypeMap", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * saveAiEmpRcmdMgrType 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAiEmpRcmdMgrType(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAiEmpRcmdMgrType", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAiEmpRcmdMgrType", convertMap);
		}

		return cnt;
	}

	/**
	 * saveAiEmpRcmdMgrPrompt 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAiEmpRcmdMgrPrompt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("saveAiEmpRcmdMgrPrompt", convertMap);
		return cnt;
	}

	/**
	 * AiEmpRcmdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAiEmpRcmdMgrScoreInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAiEmpRcmdMgrScoreInfo", paramMap);
	}

	/**
	 * saveAiEmpRcmdMgrScoreInfo 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAiEmpRcmdMgrScoreInfo(Map<?, ?> convertMap) throws Exception {
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAiEmpRcmdMgrScoreInfo", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAiEmpRcmdMgrScoreInfo", convertMap);
		}

		return cnt;
	}

}