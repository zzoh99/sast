package com.hr.ben.club.clubpayAppDet;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 동호회 지원금 신청 Service
 */
@Service("ClubpayAppDetService")
public class ClubpayAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public int saveClubpayAppDet(Map<?, ?> paramMap, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
		
		dao.delete("deleteClubpayAppDetaActInfo", paramMap);
	    if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
	        dao.update("saveClubpayAppDetaActInfo", convertMap);
	    }
		cnt = dao.update("saveClubpayAppDet", paramMap);

		return cnt;
	}
	
	public int deleteClubpayAppDetaActInfo(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteClubpayAppDetaActInfo", convertMap);
		}

		return cnt;
	}
	
}