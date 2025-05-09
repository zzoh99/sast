package com.hr.hrd.pubc.pubcAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 사내공모신청 세부내역 Service
 *
 * @author
 *
 */
@Service("PubcAppDetService")
public class PubcAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 사내공모신청 세부내역 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPubcAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPubcAppDetMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 사내공모신청 중복체크 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPubcAppDetDupCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPubcAppDetDupCnt", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 사내공모신청 세부내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePubcAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		return dao.update("savePubcAppDet", convertMap);
	}
	
	/**
	 * 사내공모신청 세부내역 저장 (관리자용) Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePubcAppDetAdmin(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		return dao.update("savePubcAppDetAdmin", convertMap);
	}
	
	/**
	 * 사내공모신청 공모팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPubcAppDetPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPubcAppDetPopupList", paramMap);
	}

	public Map<?, ?> getPubcAppDetPubcInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPubcAppDetPubcInfoMap", paramMap);
		Log.Debug();
		return resultMap;
	}

    public Map<?, ?> getPubcAppDetUseInfo(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getPubcAppDetUseInfo", paramMap);
        Log.Debug();
        return resultMap;
    }
}