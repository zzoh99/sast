package com.hr.ben.scholarship.schAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 학자금신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("SchAppDetService")
public class SchAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 화면구성 정보 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getUiInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map)dao.getMap("getUiInfo", paramMap);
	}
	
	/**
	 * 신청자 정보 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getSchAppDetUserInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map)dao.getMap("getSchAppDetUserInfoMap", paramMap);
	}
	
	/**
	 * 결재선 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map getSchAppDetApplOrgLvl(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSchAppDetApplOrgLvl", paramMap);
	}
	
	/**
	 * 신청기준 목록 조회 Serivce
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List getSchAppDetStdDataList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List)dao.getList("getSchAppDetStdDataList", paramMap);
	}

}