package com.hr.pap.intern.internApp1stApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 계약직 1차평가 Service
 * 
 * @author 이름
 *
 */
@Service("InternApp1stAprService")  
public class InternApp1stAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 계약직 1차평가 -피평가자- 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternApp1stAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternApp1stAprList", paramMap);
	}	
	
	/**
	 * 계약직 1차평가 -1차평가- 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternApp1stAprList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternApp1stAprList2", paramMap);
	}	
	
	
	
	/**
	 *  계약직 1차평가 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getInternApp1stAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getInternApp1stAprMap", paramMap);
	}
	/**
	 * 계약직 1차평가 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp1stApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternApp1stApr", convertMap);
			cnt += dao.update("saveInternApp1stApr2", convertMap);
		}
		
		
		
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 계약직 1차평가 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp1stApr3(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("updateRows")).size() > 0){
			cnt += dao.update("saveInternApp1stApr3", convertMap);
		}
		
		Log.Debug();
		return cnt;
	}
	

}