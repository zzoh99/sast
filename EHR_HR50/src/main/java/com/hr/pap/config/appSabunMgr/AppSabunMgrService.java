package com.hr.pap.config.appSabunMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 평가ID관리 Service
 * 
 * @author JSG
 *
 */
@Service("AppSabunMgrService")  
public class AppSabunMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	
	/**
	 * 평가ID관리 생성 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertAppSabunMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.create("insertAppSabunMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가ID관리 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAppSabunMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateAppSabunMgr", paramMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 평가ID관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteAppSabunMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.delete("deleteAppSabunMgr", paramMap);
		Log.Debug();
		return cnt;
	}
}