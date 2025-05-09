package com.hr.cpn.payApp.etcPayAppMgr;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 기타지급승인관리 Service
 *
 * @author YSH
 *
 */
@Service("EtcPayAppMgrService")
public class EtcPayAppMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 기타지급승인관리  Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEtcPayApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		// master 테이블 갱신		
		cnt = dao.update("updateEtcPayAppMgr", convertMap);
		
		// 결재 테이블 갱신
		cnt += dao.update("updateEtcPayAppMgrThri", convertMap);

		Log.Debug();
		return cnt;
	}

}