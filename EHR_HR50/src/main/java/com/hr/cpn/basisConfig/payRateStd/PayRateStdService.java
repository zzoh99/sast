package com.hr.cpn.basisConfig.payRateStd;
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
@Service("PayRateStdService")  
public class PayRateStdService{
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
	public List<?> getPayRateStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayRateStdList", paramMap);
	}	
	/**
	 *  급여지급율관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPayRateStdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPayRateStdMap", paramMap);
	}


}