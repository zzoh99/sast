package com.hr.cpn.payReport.payPartiPopSta;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 급/상여명세서 Service
 * 
 * @author JSG
 *
 */
@Service("PayPartiPopStaService")  
public class PayPartiPopStaService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 급/상여명세서 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayPartiPopStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayPartiPopStaList", paramMap);
	}
	
	/**
	 * 급/상여명세서 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayPartiPopSta(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayPartiPopSta", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayPartiPopSta", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 급/상여명세서 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deletePayPartiPopSta(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deletePayPartiPopSta", paramMap);
	}
}