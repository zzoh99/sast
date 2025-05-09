package com.hr.cpn.personalPay.payPeakTargetMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 임금피크대상자 Service
 * 
 * @author 이름
 *
 */
@Service("PayPeakTargetMgrService")  
public class PayPeakTargetMgrService{
	
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 임금피크대상자 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayPeakTargetMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayPeakTargetMgrList", paramMap);
	}
	
	/**
	 *  임금피크대상자 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPayPeakTargetMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPayPeakTargetMgrMap", paramMap);
	}
	
	/**
	 * 임금피크대상자 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayPeakTargetMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayPeakTargetMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayPeakTargetMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 임금피크대상자생성 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcCreatePayPeakTarget(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcCreatePayPeakTarget", paramMap);
	}
}