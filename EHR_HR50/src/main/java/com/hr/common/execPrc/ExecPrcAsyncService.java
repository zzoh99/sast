package com.hr.common.execPrc;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import com.hr.common.dao.ProDao;
import com.hr.common.logger.Log;

/**
 * ExecPrc Async Service
 * 프로시저 비동기 실행 서비스
 *
 * @author RYU SIOONG
 *
 */
@Async
@Service("ExecPrcAsyncService")
public class ExecPrcAsyncService{
	
	@Inject
	@Named("ProDao")
	private ProDao proDao;

	/**
	 *  ExecPrc 실행 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> execPrc(String queryId, Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) proDao.excute(queryId, paramMap);
	}

}