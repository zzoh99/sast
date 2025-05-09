package com.hr.pap.progress.appCommitteeMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 인사위원회 Service
 *
 * @author JCY
 *
 */
@Service("AppCommitteeMgrService")
public class AppCommitteeMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 인사위원회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppCommitteeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppCommitteeMgrList", paramMap);
	}
	 /* 인사위원회 다건_등급기준 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppCommitteeMgrList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppCommitteeMgrList2", paramMap);
	}
	/**
	 *  인사위원회 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppCommitteeMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppCommitteeMgrMap", paramMap);
	}
	 /* 인위원회 조직 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppCommitteeOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppCommitteeOrgList", paramMap);
	}
	 /* 인사위원회 조직_ADMIN 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppCommitteeOrgListAdmin(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppCommitteeOrgListAdmin", paramMap);
	}
	/**
	 * 인사위원회 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppCommitteeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppCommitteeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppCommitteeMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}


	
}