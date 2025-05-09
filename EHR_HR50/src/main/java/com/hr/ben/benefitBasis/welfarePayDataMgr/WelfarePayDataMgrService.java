package com.hr.ben.benefitBasis.welfarePayDataMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 복리후생마감관리 Service
 *
 * @author JM
 *
 */
@Service("WelfarePayDataMgrService")
public class WelfarePayDataMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * getWelfarePayDataMgrList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWelfarePayDataMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWelfarePayDataMgrList", paramMap);
	}
	
	/**
	 * getWelfarePayDataMgr2List 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWelfarePayDataMgr2List(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWelfarePayDataMgr2List", paramMap);
	}
	
	
	/**
	 * 복리후생마감관리 전월자료복사
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int insertWelfarePayDataMgrMonthData(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("insertWelfarePayDataMgrMonthData", paramMap);

		return cnt;
	}

	/**
	 * callP_CPN_AD_CREEP_CANCEL 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_CPN_AD_CREEP_CANCEL(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_CPN_AD_CREEP_CANCEL");
		return (Map) dao.excute("callP_CPN_AD_CREEP_CANCEL", paramMap);
	}
	/**
	 * callP_CPN_AD_CREEP_INS 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_CPN_AD_CREEP_INS(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_CPN_AD_CREEP_INS");
		return (Map) dao.excute("callP_CPN_AD_CREEP_INS", paramMap);
	}
	/**
	 * callP_BEN_PAY_DATA_CREATE 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_BEN_PAY_DATA_CREATE(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_BEN_PAY_DATA_CREATE");
		return (Map) dao.excute("callP_BEN_PAY_DATA_CREATE", paramMap);
	}
	/**
	 * callP_BEN_PAY_DATA_CREATE_DEL 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_BEN_PAY_DATA_CREATE_DEL(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_BEN_PAY_DATA_CREATE_DEL");
		return (Map) dao.excute("callP_BEN_PAY_DATA_CREATE_DEL", paramMap);
	}
	
	/**
	 * callP_BEN_PAY_DATA_CREATE 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_BEN_PAY_DATA_CLOSE(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_BEN_PAY_DATA_CLOSE");
		return (Map) dao.excute("callP_BEN_PAY_DATA_CLOSE", paramMap);
	}
	
	/**
	 * callP_BEN_PAY_DATA_CLOSE_CANCEL 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_BEN_PAY_DATA_CLOSE_CANCEL(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_BEN_PAY_DATA_CLOSE_CANCEL");
		return (Map) dao.excute("callP_BEN_PAY_DATA_CLOSE_CANCEL", paramMap);
	}
}