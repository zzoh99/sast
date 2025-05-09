package com.hr.pap.config.appEvalProgressMng;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가대상자생성/관리 Service
 *
 * @author JSG
 *
 */
@Service("AppEvalProgressMngService")
public class AppEvalProgressMngService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인재풀기준 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppEvalProgressMngList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppEvalProgressMngList", paramMap);
	}
	
	/**
	 *  평가진척관리 조회 Service(평가단계별 날짜조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppEvalProgressMngMap1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppEvalProgressMngMap1", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 평가진척관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppEvalProgressMng1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppEvalProgressMng1", convertMap);
		}

		Log.Debug();
		return cnt;
	}
	
	/**
	 * 평가진척관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppEvalProgressMng2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppEvalProgressMng2", convertMap);
		}

		Log.Debug();
		return cnt;
	}	
	
	/**
	 * 평가진척관리 저장(평가마감) Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppEvalProgressMng3(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppEvalProgressMng3", convertMap);
		}

		Log.Debug();
		return cnt;
	}	
	
	/**
	 * 평가마감 - 프로시저(평가마감)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcAppEvalProgressMngFin(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppEvalProgressMngFin", paramMap);
	}
	
	/**
	 * 평가진척관리 리더쉽 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppEvalProgressMngleadership(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("updateRows")).size() > 0){
			cnt += dao.update("saveAppEvalProgressMngleadership", convertMap);
		}
		Log.Debug();
		return cnt;
	}	
	/**
	 * 평가진척관리 리더쉽 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppEvalProgressMngleadership(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("updateRows")).size() > 0){
			cnt += dao.update("deleteAppEvalProgressMngleadership", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}
