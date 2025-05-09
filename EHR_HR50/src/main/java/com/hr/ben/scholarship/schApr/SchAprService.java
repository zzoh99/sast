package com.hr.ben.scholarship.schApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 학자금승인 Service
 * 
 * @author 이름
 *
 */
@Service("SchAprService")  
public class SchAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 학자금승인 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSchAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSchAprList", paramMap);
	}	
	/**
	 *  학자금승인 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getSchAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSchAprMap", paramMap);
	}
	/**
	 * 학자금승인 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSchApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSchApr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSchApr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 학자금승인 수정 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int updateSchApr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		
		int cnt = 0;
		// 로직 순서
		// TCPN183 대상 건에 대한 update
		cnt += dao.update("updateSchApr", paramMap);
		
		cnt += dao.delete("deleteSchApr", paramMap);
		
		return cnt;//dao.update("updateSchApr", paramMap);
	}

}