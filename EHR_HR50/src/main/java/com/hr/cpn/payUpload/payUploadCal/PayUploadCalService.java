package com.hr.cpn.payUpload.payUploadCal;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;
/**
 * 연봉관리 Service
 *
 * @author JSG
 *
 */
@Service("PayUploadCalService")
public class PayUploadCalService {
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 연봉관리 title 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPayUploadCalTitleList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayUploadCalTitleList", paramMap);
	}
	public List<?> getPayUploadCalCountTcpn203(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPayUploadCalCountTcpn203", paramMap);
	}

	/**
	 * 연봉관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePayUploadCal(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePayUploadCal", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePayUploadCal", convertMap);
		}

		return cnt;
	}
	
	/**
	 * 급여 업로드 반영 UPDATE
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public Map prcP_CPN_CAL_UPLOAD(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcP_CPN_CAL_UPLOAD", paramMap);
	}
	

}