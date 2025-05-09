package com.hr.sys.alteration.mainMuPrg;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메인메뉴프로그램관리 Service
 *
 * @author ParkMoohun
 *
 */
@Service("MainMuPrgService")
public class MainMuPrgService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 메인메뉴 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainMuPrgMainMenuList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainMuPrgMainMenuList", paramMap);
	}
	
	/**
	 * 메인메뉴프로그램관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getMainMuPrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getMainMuPrgList", paramMap);
	}
	/**
	 * 메인메뉴프로그램관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMainMuPrg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteMainMuPrg2", convertMap);
			cnt += dao.delete("deleteAthGrpMenuMgrRegPopup", convertMap);
			cnt += dao.delete("deleteMainMuPrg", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveMainMuPrg", convertMap);
			cnt += dao.delete("updateAthGrpMenuMgrRegPopup", convertMap);

		}

		return cnt;
	}
	/**
	 * 메인메뉴프로그램관리 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteMainMuPrg(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteMainMuPrg", paramMap);
	}

	/**
	 * 메인메뉴프로그램관리 도움말 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMainMuPrgPop(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("saveMainMuPrgPop", paramMap);
		dao.updateClob("saveMainMuPrgPopContents", paramMap);

		return cnt;
	}

	/**
	 * 메인메뉴관리 도움말 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?,?> getMainMnMgrHelpPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMainMnMgrHelpPopMap", paramMap);
	}
	
	/**
	 * 메인메뉴관리 도움말 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveMainMnMgrHelpPop(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("saveMainMnMgrHelpPop", paramMap);
		dao.updateClob("saveMainMnMgrHelpPopContents", paramMap);

		return cnt;
	}

    public Map<?,?> getMainMuPrgPopMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getMainMuPrgPopMap", paramMap);
    }
}