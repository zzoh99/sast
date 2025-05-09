package com.hr.pap.evaluation.appSelfReportApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 자기신고서승인 Service
 *
 * @author JCY
 *
 */
@Service("AppSelfReportAppService")
public class AppSelfReportAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 자기신고서승인 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfReportAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSelfReportAppList", paramMap);
	}

	/**
	 * 자기신고서승인 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfReportAppColList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSelfReportAppColList", paramMap);
	}

	/**
	 *  자기신고서승인 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppSelfReportAppMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppSelfReportAppMap", paramMap);
	}
	/**
	 * 자기신고서승인 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppSelfReportApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppSelfReportApp", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSelfReportApp", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}