package com.hr.common.popup.papCptcPopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 평가관리 - 역량 팝업 Service
 * 
 * @author 이름
 *
 */
@Service("PapCptcPopupService")  
public class PapCptcPopupService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 평가관리 - 역량 팝업 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPapCptcPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPapCptcPopupList", paramMap);
	}	
	/**
	 *  평가관리 - 역량 팝업 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getPapCptcPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPapCptcPopupMap", paramMap);
	}

}