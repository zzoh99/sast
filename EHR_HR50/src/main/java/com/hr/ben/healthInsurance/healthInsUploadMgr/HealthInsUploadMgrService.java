package com.hr.ben.healthInsurance.healthInsUploadMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 건강보험 자료Upload Service
 *
 * @author JM
 *
 */
@Service("HealthInsUploadMgrService")
public class HealthInsUploadMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 건강보험 자료Upload 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHealthInsUploadMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getHealthInsUploadMgrList", paramMap);
	}

	/**
	 * 건강보험 자료Upload 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHealthInsUploadMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHealthInsUploadMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHealthInsUploadMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * 건강보험 자료Upload 반영작업
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_BEN_HI_UPD(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("HealthInsUploadMgrP_BEN_HI_UPD", paramMap);
	}
}