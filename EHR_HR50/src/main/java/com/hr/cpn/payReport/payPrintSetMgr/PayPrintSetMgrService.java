package com.hr.cpn.payReport.payPrintSetMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 급/상여대장 항목관리 Service
 * 
 * @author 이름
 *
 */
@Service("PayPrintSetMgrService")  
public class PayPrintSetMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 급/상여대장 항목관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayPrintSetMgrFirstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayPrintSetMgrFirstList", paramMap);
	}	
	
	/**
	 * 급/상여대장 항목관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayPrintSetMgrSecondList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayPrintSetMgrSecondList", paramMap);
	}	
	
	/**
	 *  급/상여대장 항목관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPayPrintSetMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPayPrintSetMgrMap", paramMap);
	}
	/**
	 * 급/상여대장 항목관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayPrintSetMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			// Detail 
			cnt += dao.delete("deletePayPrintSetMgrFirstDetail", convertMap);
			// Master
			cnt += dao.delete("deletePayPrintSetMgrFirst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayPrintSetMgrFirst", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 급/상여대장 항목관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayPrintSetMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayPrintSetMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayPrintSetMgrSecond", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 급/상여대장 항목관리 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertPayPrintSetMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertPayPrintSetMgr", paramMap);
	}
	/**
	 * 급/상여대장 항목관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updatePayPrintSetMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updatePayPrintSetMgr", paramMap);
	}
	/**
	 * 급/상여대장 항목관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePayPrintSetMgrFirst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePayPrintSetMgrFirst", paramMap);
	}
	
	/**
	 * 급/상여대장 항목관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePayPrintSetMgrSecond(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePayPrintSetMgrSecond", paramMap);
	}
}