package com.hr.org.capacity.orgCapaPlanApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 인력충원요청 Service
 *
 * @author bckim
 *
 */
@Service("OrgCapaPlanAppService")
public class OrgCapaPlanAppService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 인력충원요청신청 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgCapaPlanAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgCapaPlanAppList", paramMap);
	}	
	
	/**
	 *  인력충원요청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveOrgCapaPlanApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteOrgCapaPlanApp103", convertMap);
			//cnt += dao.delete("deleteOrgCapaPlanApp328", convertMap);

			// 인력충원요청 삭제 HR 4.0 이관
			cnt += dao.delete("deleteOrgCapaPlanApp1", convertMap);
			cnt += dao.delete("deleteOrgCapaPlanApp2", convertMap);
		}
		Log.Debug();
		return cnt;
	}	
}