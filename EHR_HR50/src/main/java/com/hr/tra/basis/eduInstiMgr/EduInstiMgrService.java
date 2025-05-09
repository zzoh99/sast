package com.hr.tra.basis.eduInstiMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 교육기관관리 Service
 *
 * @author
 *
 */
@Service("EduInstiMgrService")
public class EduInstiMgrService {

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 교육기관관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduInstiMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduInstiMgrList", paramMap);
	}

	/**
	 * 교육기관관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduInstiMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if (((List<?>) convertMap.get("deleteRows")).size() > 0) {
			cnt += dao.delete("deleteEduInstiMgr", convertMap);
		}
		if (((List<?>) convertMap.get("mergeRows")).size() > 0) {
			cnt += dao.update("saveEduInstiMgr", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 교육기관관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduInstiMgrDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		cnt += dao.update("saveEduInstiMgrDet", convertMap);

		Log.Debug();
		return cnt;
	}
}
