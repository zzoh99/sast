package com.hr.cpn.payRetire.retConnectPay;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직금연결급여 Service
 *
 * @author 
 *
 */
@Service("RetConnectPayService")
public class RetConnectPayService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  퇴직금연결급여 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetConnectPayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetConnectPayList", paramMap);
	}
	
	/**
	 *  퇴직금연결급여 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetConnectPay(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteRetConnectPay", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetConnectPay", convertMap);
		}

		Log.Debug();
		return cnt;
	}
}
