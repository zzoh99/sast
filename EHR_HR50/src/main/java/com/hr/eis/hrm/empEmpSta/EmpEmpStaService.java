package com.hr.eis.hrm.empEmpSta;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 기간별퇴사자현황 Service
 * 
 * @author jcy
 *
 */
@Service("EmpEmpStaService")  
public class EmpEmpStaService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 기간별퇴사자현황 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpEmpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpEmpStaList", paramMap);
	}	
	/**
	 *  기간별퇴사자현황 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getEmpEmpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getEmpEmpStaMap", paramMap);
	}
	/**
	 * 기간별퇴사자현황 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpEmpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpEmpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpEmpSta", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}