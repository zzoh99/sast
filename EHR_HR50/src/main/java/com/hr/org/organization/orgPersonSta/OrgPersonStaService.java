package com.hr.org.organization.orgPersonSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 조직종합관리 Service
 *
 * @author CBS
 *
 */
@Service("OrgPersonStaService")
public class OrgPersonStaService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * orgCdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgPersonStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgPersonStaList", paramMap);
	}

	/**
	 * orgCdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgPersonStaMeberList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgPersonStaMeberList1", paramMap);
	}

	/**
	 * orgCdMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgPersonStaMeberList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgPersonStaMeberList2", paramMap);
	}

	/**
	 *  임직원비교 프로그램 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getCompareEmpOpenPrgMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getCompareEmpOpenPrgMap", paramMap);
	}

}