package com.hr.ben.benefitBasis.welfareHisResultMgr;
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
@Service("WelfareHisResultMgrService")
public class WelfareHisResultMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	
	/**
	 * getWelfareHisResultMgrList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWelfareHisResultMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWelfareHisResultMgrList", paramMap);
	}
	
	/**
	 * getWelfareHisResultMgr2List 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWelfareHisResult2MgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWelfareHisResult2MgrList", paramMap);
	}
		
}