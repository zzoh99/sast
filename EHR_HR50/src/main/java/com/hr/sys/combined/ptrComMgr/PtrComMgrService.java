package com.hr.sys.combined.ptrComMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 협력업체관리 Service
 * 
 * @author JSG
 *
 */
@Service("PtrComMgrService")  
public class PtrComMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 협력업체관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPtrComMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPtrComMgrList", paramMap);
	}
	
	/**
	 * 협력업체관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePtrComMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			int tempCnt = 0 ;
			tempCnt += dao.delete("deletePtrComMgr_THRM100", convertMap);
			tempCnt += dao.delete("deletePtrComMgr_THRM151", convertMap);
			tempCnt += dao.delete("deletePtrComMgr_THRM123", convertMap);
			tempCnt += dao.delete("deletePtrComMgr_THRM124", convertMap);
			tempCnt += dao.delete("deletePtrComMgr_TSYS305", convertMap);
			if( tempCnt > 0 )
				cnt ++ ; 
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			int tempCnt = 0 ;
			tempCnt += dao.update("savePtrComMgr_THRM100", convertMap);
			tempCnt += dao.update("savePtrComMgr_THRM151", convertMap);
			tempCnt += dao.update("savePtrComMgr_THRM123", convertMap);
			tempCnt += dao.update("savePtrComMgr_THRM124", convertMap);
			tempCnt += dao.update("savePtrComMgr_TSYS305", convertMap);
			if( tempCnt > 0 )
			cnt ++ ; 
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 협력업체관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePtrComMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePtrComMgr", paramMap);
	}
}