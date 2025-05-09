package com.hr.pap.evaluation.appCompMgr;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 역량평가 Service
 *
 */
@Service("AppCompMgrService")
public class AppCompMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
     * 등급별 점수변환
     * 
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public Map<?, ?> getAppCompCdToPoint(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getAppCompCdToPoint", paramMap);
    }
    
	
}
