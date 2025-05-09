package com.hr.cpn.payRetire.sepBase1YmdMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직기산시작일 Service
 *
 * @author 
 *
 */
@Service("SepBase1YmdMgrService")
public class SepBase1YmdMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 *  퇴직기산시작일 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepBase1YmdMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getSepBase1YmdMgrList", paramMap);
	}
	
	/**
	 *  퇴직기산시작일 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepBase1YmdMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepBase1YmdMgr", convertMap);
		}

		Log.Debug();
		return cnt;
	}
}
