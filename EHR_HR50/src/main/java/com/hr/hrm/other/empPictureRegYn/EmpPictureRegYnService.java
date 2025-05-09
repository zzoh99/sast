package com.hr.hrm.other.empPictureRegYn;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * empPictureRegYn Service
 *
 * @author EW
 *
 */
@Service("EmpPictureRegYnService")
public class EmpPictureRegYnService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * empPictureRegYn 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpPictureRegYnList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpPictureRegYnList", paramMap);
	}

	/**
	 * empPictureRegYn 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpPictureRegYn(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpPictureRegYn", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpPictureRegYn", convertMap);
		}

		return cnt;
	}
	/**
	 * empPictureRegYn 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpPictureRegYnMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmpPictureRegYnMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
