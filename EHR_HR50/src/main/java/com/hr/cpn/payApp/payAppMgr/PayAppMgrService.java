package com.hr.cpn.payApp.payAppMgr;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여지급승인관리 Service
 *
 * @author YSH
 *
 */
@Service("PayAppMgrService")
public class PayAppMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 급여지급승인 전자서명 데이터 저장  Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayAppMgrSignData(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("savePayAppMgrSignData", paramMap);
		return cnt;
	}

}