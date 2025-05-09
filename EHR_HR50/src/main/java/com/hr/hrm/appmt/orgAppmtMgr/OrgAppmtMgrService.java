package com.hr.hrm.appmt.orgAppmtMgr;
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
 * @author jcy
 *
 */
@Service("OrgAppmtMgrService")  
public class OrgAppmtMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 조직개편발령 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgAppmtMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgAppmtMgrList", paramMap);
	}	
	/**
	 *  조직개편발령 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getOrgAppmtMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getOrgAppmtMgrMap", paramMap);
	}

}