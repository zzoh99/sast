package com.hr.ben.pension.staPenUploadMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 국민연금 자료Upload Service
 *
 * @author JM
 *
 */
@Service("StaPenUploadMgrService")
public class StaPenUploadMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 국민연금 자료Upload 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getStaPenUploadMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getStaPenUploadMgrList", paramMap);
	}

	/**
	 * 국민연금 자료Upload 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveStaPenUploadMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteStaPenUploadMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveStaPenUploadMgr", convertMap);
		}

		return cnt;
	}

	/**
	 * 국민연금 자료Upload 반영작업(국민연금변동이력)
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_BEN_NP_UPD(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("StaPenUploadMgrP_BEN_NP_UPD", paramMap);
	}
}