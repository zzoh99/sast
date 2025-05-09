package com.hr.ben.healthInsurance.healthInsAddBackMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 건강보험추가/환급액관리 Service
 *
 * @author JM
 *
 */
@Service("HealthInsAddBackMgrService")
public class HealthInsAddBackMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getHealthInsAddBackMgrList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHealthInsAddBackMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHealthInsAddBackMgrList", paramMap);
	}
	
	/**
	 * 건강보험추가/환급액관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHealthInsAddBackMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHealthInsAddBackMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHealthInsAddBackMgr", convertMap);
		}

		return cnt;
	}
}