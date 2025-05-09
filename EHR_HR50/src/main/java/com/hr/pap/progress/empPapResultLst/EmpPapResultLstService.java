package com.hr.pap.progress.empPapResultLst;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 직원평과결과 Service
 * 
 * @author JSG
 *
 */
@Service("EmpPapResultLstService")  
public class EmpPapResultLstService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 *  직원평과결과 조직 조회
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPapOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		List<?> resultList = (List<?>)dao.getList("getPapOrgList", paramMap);
		Log.Debug();
		return resultList;
	}
	
	/**
	 *  평가결과피드백 의견 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getEmpPapResultPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmpPapResultPopMap", paramMap);
	}
}