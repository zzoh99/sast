package com.hr.hrd.incoming.incomingMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 후임자관리 Service
 *
 * @author
 *
 */
@Service("IncomingMgrService")
public class IncomingMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  후임자관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getIncomingMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getIncomingMgrList", paramMap);
	}
	
	/**
	 *  후임자관리 Popup 인사정보 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getIncomingMgrPopupHrInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getIncomingMgrPopupHrInfoMap", paramMap);
	}
	
	/**
	 *  후임자관리 Popup 인사정보-학력 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getIncomingMgrPopupHrInfoSchList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getIncomingMgrPopupHrInfoSchList", paramMap);
	}
	
	/**
	 *  후임자관리 Popup 평가결과 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getIncomingMgrPopupEvalResultList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getIncomingMgrPopupEvalResultList", paramMap);
	}
	
	/**
	 *  후임자관리 Popup 평판 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getIncomingMgrPopupReputationMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getIncomingMgrPopupReputationMap", paramMap);
	}

	public int saveIncomingMgrPopup(Map<?, ?> paramMap) throws Exception {
		
		String incomId 		= (String)paramMap.get("incomId");
		String extIncomYn 	= (String)paramMap.get("extIncomYn");
		
		int cnt = 0;
		
		if("".equals(incomId) && !"Y".equals(extIncomYn)) {
			cnt += dao.delete("deleteIncomingMgrPopup", paramMap);
		} else {
			cnt += dao.update("saveIncomingMgrPopup", paramMap);	
		}
		
		return cnt;
	}
	
}
