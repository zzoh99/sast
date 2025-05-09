package com.hr.hrd.core2.coreSelect;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import java.util.Collections;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 핵심인재선정 Service
 *
 * @author JSG
 *
 */
@Service("CoreSelectService")
public class CoreSelectService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  핵심인재후보추천자 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<Map<String, Object>> getCoreSelectList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<Map<String, Object>>) dao.getList("getCoreSelectList", paramMap);
	}

	/**
	 *  핵심인재 Pool-In 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCoreSelectPoolIn(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if(!((List<?>) convertMap.get("mergeRows")).isEmpty()){
			cnt += dao.update("saveCoreSelectPoolIn", convertMap);
		}
		return cnt;
	}

	/**
	 * 핵심인재 다건조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCoreSelectList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCoreSelectList2", paramMap);
	}

	/**
	 *  핵심인재 Pool-Out 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCoreSelectPoolOut(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if(!((List<?>) convertMap.get("mergeRows")).isEmpty()){
			cnt += dao.update("saveCoreSelectPoolOut", convertMap);
		}
		return cnt;
	}

	/**
	 *  핵심인재 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCoreSelect2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if(!((List<?>) convertMap.get("mergeRows")).isEmpty()){
			cnt += dao.update("saveCoreSelect2", convertMap);
		}
		return cnt;
	}

	/**
	 *  핵심인재_이미 추가된 대상자 다건 조회 Service
	 *
	 * @param convertMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getCoreSelectIsExistsMap(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		if (!((List<?>) convertMap.get("mergeRows")).isEmpty()) {
			return dao.getMap("getCoreSelectIsExistsList", convertMap);
		} else {
			return Collections.emptyMap();
		}
	}

	/**
	 * 핵심인재_과거이력 다건조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCoreSelectList3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCoreSelectList3", paramMap);
	}
}