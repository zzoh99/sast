package com.hr.cpn.personalPay.exceAllowMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 예외수당/공제관리 Service
 * 
 * @author 이름
 *
 */
@Service("ExceAllowMgrService")  
public class ExceAllowMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 예외수당/공제관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExceAllowMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// Detail 
			cnt += dao.delete("deleteExceAllowMgrFirstDetail", convertMap);
			// Master
			cnt += dao.delete("deleteExceAllowMgrFirst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveExceAllowMgrFirst", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 예외수당/공제관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveExceAllowMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExceAllowMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveExceAllowMgrFirst", convertMap);
			cnt += dao.update("saveExceAllowMgrSecond", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}