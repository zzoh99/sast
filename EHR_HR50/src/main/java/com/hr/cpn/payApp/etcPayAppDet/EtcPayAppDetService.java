package com.hr.cpn.payApp.etcPayAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 기타지급신청 세부내역 Service
 *
 * @author  YSH
 *
 */
@Service("EtcPayAppDetService")
public class EtcPayAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 기타지급신청 세부내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEtcPayAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEtcPayAppDetList", paramMap);
	}

	/**
	 * 기타지급신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEtcPayAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		//기타지급신청 Master (TCPN431) 저장
		//cnt += dao.update("insertEtcPayApp", convertMap);
		cnt += dao.update("saveEtcPayApp", convertMap);
		
		//기타지급신청 Detail (TCPN433) 저장
		cnt += dao.update("saveEtcPayAppDet", convertMap);

		Log.Debug();
		return cnt;
	}

    public List<?> getEtcPayAppDetailList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getEtcPayAppDetailList", paramMap);
    }
	
}