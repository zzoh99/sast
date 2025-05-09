package com.hr.common.popup.yearPayDegrePopup;
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
@Service("YearPayDegrePopupService")  
public class YearPayDegrePopupService{
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
	public List<?> getYearPayDegrePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getYearPayDegrePopupList", paramMap);
	}	
	/**
	 *  급여일자관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getYearPayDegrePopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getYearPayDegrePopupMap", paramMap);
	}
	/**
	 * 급여일자관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveYearPayDegrePopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteYearPayDegrePopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveYearPayDegrePopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}