package com.hr.cpn.payReport.payTaxCertiSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 납세필증명서 Service
 * 
 * @author JSG
 *
 */
@Service("PayTaxCertiStaService")  
public class PayTaxCertiStaService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 납세필증명서 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTaxCertiStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTaxCertiStaList", paramMap);
	}
	
	/**
	 * 납세필증명서 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayTaxCertiSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayTaxCertiSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayTaxCertiSta", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	public Map<?, ?> getPayTaxCertiStaIfrm(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPayTaxCertiStaIfrm", paramMap);
	}

	
	/**
	 * 납세필증명서 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePayTaxCertiSta(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePayTaxCertiSta", paramMap);
	}
}