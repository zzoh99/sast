package com.hr.hrm.empContract.empContractCre;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * empContractCre Service
 *
 * @author EW
 *
 */
@Service("EmpContractCreService")
public class EmpContractCreService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * GetDataList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getDataList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList(paramMap.get("cmd").toString(), paramMap);
	}

	/**
	 * 계약서배포 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpContractCreList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpContractCreList", paramMap);
	}
	
	/**
	 * empContractCre 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpContractCre(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		/* 계약서 항목별 데이터 삭제 [THRM417] */
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpContractCreEleVal", convertMap);
		}
		/* 계약서 항목별 데이터 저장 [THRM417] */
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpContractCreEleVal", convertMap);
		}
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpContractCre", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpContractCre", convertMap);
		}

		return cnt;
	}
	
	/**
	 * empContractCre 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpContractCreMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmpContractCreMap", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 계약서배포 생성 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int targetCreate(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("createEmpContractCre", convertMap);

		return cnt;
	}

}
