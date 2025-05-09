package com.hr.cpn.basisConfig.contractCre;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * contractCre Service
 *
 * @author EW
 *
 */
@Service("ContractCreService")
public class ContractCreService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * contractCre 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getContractCreList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getContractCreList", paramMap);
	}

	/**
	 * contractCre 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveContractCre(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteContractCre", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveContractCre", convertMap);
		}

		return cnt;
	}
	/**
	 * contractCre 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getContractCreMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getContractCreMap", paramMap);
		Log.Debug();
		return resultMap;
	}
	/**
	 * contractCre 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> callP_CPN_CONTRACT_CREATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("callP_CPN_CONTRACT_CREATE", paramMap);
	}
}
