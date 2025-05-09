package com.hr.ben.benefitBasis.socInsMultiMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 사회보험 취득신고 Service
 *
 * @author JM
 *
 */
@Service("SocInsMultiMgrService")
public class SocInsMultiMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 국민연금 기본내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSocInsMultiMgrListLeft(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSocInsMultiMgrListLeft", paramMap);
	}
	
	/**
	 * 국민연금 기본내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSocInsMultiMgrListRightTop(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSocInsMultiMgrListRightTop", paramMap);
	}
	
	/**
	 * 국민연금 기본내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSocInsMultiMgrListRightMiddle(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSocInsMultiMgrListRightMiddle", paramMap);
	}
	
	/**
	 * 국민연금 기본내역 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSocInsMultiMgrListRightBottom(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSocInsMultiMgrListRightBottom", paramMap);
	}
	
	/**
	 * getSocInsMultiAcqMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSocInsMultiAcqMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSocInsMultiAcqMgr", paramMap);
	}
	
	/**
	 * 국민연금 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSocInsMultiMgrRightTop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSocInsMultiMgrRightTop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSocInsMultiMgrRightTop", convertMap);
		}

		return cnt;
	}
	
	/**
	 * 고용보험 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSocInsMultiMgrRightMiddle(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSocInsMultiMgrRightMiddle", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSocInsMultiMgrRightMiddle", convertMap);
		}
		
		return cnt;
	}
	
	/**
	 * 산재보험 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSocInsMultiMgrRightBottom(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSocInsMultiMgrRightBottom", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSocInsMultiMgrRightBottom", convertMap);
		}
		
		return cnt;
	}
	
	/**
	 * 국민연금 기본내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveNspStaPenMgrBasic(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveNspStaPenMgrBasic", convertMap);
		}

		return cnt;
	}

	/**
	 * 건강보험 기본내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveNhsHealthInsMgrBasic(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveNhsHealthInsMgrBasic", convertMap);
		}

		return cnt;
	}

	/**
	 * 고용보험 기본내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveIeiEmpInsMgrBasic(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveIeiEmpInsMgrBasic", convertMap);
		}

		return cnt;
	}

}