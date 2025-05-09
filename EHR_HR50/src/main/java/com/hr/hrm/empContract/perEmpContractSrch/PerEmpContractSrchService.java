package com.hr.hrm.empContract.perEmpContractSrch;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * perEmpContractSrch Service
 *
 * @author EW
 *
 */
@Service("PerEmpContractSrchService")
public class PerEmpContractSrchService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * perEmpContractSrch 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPerEmpContractSrchList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPerEmpContractSrchList", paramMap);
	}

	/**
	 * perEmpContractSrch 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePerEmpContractSrch(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePerEmpContractSrch", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePerEmpContractSrch", convertMap);
		}

		return cnt;
	}
	/**
	 * perEmpContractSrch 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getPerEmpContractSrchMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getPerEmpContractSrchMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
