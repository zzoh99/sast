package com.hr.hrm.hrmComPopup.hrmDigitalSignPopup;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * hrmDigitalSignPopup Service
 *
 * @author EW
 *
 */
@Service("HrmDigitalSignPopupService")
public class HrmDigitalSignPopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * hrmDigitalSignPopup 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHrmDigitalSignPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmDigitalSignPopupList", paramMap);
	}

	/**
	 * hrmDigitalSignPopup 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHrmDigitalSignPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHrmDigitalSignPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHrmDigitalSignPopup", convertMap);
		}

		return cnt;
	}
	/**
	 * hrmDigitalSignPopup 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHrmDigitalSignPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getHrmDigitalSignPopupMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
