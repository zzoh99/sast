package com.hr.pap.progress.appSubCommitteeMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 인사소위원회 Service
 *
 * @author JCY
 *
 */
@Service("AppSubCommitteeMgrService")
public class AppSubCommitteeMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 인사소위원회 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSubCommitteeMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSubCommitteeMgrList", paramMap);
	}
	 /* 인사소위원회 다건_등급기준 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSubCommitteeMgrList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSubCommitteeMgrList2", paramMap);
	}
	 /* 인사소위원회 조직 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSubCommitteeOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSubCommitteeOrgList", paramMap);
	}
	 /* 인사소위원회 조직_ADMIN 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSubCommitteeOrgListAdmin(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSubCommitteeOrgListAdmin", paramMap);
	}
	/**
	 *  인사소위원회 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppSubCommitteeMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppSubCommitteeMgrMap", paramMap);
	}
	/**
	 * 인사소위원회 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppSubCommitteeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppSubCommitteeMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSubCommitteeMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	
}