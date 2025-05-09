package com.hr.tra.basis.eduLecturerMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 교육강사관리 Service
 *
 * @author EW
 *
 */
@Service("EduLecturerMgrService")
public class EduLecturerMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 교육강사관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduLecturerMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduLecturerMgrList", paramMap);
	}

	/**
	 * 교육강사관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduLecturerMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if (((List<?>) convertMap.get("deleteRows")).size() > 0) {
			cnt += dao.delete("deleteEduLecturerMgr", convertMap);
		}
		if (((List<?>) convertMap.get("mergeRows")).size() > 0) {
			cnt += dao.update("saveEduLecturerMgr", convertMap);
		}

		return cnt;
	}
}
