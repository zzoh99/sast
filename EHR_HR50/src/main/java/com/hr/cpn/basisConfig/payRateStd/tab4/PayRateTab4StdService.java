package com.hr.cpn.basisConfig.payRateStd.tab4;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 급여지급율관리 Service
 * 
 * @author 이름
 *
 */
@Service("PayRateTab4StdService")  
public class PayRateTab4StdService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 급여지급율관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayRateTab4StdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayRateTab4StdList", paramMap);
	}	
	/**
	 *  급여지급율관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPayRateTab4StdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPayRateTab4StdMap", paramMap);
	}
	/**
	 * 급여지급율관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayRateTab4Std(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayRateTab4Std", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayRateTab4Std", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}