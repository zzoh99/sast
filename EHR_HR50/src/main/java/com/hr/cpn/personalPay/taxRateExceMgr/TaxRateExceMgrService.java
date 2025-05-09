package com.hr.cpn.personalPay.taxRateExceMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 세율예외자관리 Service
 * 
 * @author 이름
 *
 */
@Service("TaxRateExceMgrService")  
public class TaxRateExceMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 세율예외자관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTaxRateExceMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTaxRateExceMgrList", paramMap);
	}	
	/**
	 *  세율예외자관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getTaxRateExceMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTaxRateExceMgrMap", paramMap);
	}
	/**
	 * 세율예외자관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTaxRateExceMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTaxRateExceMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTaxRateExceMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}



	
	/**세율예외자관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateTaxRateExceMgrEdate(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateTaxRateExceMgrEdate", paramMap);
	}
}