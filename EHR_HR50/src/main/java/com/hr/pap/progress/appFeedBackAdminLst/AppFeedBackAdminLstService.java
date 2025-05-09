package com.hr.pap.progress.appFeedBackAdminLst;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가결과피드백 Service
 *
 * @author JCY
 *
 */
@Service("AppFeedBackAdminLstService")
public class AppFeedBackAdminLstService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 평가결과피드백 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppFeedBackAdminLstList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppFeedBackAdminLstList", paramMap);
	}
	/**
	* 평가결과팝업 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppFeedBackAdminLstPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppFeedBackAdminLstPopupList", paramMap);
	}
	/**
	 *  평가결과피드백 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppFeedBackAdminLstMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppFeedBackAdminLstMap", paramMap);
	}
	/**
	 * 평가결과피드백 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppFeedBackAdminLst(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppFeedBackAdminLst", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppFeedBackAdminLst", convertMap);
		}
		Log.Debug();
		return cnt;
	}



}