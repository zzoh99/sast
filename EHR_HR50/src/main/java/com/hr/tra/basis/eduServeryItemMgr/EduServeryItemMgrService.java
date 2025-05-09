package com.hr.tra.basis.eduServeryItemMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 교육만족도항목관리 Service
 *
 * @author
 *
 */
@Service("EduServeryItemMgrService")
public class EduServeryItemMgrService {
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  교육만족도항목관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduServeryItemMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduServeryItemMgrList", paramMap);
	}

	/**
	 * 교육만족도항목관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduServeryItemMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 0;
		if (((List<?>) convertMap.get("deleteRows")).size() > 0) {
			cnt += dao.delete("deleteEduServeryItemMgr", convertMap);
		}
		if (((List<?>) convertMap.get("mergeRows")).size() > 0) {
			cnt += dao.update("saveEduServeryItemMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}
