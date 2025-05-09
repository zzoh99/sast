package com.hr.common.popup.locationCodePopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근무지 팝업 Service
 *
 * @author bckim
 *
 */
@Service("LocationCodePopupService")
public class LocationCodePopupService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근무지 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getLocationCodePopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getLocationCodePopupList", paramMap);
	}
}