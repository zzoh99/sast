package com.hr.common.execPrc;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.ProDao;
import com.hr.common.logger.Log;

/**
 * ExecPrc Service
 *
 * @author RYU SIOONG
 *
 */
@Service("ExecPrcService")
public class ExecPrcService{
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
	public Map<?, ?> execPrc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) proDao.excute(paramMap.get("cmd").toString(), paramMap);
	}

}