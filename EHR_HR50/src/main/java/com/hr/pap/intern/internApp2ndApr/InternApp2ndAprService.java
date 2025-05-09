package com.hr.pap.intern.internApp2ndApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 계약직 2차평가 Service
 * 
 * @author JCY
 *
 */
@Service("InternApp2ndAprService")  
public class InternApp2ndAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 계약직 2차평가 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternApp2ndAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternApp2ndAprList", paramMap);
	}	
	/**
	 *  계약직 2차평가 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getInternApp2ndAprMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getInternApp2ndAprMap", paramMap);
	}
	/**
	 * 계약직 2차평가 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp2ndApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternApp2ndApr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 계약직 2차평가 -확정-저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp2ndApr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternApp2ndApr2", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	
	/**
	 * 계약직 2차평가 -반려-저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp2ndApr2Return1(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternApp2ndApr2Return1", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	

}