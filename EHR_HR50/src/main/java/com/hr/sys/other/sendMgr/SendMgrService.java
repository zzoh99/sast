package com.hr.sys.other.sendMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메뉴명 Service
 * 
 * @author 이름
 *
 */
@Service("SendMgrService")  
public class SendMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * getSendMgrOrgList 
	 * 
	 * @param searchMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSendMgrOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getSendMgrOrgList", paramMap);
	}
	
	/**
	 * getSendMgrOrgUserList 
	 * 
	 * @param searchMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSendMgrOrgUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getSendMgrOrgUserList", paramMap);
	}
	
	/**
	 * 메일 보낼때 정보가져오기 
	 * 
	 * @param searchMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMailInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getMailInfo", paramMap);
	}
	
	/**
	 * 메일 보낼때 정보가져오기 
	 * 
	 * @param searchMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMailInfo2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getMailInfo2", paramMap);
	}

}