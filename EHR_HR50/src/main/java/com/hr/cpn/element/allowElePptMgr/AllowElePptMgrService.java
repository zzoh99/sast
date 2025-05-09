package com.hr.cpn.element.allowElePptMgr;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("AllowElePptMgrService") 
public class AllowElePptMgrService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 공통팝업 AllowElePptMgrService 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAllowElePptMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAllowElePptMgrList", paramMap);
	}	/**
	 * 공통팝업 AllowElePptMgrService 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAllowElePptMgrListFirst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAllowElePptMgrListFirst", paramMap);
	}
	
	/**
	 * 공통팝업 AllowElePptMgrService 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAllowElePptMgrListSecond(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAllowElePptMgrListSecond", paramMap);
	}
	
	/**
	 * 공통팝업 AllowElePptMgrService 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAllowElePptMgrListThird(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAllowElePptMgrListThird", paramMap);
	}
	
	
	/**
	 * 항목그룹2 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateAllowElePptMgrListSecond(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.update("updateAllowElePptMgrListSecond", paramMap);
	}
}