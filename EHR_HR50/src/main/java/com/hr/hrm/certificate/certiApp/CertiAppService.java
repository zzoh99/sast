package com.hr.hrm.certificate.certiApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 제증명신청 Service
 *
 * @author bckim
 *
 */
@Service("CertiAppService")
public class CertiAppService{

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 제증명신청 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCertiAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCertiAppList", paramMap);
	}

	/**
	 * getEmployeeInfoMap 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEmployeeInfoMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEmployeeInfoMap", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * getLoanStdDateCertiApp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getLoanStdDateCertiApp(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getLoanStdDateCertiApp", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 제증명신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCertiApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteCertiApp103", convertMap);
			dao.delete("deleteCertiApp107", convertMap);
			//cnt += dao.delete("deleteLoanAppFormDet", convertMap);
			cnt += dao.delete("deleteCertiApp", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}