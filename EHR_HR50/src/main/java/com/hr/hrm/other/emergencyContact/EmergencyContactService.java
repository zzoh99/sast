package com.hr.hrm.other.emergencyContact;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * emergencyContact Service
 *
 * @author EW
 *
 */
@Service("EmergencyContactService")
public class EmergencyContactService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * emergencyContact 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmergencyContactList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmergencyContactList", paramMap);
	}

	/**
	 * emergencyContact 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmergencyContact(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmergencyContact", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmergencyContact", convertMap);
		}

		return cnt;
	}
	/**
	 * emergencyContact 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmergencyContactMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmergencyContactMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * emergencyContact Title 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmergencyContacTitletList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmergencyContacTitletList", paramMap);
	}
}
