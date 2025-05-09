package com.hr.sys.other.quickMenuMgr;
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
@Service("QuickMenuService")  
public class QuickMenuService{ 
	@Inject
	@Named("Dao")
	
	private Dao dao;


	/**
	 * getQuickMuComboList 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getQuickMuComboList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getQuickMuComboList", paramMap);
	}	

	
	
	/**
	 * Quick메뉴프로그램관리 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getQuickMuPrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getQuickMuPrgList", paramMap);
	}		
	
	/**
	 * My Quick Menu 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> tsys333SelectMyQuickMenuList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("tsys333SelectMyQuickMenuList", paramMap);
	}	
	/**
	 *  메뉴명 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getQuickMenuMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getQuickMenuMap", paramMap);
	}
	/**
	 * 메뉴명 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveQuickMenu(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteQuickMenu", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveQuickMenu", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}