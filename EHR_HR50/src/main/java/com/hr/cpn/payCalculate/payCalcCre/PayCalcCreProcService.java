package com.hr.cpn.payCalculate.payCalcCre;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여계산 Service
 *
 * @author JM
 *
 */
@Service("PayCalcCreProcService")
public class PayCalcCreProcService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 급여계산 작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_CAL_PAY_MAIN(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("PayCalcCreProcP_CPN_CAL_PAY_MAIN", paramMap);
	}

	/**
	 * 상여계산 작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_BON_PAY_MAIN(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("PayCalcCreProcP_CPN_BON_PAY_MAIN", paramMap);
	}

	/**
	 * 급여계산 작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_CAL_PAY_MAIN2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("PayCalcCreProcP_CPN_CAL_PAY_MAIN2", paramMap);
	}

	/**
	 * 급여계산 작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_BON_PAY_MAIN2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("PayCalcCreProcP_CPN_BON_PAY_MAIN2", paramMap);
	}
	
	/**
	 * 급여계산 복리후생 연계자료 생성
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
//	public Map prcP_BEN_PAY_DATA_CREATE_ALL(Map<?, ?> paramMap) throws Exception {
//		Log.Debug();
//		return (Map) dao.excute("PayCalcCreProcP_BEN_PAY_DATA_CREATE_ALL", paramMap);
//	}		
}