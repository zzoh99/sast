package com.hr.hrm.psnalInfo.psnalOverStudy;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사기본(해외연수) Service
 *
 * @author EW
 *
 */
@Service("PsnalOverStudyService")
public class PsnalOverStudyService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사기본(해외연수) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalOverStudyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalOverStudyList", paramMap);
	}

	/**
	 * 인사기본(해외연수) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePsnalOverStudy(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePsnalOverStudy", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePsnalOverStudy", convertMap);
		}

		return cnt;
	}
	/**
	 * 인사기본(해외연수) 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPsnalOverStudyMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPsnalOverStudyMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 인사기본(해외연수) 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> psnalOverStudyPrc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("psnalOverStudyPrc", paramMap);
	}
}
