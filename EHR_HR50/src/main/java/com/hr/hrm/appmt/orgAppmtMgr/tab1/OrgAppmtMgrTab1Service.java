package com.hr.hrm.appmt.orgAppmtMgr.tab1;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 조직개편발령 Service
 *
 * @author bckim
 *
 */
@Service("OrgAppmtMgrTab1Service")
public class OrgAppmtMgrTab1Service{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 발령형태코드(콤보로 사용할때) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgAppmtMgrTab1CodeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgAppmtMgrTab1CodeList", paramMap);
	}

	/**
	 * 발령조직 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgAppmtMgrTab1OrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgAppmtMgrTab1OrgList", paramMap);
	}

	/**
	 * 발령사원 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgAppmtMgrTab1UserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgAppmtMgrTab1UserList", paramMap);
	}

	/**
	 * 발령사원 추가 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int insertOrgAppmtMgrTab1User(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("insertRows")).size() > 0){
			cnt += dao.update("insertOrgAppmtMgrTab1User", convertMap);
		}
		
		return cnt;
	}
}