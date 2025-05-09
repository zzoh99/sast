package com.hr.common.popup.childcareFamPopup;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * childcareFamPopup Service
 *
 * @author EW
 *
 */
@Service("ChildcareFamPopupService")
public class ChildcareFamPopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * childcareFamPopup 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getChildcareFamPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getChildcareFamPopupList", paramMap);
	}

	/**
	 * childcareFamPopup 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveChildcareFamPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteChildcareFamPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveChildcareFamPopup", convertMap);
		}

		return cnt;
	}
	/**
	 * childcareFamPopup 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getChildcareFamPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getChildcareFamPopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
