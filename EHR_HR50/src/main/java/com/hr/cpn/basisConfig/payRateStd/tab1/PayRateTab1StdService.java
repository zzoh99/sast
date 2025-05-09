package com.hr.cpn.basisConfig.payRateStd.tab1;
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
@Service("PayRateTab1StdService")  
public class PayRateTab1StdService{
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
	public List<?> getPayRateTab1StdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayRateTab1StdList", paramMap);
	}	
	/**
	 *  급여지급율관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPayRateTab1StdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPayRateTab1StdMap", paramMap);
	}
	/**
	 * 급여지급율관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayRateTab1Std(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayRateTab1Std", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayRateTab1Std", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}