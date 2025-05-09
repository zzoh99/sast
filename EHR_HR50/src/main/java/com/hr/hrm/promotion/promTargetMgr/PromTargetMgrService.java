package com.hr.hrm.promotion.promTargetMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진급대상자관리 Service
 *
 * @author EW
 *
 */
@Service("PromTargetMgrService")
public class PromTargetMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 승진급대상자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromTargetMgrLoadList(Map<?, ?> paramMap) throws Exception { 
		Log.Debug();
		return (List<?>) dao.getList("getPromTargetMgrLoadList", paramMap);
	}

	/**
	 * 승진급대상자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromTargetMgrList(Map<?, ?> paramMap) throws Exception { 
		Log.Debug();
		return (List<?>) dao.getList("getPromTargetMgrList", paramMap);
	}
	
	/**
	 * 승진급대상자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromTargetMgrChoPopList(Map<?, ?> paramMap) throws Exception { 
		Log.Debug();
		return (List<?>) dao.getList("getPromTargetMgrChoPopList", paramMap);
	}
	
	/**
	 * 승진급대상자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromTargetMgrSimPopList(Map<?, ?> paramMap) throws Exception { 
		Log.Debug();
		return (List<?>) dao.getList("getPromTargetMgrSimPopList", paramMap);
	}
	
	/**
	 * 승진급대상자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromTargetMgrLoad(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
			cnt += dao.delete("deletePromTargetMgrLoad", convertMap);
			cnt += dao.update("savePromTargetMgrLoad", convertMap);
		return cnt;
	}

	/**
	 * 승진급대상자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromTargetMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromTargetMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			
			List<?> list = (List<?>)convertMap.get("mergeRows");
			
			for ( int i=0; i < list.size(); i++ ) {
				
				HashMap<String, String> map = (HashMap<String, String>) list.get(i);
				
				String appmtYn = (String) map.get("appmtYn");
				
				System.out.println("====================================================================");
				System.out.println(appmtYn);
				
				if ( "Y".equals(appmtYn) ) {
					
					String proYmd = (String) map.get("proYmd");
					String sabun  = (String) map.get("sabun");
					String ordTypeCd = (String) map.get("ordTypeCd");
					String ordDetailCd = (String) map.get("ordDetailCd");
					String ordYmd = (String) map.get("ordYmd");
					
					HashMap<String, String> returnMap = new HashMap<String, String>();
					
					returnMap.put("ssnEnterCd", (String)convertMap.get("ssnEnterCd"));
					returnMap.put("proYmd", proYmd);
					returnMap.put("sabun", sabun);
					returnMap.put("ordtypeCd", ordTypeCd);
					returnMap.put("ordDetailCd", ordDetailCd);
					returnMap.put("ordYmd", ordYmd);
					returnMap.put("ssnSabun", (String)convertMap.get("ssnSabun"));
					
					System.out.println("returnMap : " + returnMap.toString());
					
					dao.excute("savePromTargetMgrTHRM221", returnMap);
				}
				
			}
			
			cnt += dao.update("savePromTargetMgr", convertMap);
		}

		return cnt;
	}
	
	/**
	 * 승진급대상자관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPromTargetMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPromTargetMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 승진 대상자 생성
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */

	public Map prcPromTargetMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcPromTargetMgr", paramMap);
	}

}
