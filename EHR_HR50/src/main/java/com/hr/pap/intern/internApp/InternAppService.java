package com.hr.pap.intern.internApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 촉탁직평가 Service
 * 
 * @author 이름
 *
 */
@Service("InternAppService")  
public class InternAppService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 촉탁직평가 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternAppList", paramMap);
	}	
	/**
	 *  촉탁직평가 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getInternAppStatusMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getInternAppStatusMap", paramMap);
	}
	/**
	 * 촉탁직평가 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternApp", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 촉탁직평가 -평가확정- 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saevInternAppRequest(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saevInternAppRequest", convertMap);
		Log.Debug();
		return cnt;
	}
		
}