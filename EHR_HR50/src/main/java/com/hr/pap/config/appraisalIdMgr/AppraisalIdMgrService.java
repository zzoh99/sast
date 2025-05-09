package com.hr.pap.config.appraisalIdMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가ID관리 Service
 * 
 * @author JSG
 *
 */
@Service("AppraisalIdMgrService")  
public class AppraisalIdMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	
	/**
	 *  평가ID관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppraisalIdMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppraisalIdMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 *  평가ID관리 MAX 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppraisalIdMgrCodeSeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppraisalIdMgrCodeSeq", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 *  평가ID관리 DEL CHECK 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppraisalIdMgrDelCheck(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAppraisalIdMgrDelCheck", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 평가ID관리 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppraisalIdMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppraisalIdMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가ID관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppraisalIdMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppraisalIdMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가ID관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppraisalIdMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppraisalIdMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 상세일정 저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppraisalIdMgrTab1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppraisalIdMgrTab1", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppraisalIdMgrTab1", convertMap);
			
			// clob 형식 저장
			List<Map<String, Object>> list = (List<Map<String, Object>>)convertMap.get("insertRows");
			for(int i=0; i<list.size(); i++) {
				Map<String, Object> map = list.get(i);
				if (map.get("content") != ""  && map.get("content") != null) {
					map.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
					saveAppraisalIdMgrTab1Guide(map);
				}
			}
		}
		
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 상세 가이드 clob저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppraisalIdMgrTab1Guide(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.updateClob("saveAppraisalIdMgrTab1Guide", convertMap);
		return cnt;
	}	
}