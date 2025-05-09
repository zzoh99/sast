package com.hr.common.upload.outerTry;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("OuterTryService")
public class OuterTryService{

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 사진 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> EmpPhoto(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("EmpPhoto", paramMap);
	}


	/**
	 * 조직사진 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> OrgPhoto(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("OrgPhoto", paramMap);
	}	
	
	
	
	public Map<?, ?> getThrm911(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getThrm911", paramMap);
	}
	
	public Map<?, ?> getTorg903(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getTorg903", paramMap);
	}

	public Map<?, ?> getLayoutThumbnail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getLayoutThumbnail", paramMap);
	}
}