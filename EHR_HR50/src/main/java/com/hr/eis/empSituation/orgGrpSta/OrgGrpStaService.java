package com.hr.eis.empSituation.orgGrpSta;
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
@Service("OrgGrpStaService")  
public class OrgGrpStaService{
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
	public List<?> getOrgGrpStaList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgGrpStaList1", paramMap);
	}
	
	/**
	 *  다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgGrpStaList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgGrpStaList2", paramMap);
	}
	
	public List<?> getSheetHeaderCnt1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getSheetHeaderCnt1 invoke", paramMap);
	}
}