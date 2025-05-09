package com.hr.common.popup.cpnComPopup;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 급여 공통팝업 Service
 *
 * @author JM
 *
 */
@Service("CpnComPopupService")
public class CpnComPopupService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 진행상태확인팝업조회  Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getCpnProcessBarComPopupMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getCpnProcessBarComPopupMap", paramMap);
	}
}