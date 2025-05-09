package com.hr.cpn.payReport.payPrintSta;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 급/상여대장 Service
 * 
 * @author 이름
 *
 */
@Service("PayPrintStaService")  
public class PayPrintStaService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 급/상여대장 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayPrintStaList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayPrintStaList", paramMap);
	}
	
	public List<?> getSheetHeaderCnt1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getSheetHeaderCnt1 invoke", paramMap);
	}
}