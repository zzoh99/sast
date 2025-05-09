package com.hr.sys.security.userMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("UserMgrService") 
public class UserMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	public List<?> getUserMgrList(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("userMgrList", paramMap);
	}	
	
	public int setUserMgrPwdInit(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return dao.update("userMgrPwdInit", paramMap);
	}	
	
	
	public int saveUserMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			Log.Debug();
			cnt += dao.delete("deleteUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			Log.Debug();
			cnt += dao.update("saveUserMgr", convertMap);
		}
		
		return cnt;
	}	



	/**
	 * 암호 랜덤 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> pwdRandom(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("pwdRandom", paramMap);
	}

	/**
	 * 주민번호7 자리  Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */	
	public Map<?, ?> pwd7Jumin(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("pwd7Jumin", paramMap);
	}
	
	
	public int setFindPwdInsert(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if(paramMap.get("type").equals("0")){
			cnt += dao.create("insert108", paramMap);
		}
		else{
			cnt += dao.create("insert109", paramMap);
		}
		
		return cnt;
	}	
	
	
	
	public int userTheme(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return dao.update("userTheme", paramMap);
	}	
	
	public List<?> pwdConfirm(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("pwdConfirm", paramMap);
	}
	
	public int pwdChfirm(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		String type = (String) paramMap.get("type");
		if( StringUtils.isBlank(type) || "login".equals(type) ) {
			cnt = dao.update("pwdChfirm", paramMap);
		} else if(type != null && "download".equals(type)) {
			cnt = dao.update("updateDownloadPassword", paramMap);
		}
		
		// insert history
		if(cnt > 0){
			cnt = dao.update("pwdChfirmHistory", paramMap);
		}
		
		return cnt;
	}	
	
	public Map<?, ?> pwdLevel(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("pwdLevel", paramMap);
	}
		
	/**
	 * 비밀번호 보안 체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<?, ?> pwdCheck(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("pwdCheck", paramMap);
	}
	
	
	/**
	 * 다운로드 비밀번호 초기화
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int setUserMgrDownloadPwdInit(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return dao.update("userMgrDownloadPwdInit", paramMap);
	}

	/**
	 * 비밀번호 확인
	 *
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> confirmPassword(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (Map<String, Object>) dao.getMap("pwdConfirm", paramMap);
	}

}