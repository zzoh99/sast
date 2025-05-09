package com.hr.tim.schedule.workMappingMgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 조직구분항목 Service
 *
 * @author RyuSiOong
 *
 */
@Service("WorkMappingMgrService")
public class WorkMappingMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 조직구분항목 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkMappingMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkMappingMgrList", paramMap);
	}
	/**
	 *  조직구분항목 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getWorkMappingMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getWorkMappingMgrMap", paramMap);
	}
	/**
	 * 조직구분항목 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkMappingMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkMappingMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkMappingMgrFirst", convertMap);
		}
		dao.update("saveWorkMappingMgrSecond", convertMap);
		Log.Debug();
		return cnt;
	}
	/**
	 * 조직구분항목 생성 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertWorkMappingMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.create("insertWorkMappingMgr", paramMap);
	}
	/**
	 * 조직구분항목 수정 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateWorkMappingMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateWorkMappingMgr", paramMap);
	}
	/**
	 * 조직구분항목 삭제 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWorkMappingMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteWorkMappingMgr", paramMap);
	}
}