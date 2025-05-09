package com.hr.ben.club.clubrefAppDet;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 동호회 재 등록 신청 Service
 *
 * @author bckim
 *
 */
@Service("ClubrefAppDetService")
public class ClubrefAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	public int saveClubrefAppDet(Map<?, ?> paramMap, Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		
		int cnt=0;
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0) {
          //급여공제동의이력 비고 저장
           cnt = dao.update("saveClubrefAppDetMember", convertMap);
        }
        
	    cnt = dao.update("saveClubrefAppDet", paramMap);

		return cnt;
	}
	
}