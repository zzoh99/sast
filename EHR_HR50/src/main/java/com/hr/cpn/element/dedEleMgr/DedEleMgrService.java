package com.hr.cpn.element.dedEleMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * dedEleMgr Service
 *
 * @author EW
 *
 */
@Service("DedEleMgrService")
public class DedEleMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * dedEleMgr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDedEleMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDedEleMgrList", paramMap);
	}

	/**
	 * dedEleMgr 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveDedEleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteDedEleMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveDedEleMgr", convertMap);
		}

		return cnt;
	}
	/**
	 * dedEleMgr 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getDedEleMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getDedEleMgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 공제항목관리(연말정산 코드 항목 조회) 팝업 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDedEleMgrPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getDedEleMgrPopupList", paramMap);
	}	
}
