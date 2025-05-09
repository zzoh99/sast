package com.hr.tra.basis.eduContentsMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * Load Service
 *
 * @author JSG
 *
 */
@Service("EduContentsMgrService")
public class EduContentsMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduContentsMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduContentsMgr", paramMap);
	} 
	
	/**
	 * 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVedioContentsMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVedioContentsMgr", paramMap);
	} 
	
	/**
	 *  저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduContentsMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduContentsMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduContentsMgr", convertMap);
		}

		return cnt;
	}

    public List<?> getEduContentFileName(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getEduContentFileName", paramMap);
    }
}