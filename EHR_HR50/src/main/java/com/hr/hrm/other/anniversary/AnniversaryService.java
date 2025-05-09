package com.hr.hrm.other.anniversary;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * anniversary Service
 *
 * @author EW
 *
 */
@Service("AnniversaryService")
public class AnniversaryService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * anniversary 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnniversaryList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnniversaryList", paramMap);
	}

	/**
	 * anniversary 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnniversary(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAnniversary", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAnniversary", convertMap);
		}

		return cnt;
	}
	/**
	 * anniversary 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAnniversaryMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAnniversaryMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
