package com.hr.eis.empSituation.retEmpHisSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 *  Service
 * 
 * @author JSG
 *
 */
@Service("RetEmpHisStaService")  
public class RetEmpHisStaService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 *  다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetEmpHisStaList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetEmpHisStaList1", paramMap);
	}
	
	/**
	 *  다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetEmpHisStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetEmpHisStaList2", paramMap);
	}
}