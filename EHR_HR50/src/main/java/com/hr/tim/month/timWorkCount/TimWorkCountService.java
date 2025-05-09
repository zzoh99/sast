package com.hr.tim.month.timWorkCount;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


/**
 * 월근태/근무집계 Service
 *
 * @author bckim
 *
 */
@Service("TimWorkCountService")
public class TimWorkCountService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 월근태/근무집계(마감) 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateTimWorkCountEndYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("updateTimWorkCountEndYn", paramMap);
		return cnt;
	}

	/**
	 * 월근태/근무집계(처리) 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcTimWorkCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		if("app".equals(paramMap.get("gubun"))) {
			return (Map) dao.excute("prcTimWorkCount1", paramMap);
		} else {
			return (Map) dao.excute("prcTimWorkCount2", paramMap);
		}
	}
	
	/**
	 * 작업 도중 로그 파일 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteTSYS906ForTimWorkCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug("deleteTSYS906ForTimWorkCount");
		return dao.delete("deleteTSYS906ForTimWorkCount", paramMap);
	}
	
	/**
	 * timWorkCount 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getTimWorkCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getTimWorkCount", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * timWorkCount 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getTimWorkEndYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getTimWorkEndYn", paramMap);
		Log.Debug();
		return resultMap;
	}

}