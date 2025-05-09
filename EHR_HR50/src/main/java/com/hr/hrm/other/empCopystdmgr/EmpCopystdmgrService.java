package com.hr.hrm.other.empCopystdmgr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인사정보복사기준관리 Service
 *
 * @author EW
 *
 */
@Service("EmpCopystdmgrService")
public class EmpCopystdmgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 인사정보복사기준관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpCopystdmgrLeftList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpCopystdmgrLeftList", paramMap);
	}

	/**
	 * 인사정보복사기준관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpCopystdmgrLeft(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpCopystdmgrLeft", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpCopystdmgrLeft", convertMap);
		}

		return cnt;
	}
	
	/**
	 * 인사정보복사기준관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpCopystdmgrRightList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpCopystdmgrRightList", paramMap);
	}

	/**
	 * 인사정보복사기준관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpCopystdmgrRight(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpCopystdmgrRight", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpCopystdmgrRight", convertMap);
		}

		return cnt;
	}
	/**
	 * 인사정보복사기준관리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpCopystdmgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmpCopystdmgrMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * 인사정보복사기준관리 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> empCopystdmgrPrc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("empCopystdmgrPrc", paramMap);
	}
}
