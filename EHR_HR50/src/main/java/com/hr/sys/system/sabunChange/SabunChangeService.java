package com.hr.sys.system.sabunChange;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 사번변경 Service
 * 
 * @author JCY
 *
 */
@Service("SabunChangeService")  
public class SabunChangeService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 사번변경 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSabunChangeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSabunChangeList", paramMap);
	}	
	/**
	 *  사번변경 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getSabunChangeMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSabunChangeMap", paramMap);
	}
	
	/**
     *  사번변경 단건 조회 Service 
     * 
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public Map<?, ?> getSabunDupCheckPopupMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getSabunDupCheckPopupMap", paramMap);
    }
	
	
	
	
	/**
	 * 사번변경 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSabunChange(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSabunChange", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSabunChange", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	
	/**
     * 사번변경 프로시져
     *
     * @param paramMap
     * @return int
     * @throws Exception
     */
    public Map prcP_SYS_SABUN_DATA_MODIFY(Map<?, ?> paramMap) throws Exception {
        Log.Debug();

        return (Map) dao.excute("prcP_SYS_SABUN_DATA_MODIFY", paramMap);
    }


}