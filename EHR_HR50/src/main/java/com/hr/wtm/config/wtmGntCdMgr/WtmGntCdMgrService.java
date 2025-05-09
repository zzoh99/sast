package com.hr.wtm.config.wtmGntCdMgr;

import com.hr.common.code.CommonCodeService;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.*;

/**
 * 근태코드관리 Service
 *
 * @author bckim
 *
 */
@Service
public class WtmGntCdMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	@Autowired
	private CommonCodeService commonCodeService;

	/**
	 * 근태코드 목록 조회
	 */
	public List<Map<String, Object>> getWtmGntCdMgrList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getWtmGntCdMgrList", paramMap);
	}

	/**
	 * 대표코드 설정 중복체크
	 */
	public Map<?, ?> getWtmGntCdMgrDupCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getWtmGntCdMgrDupCnt", paramMap);
	}

	/**
	 * 근태코드관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmGntCdMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("saveWtmGntCdMgr", convertMap);
		return cnt;
	}

	/**
	 * 근태코드관리 순서 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWtmGntCdSeq(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWtmGntCdSeq", convertMap);
		}
		return cnt;
	}

	/**
	 * 근태코드관리 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWtmGntCdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt = dao.delete("deleteWtmGntCdMgr", convertMap);
		}
		return cnt;
	}

	/**
	 * 근태코드관리 전년도 복사 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int copyHolidayMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		dao.delete("deleteHolidayMgrAll", paramMap);
		int cnt = dao.create("copyHolidayMgr", paramMap);
		
		return cnt;
	}

	public List<?> getWtmGntCdMgrById(Map<String, Object> paramMap) throws Exception {
		return (List<?>) dao.getList("getWtmGntCdMgrById", paramMap);
	}
}