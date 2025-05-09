package com.hr.common.popup.pwrSrchDistributionPopup;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;


@Service("PwrSrchDistributionPopupService") 
public class PwrSrchDistributionPopupService{
 
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 공통팝업 PwrSrchDistributionPopup 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPwrSrchDistributionPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPwrSrchDistributionPopupList", paramMap);
	}
	
	/**
	 * 검색조건 결과 팝업팝업 ELEM 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePwrSrchDistributionPopup(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt = dao.delete("deletePwrSrchDistributionPopup", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePwrSrchDistributionPopup", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}