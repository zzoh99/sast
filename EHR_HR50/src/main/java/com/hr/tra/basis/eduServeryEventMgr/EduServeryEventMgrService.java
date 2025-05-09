package com.hr.tra.basis.eduServeryEventMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 교육만족도항목관리_회차별 Service
 *
 * @author JSG
 *
 */
@Service("EduServeryEventMgrService")
public class EduServeryEventMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 교육만족도항목관리_회차별 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduServeryEventMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduServeryEventMgrList", paramMap);
	}

	/**
	 * 교육만족도항목관리_회차별 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduServeryEventMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduServeryEventMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduServeryEventMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 교육만족도항목관리_회차별 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteEduServeryEventMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteEduServeryEventMgr", paramMap);
	}

	/**
	 * 교육만족도항목관리_회차별 - 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcEduServery(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcEduServery", paramMap);
	}
}