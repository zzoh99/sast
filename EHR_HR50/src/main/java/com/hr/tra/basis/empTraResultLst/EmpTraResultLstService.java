package com.hr.tra.basis.empTraResultLst;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.dao.ProDao;
import com.hr.common.logger.Log;

/**
 * empTraResultLst Service
 *
 * @author EW
 *
 */
@Service("EmpTraResultLstService")
public class EmpTraResultLstService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ProDao")
	private ProDao proDao;

	/**
	 * empTraResultLst 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpTraResultLst(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpTraResultLst", paramMap);
	}

	/**
	 * empTraResultLst 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpTraResultLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpTraResultLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpTraResultLst", convertMap);
		}

		return cnt;
	}
	/**
	 * empTraResultLst 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmpTraResultLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmpTraResultLstMap", paramMap);
		Log.Debug();
		return resultMap;
	}
}
