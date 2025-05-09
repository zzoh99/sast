package com.hr.hrm.certificate.certiApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 제증명승인관리 Service
 *
 * @author bckim
 *
 */
@Service("CertiAprService")
public class CertiAprService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 제증명승인관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getCertiAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getCertiAprList", paramMap);
	}
	
	/**
	 * 제증명승인관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCertiApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");
		List<Map<String,Object>> deleteList = (List<Map<String,Object>>)convertMap.get("deleteRows");

		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );

				dao.update("updateCertiAprMaster", mp);
				cnt += dao.update("updateCertiApr", mp);
			}
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 제증명승인관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveCertiAprStatus(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		List<Map<String,Object>> updateList = (List<Map<String,Object>>)convertMap.get("updateRows");

		if( updateList.size() > 0){
			for(Map<String,Object> mp : updateList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
				mp.put("applStatusCd", "99" );

				cnt += dao.update("updateCertiAprMaster", mp);
			}
		}

		Log.Debug();
		return cnt;
	}
}