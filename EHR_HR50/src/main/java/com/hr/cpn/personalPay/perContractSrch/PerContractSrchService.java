package com.hr.cpn.personalPay.perContractSrch;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 급여계약서 Service
 * 
 * @author JSG
 *
 */
@Service("PerContractSrchService")  
public class PerContractSrchService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 급여계약서 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerContractSrchList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerContractSrchList", paramMap);
	}	
	/**
	 *  급여계약서 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPerContractSrchMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPerContractSrchMap", paramMap);
	}
	/**
	 * 급여계약서 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerContractSrch(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePerContractSrch", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	/**
	 * 급여계약서 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePerContractSrch(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePerContractSrch", paramMap);
	}
}