package com.hr.cpn.payRetire.sepPenComMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직연금기관관리 Service
 *
 * @author JM
 *
 */
@Service("SepPenComMgrService")
public class SepPenComMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직연금기관관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepPenComMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepPenComMgrList", paramMap);
	}

	/**
	 * 퇴직연금기관관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepPenComMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		int edateCnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepPenComMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepPenComMgr", convertMap);
		}

		// 종료일 UPDATE
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){
			edateCnt += dao.update("updateSepPenComMgrEdate", convertMap);
		}

		return cnt;
	}
}