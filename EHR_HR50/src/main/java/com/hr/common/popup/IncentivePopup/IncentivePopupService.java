package com.hr.common.popup.IncentivePopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 급여일자관리 Service
 * 
 * @author 이름
 *
 */
@Service("IncentivePopupService")  
public class IncentivePopupService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 급여일자관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getIncentivePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getIncentivePopupList", paramMap);
	}	
	/**
	 *  급여일자관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getIncentivePopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getIncentivePopupMap", paramMap);
	}
	/**
	 * 급여일자관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveIncentivePopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteIncentivePopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveIncentivePopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}