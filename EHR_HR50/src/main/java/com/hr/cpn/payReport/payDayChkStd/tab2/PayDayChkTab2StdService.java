package com.hr.cpn.payReport.payDayChkStd.tab2;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 일할계산대상자 관리 Service
 * 
 * @author 이름
 *
 */
@Service("PayDayChkTab2StdService")  
public class PayDayChkTab2StdService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 일할계산대상자 관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayDayChkTab2StdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayDayChkTab2StdList", paramMap);
	}	
}