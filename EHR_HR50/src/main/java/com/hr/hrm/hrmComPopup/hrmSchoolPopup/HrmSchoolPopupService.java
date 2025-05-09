package com.hr.hrm.hrmComPopup.hrmSchoolPopup;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * hrmSchoolPopup Service
 *
 * @author EW
 *
 */
@Service("HrmSchoolPopupService")
public class HrmSchoolPopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * hrmSchoolPopup 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmSchoolPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmSchoolPopupList", paramMap);
	}

	/**
	 * hrmSchoolPopup 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHrmSchoolPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHrmSchoolPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHrmSchoolPopup", convertMap);
		}

		return cnt;
	}
	/**
	 * hrmSchoolPopup 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHrmSchoolPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getHrmSchoolPopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
