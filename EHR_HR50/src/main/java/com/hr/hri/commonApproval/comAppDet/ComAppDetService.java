package com.hr.hri.commonApproval.comAppDet;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 공통신청 세부내역 Service
 *
 * @author
 *
 */
@Service("ComAppDetService")
public class ComAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	public Map<?, ?> getComAppDetAppType(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getComAppDetAppType", paramMap);
		return resultMap;
	}
	

	public List<?> getSeqList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		
		List<Map<String, Object>> seqList = new ArrayList<Map<String, Object>>();
		seqList = (List<Map<String, Object>>)dao.getList("getComAppDetSeqList", paramMap);
		
		return (List<?>) seqList;
	}

	/**
	 * 공통신청 세부내역 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveComAppDet(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		cnt += dao.update("saveComAppDet", convertMap);
		cnt += dao.update("updateComAppDet", convertMap);
		
		Log.Debug();
		return cnt;
	}
}