package com.hr.cpn.payApp.deptPartPayAppMgr;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 수당지급승인관리 Service
 *
 * @author YSH
 *
 */
@Service("DeptPartPayAppMgrService")
public class DeptPartPayAppMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 수당지급승인관리  Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDeptPartPayApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		// master 테이블 갱신		
		cnt = dao.update("updateDeptPartPayAppMgr", convertMap);
		
		// 결재 테이블 갱신
		cnt += dao.update("updateDeptPartPayAppMgrThri", convertMap);

		Log.Debug();
		return cnt;
	}

}