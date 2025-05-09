package com.hr.hrd.pubc.pubcMgrChief;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 사내공모신청자(부서장) Service
 *
 * @author EW
 *
 */
@Service("PubcMgrChiefService")
public class PubcMgrChiefService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 사내공모선정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPubcMgrChiefList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPubcMgrChiefList", paramMap);
	}

	/**
	 * 사내공모선정 신청자 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPubcMgrChiefList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPubcMgrChiefList2", paramMap);
	}

	
	/**
	 * 사내공모선정 신청자 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePubcMgrChief2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePubcMgrChief2", convertMap);
		}

		return cnt;
	}
}
