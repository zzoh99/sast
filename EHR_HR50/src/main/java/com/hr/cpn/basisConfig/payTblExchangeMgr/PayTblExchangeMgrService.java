package com.hr.cpn.basisConfig.payTblExchangeMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여테이블변경 Service
 *
 * @author EW
 *
 */
@Service("PayTblExchangeMgrService")
public class PayTblExchangeMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 변경내역 Master 작업전 변경내역 Detail 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSearchMDays(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSearchMDays", paramMap);
	}
	
	/**
	 * 변경내역 Master 작업전 변경내역 Detail 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTblExchangeMasterList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTblExchangeMasterList", paramMap);
	}
	
	/**
	 * 변경내역 Master 작업전 변경내역 Detail 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTblExchangeDetailList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayTblExchangeDetailList", paramMap);
	}
	
	
	/**
	 * 변경내역 Master 작업전 변경내역 Detail 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayTblExchangeMasterOperationList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("payTblExchangeMasterOperation", paramMap);
	}
	
	
	/**
	 * PayTblExchangeMaster 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayTblExchangeMaster(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayTblExchangeMaster", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayTblExchangeMaster", convertMap);
		}

		return cnt;
	}

	/**
	 * PayTblExchangeDetail 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayTblExchangeDetail(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayTblExchangeDetail", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayTblExchangeDetail", convertMap);
		}

		return cnt;
	}
	
	/**
	 * procCpnBaseSalchange 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcCpnBaseSalchange(Map<?, ?> paramMap) throws Exception {
		Log.Debug("prcCpnBaseSalchange");
		return (Map) dao.excute("prcCpnBaseSalchange", paramMap);
	}
	
	/**
	 * procCpnBaseSalchange 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcCpnBaseEmpsalUpd(Map<?, ?> paramMap) throws Exception {
		Log.Debug("prcCpnBaseEmpsalUpd");
		return (Map) dao.excute("prcCpnBaseEmpsalUpd", paramMap);
	}
}
