package com.hr.hrd.pubc.pubcApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 사내공모승인 Service
 *
 * @author EW
 *
 */
@Service("PubcAprService")
public class PubcAprService{

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
	public List<?> getPubcAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPubcAprList", paramMap);
	}

	/**
	 * 사내공모선정 신청자 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPubcAprList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPubcAprList2", paramMap);
	}

	
	/**
	 * 사내공모선정 신청자 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePubcApr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePubcApr2", convertMap);
		}

		return cnt;
	}
}
