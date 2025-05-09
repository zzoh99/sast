package com.hr.common.popup.welfarePayDataPopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 Service
 * 
 * @author 이름
 *
 */
@Service("WelfarePayDataPopupService")  
public class WelfarePayDataPopupService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWelfarePayDataPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWelfarePayDataPopupList", paramMap);
	}	
	/**
	 *  의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getWelfarePayDataPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getWelfarePayDataPopupMap", paramMap);
	}
	/**
	 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWelfarePayDataPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWelfarePayDataPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWelfarePayDataPopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}