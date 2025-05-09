package com.hr.hrd.selfDevelopment.selfDevelopmentEduConn;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 근무조관리 Service
 * 
 * @author jcy
 *
 */
@Service("SelfDevelopmentEducationConnectService")
public class SelfDevelopmentEduConnService {
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * workGrpMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHopeEducationList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHopeEducationList", paramMap);
	}
	
	/**
	 * workGrpMgr 2 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHopePersonList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHopePersonList", paramMap);
	}


	public int saveEducationYn(Map<?, ?> convertMap) throws Exception {

		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEducationYn", convertMap);
		}

		return cnt;
	}
	
}