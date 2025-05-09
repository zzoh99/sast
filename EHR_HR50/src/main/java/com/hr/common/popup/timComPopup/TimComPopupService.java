package com.hr.common.popup.timComPopup;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * timComPopup Service
 *
 * @author EW
 *
 */
@Service("TimComPopupService")
public class TimComPopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * timComPopup 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getTimComPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTimComPopupList", paramMap);
	}

	/**
	 * timComPopup 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveTimComPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteTimComPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveTimComPopup", convertMap);
		}

		return cnt;
	}
	/**
	 * timComPopup 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getTimComPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getTimComPopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * timComPopup 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getTimProcessBarComPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getTimProcessBarComPopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
}
