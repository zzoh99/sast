package com.hr.cpn.payRetire.sepPayDayMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직계산일자관리 Service
 *
 * @author JM
 *
 */
@Service("SepPayDayMgrService")
public class SepPayDayMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직계산일자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getSepPayDayMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getSepPayDayMgrList", paramMap);
	}

	/**
	 * 퇴직계산일자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveSepPayDayMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteSepPayDayMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveSepPayDayMgr", convertMap);
		}

		return cnt;
	}
}