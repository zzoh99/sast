package com.hr.tim.schedule.flexibleWorkOrgMgrPop;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 근무제대상자관리 - 범위설정 Service
 *
 * @author jcy
 *
 */
@Service("FlexibleWorkOrgMgrPopService")
public class FlexibleWorkOrgMgrPopService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 근무제대상자관리 - 범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFlexibleWorkOrgMgrPopList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFlexibleWorkOrgMgrPopList1", paramMap);
	}

	/**
	 * 근무제대상자관리 - 범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFlexibleWorkOrgMgrPopList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFlexibleWorkOrgMgrPopList2", paramMap);
	}

	/**
	 * 근무제대상자관리 - 범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFlexibleWorkOrgMgrPopList3(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFlexibleWorkOrgMgrPopList3", paramMap);
	}

	/**
	 * 근무제대상자관리 - 범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFlexibleWorkOrgMgrPopList4(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFlexibleWorkOrgMgrPopList4", paramMap);
	}

	/**
	 * 근무제대상자관리 - 범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFlexibleWorkOrgMgrPopList5(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFlexibleWorkOrgMgrPopList5", paramMap);
	}

	/**
	 * 근무제대상자관리 - 범위설정 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getFlexibleWorkOrgMgrPopList6(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getFlexibleWorkOrgMgrPopList6", paramMap);
	}

	/**
	 *  근무제대상자관리 - 범위설정 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getFlexibleWorkOrgMgrPopMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getFlexibleWorkOrgMgrPopMap", paramMap);
	}

	/**
	 *  근무제대상자관리 - 범위설정 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getFlexibleWorkOrgMgrPopTempQueryMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getFlexibleWorkOrgMgrPopTempQueryMap", paramMap);
	}

	/**
	 * 근무제대상자관리 - 범위설정 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveFlexibleWorkOrgMgrPop(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteFlexibleWorkOrgMgrPop", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveFlexibleWorkOrgMgrPop", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}