package com.hr.pap.evaluation.appSelfReportReg;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 자기신고서등록 Service
 *
 * @author JCY
 *
 */
@Service("AppSelfReportRegService")
public class AppSelfReportRegService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 자기신고서등록 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfReportRegList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSelfReportRegList", paramMap);
	}

	/**
	 * 자기신고서등록 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppSelfReportRegList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppSelfReportRegList2", paramMap);
	}


	/**
	 *  자기신고서등록 단건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getAppSelfReportRegMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getAppSelfReportRegMap", paramMap);
	}
	/**
	 * 자기신고서등록 -직무기술- 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppSelfReportReg(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSelfReportReg", convertMap);
		}
		Log.Debug();
		return cnt;
	}


	/**
	 * 자기신고서등록  -직무기술- 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppSelfReportReg2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppSelfReportReg2", convertMap);
		}
		Log.Debug();
		return cnt;
	}



}