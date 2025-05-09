package com.hr.sys.system.langMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 언어관리 Service
 * 
 * @author CBS
 *
 */
@Service("LangMgrService")  
public class LangMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 언어관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	
	public List<?> getLangMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("LangMgrService.getLangMgrList ");
		return (List<?>) dao.getList("getLangMgrList", paramMap);
	}
	
	
	/**
	 * 언어관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveLangMgr(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteLangMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveLangMgr", convertMap);
		}
		Log.DebugEnd();
		return cnt;
	}
	
	/**
	 *   언어관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteLangMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug("LangMgrService.deleteLangMgr");
		return dao.delete("deleteLangMgr", paramMap);
	}
	
	
	
	
	/**
	 * 사용언어관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	
	public List<?> getUseLangMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug("UseLangMgrService.getUseLangMgrList ");
		return (List<?>) dao.getList("getUseLangMgrList", paramMap);
	}
	
	
	/**
	 * 사용언어관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveUseLangMgr(Map<?, ?> convertMap) throws Exception {
		Log.DebugStart();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteUseLangMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveUseLangMgr", convertMap);
		}
		Log.DebugEnd();
		return cnt;
	}
	
	/**
	 *  사용언어관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteUseLangMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug("LangMgrService.deleteUseLangMgr");
		return dao.delete("deleteUseLangMgr", paramMap);
	}
	
		
}