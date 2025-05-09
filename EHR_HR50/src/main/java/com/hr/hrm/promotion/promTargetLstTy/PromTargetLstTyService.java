package com.hr.hrm.promotion.promTargetLstTy;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진대상자명단 Service
 *
 * @author bckim
 *
 */
@Service("PromTargetLstTyService")
public class PromTargetLstTyService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 승진급대상자 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromTargetLstTyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromTargetLstTyList", paramMap);
	}
	
	/**
	 * 승진급대상자 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromTargetLstTy(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromTargetLstTy", convertMap);
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromTargetLstTy", convertMap);
		}
		
		Log.Debug();
		
		return cnt;
	}	
	
	/**
	 * 승진대상자명단(대상자생성) 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prchrmPrmCreate(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prchrmPrmCreate", paramMap);
	}

	/**
	 * 가발령처리 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcHrmPrmpostCreate(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcHrmPrmpostCreate", paramMap);
	}
}