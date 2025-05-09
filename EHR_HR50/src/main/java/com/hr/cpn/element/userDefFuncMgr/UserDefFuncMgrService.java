package com.hr.cpn.element.userDefFuncMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 항목링크(계산식) Service
 * 
 * @author 이름
 *
 */
@Service("UserDefFuncMgrService")  
public class UserDefFuncMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 항목링크(계산식) 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getUserDefFuncMgrFirstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getUserDefFuncMgrFirstList", paramMap);
	}	
	
	/**
	 * 항목링크(계산식) 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getUserDefFuncMgrSecondList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getUserDefFuncMgrSecondList", paramMap);
	}	
	
	/**
	 *  항목링크(계산식) 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getUserDefFuncMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getUserDefFuncMgrMap", paramMap);
	}
	/**
	 * 항목링크(계산식) 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveUserDefFuncMgrFirst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			
			cnt += dao.delete("deleteUserDefFuncMgrSecond2", convertMap);
			cnt += dao.delete("deleteUserDefFuncMgrFirst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveUserDefFuncMgrFirst", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 항목링크(계산식) 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveUserDefFuncMgrSecond(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteUserDefFuncMgrSecond", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveUserDefFuncMgrSecond", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	


}