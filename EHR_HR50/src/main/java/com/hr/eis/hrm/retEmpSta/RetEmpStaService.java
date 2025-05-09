package com.hr.eis.hrm.retEmpSta;
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
@Service("RetEmpStaService")  
public class RetEmpStaService{
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
	public List<?> getRetEmpStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetEmpStaList", paramMap);
	}	
	/**
	 *  기간별퇴사자현황 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getRetEmpStaMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getRetEmpStaMap", paramMap);
	}
	/**
	 * 기간별퇴사자현황 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetEmpSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetEmpSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetEmpSta", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}