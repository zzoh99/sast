package com.hr.common.popup.orgCapaEmpPopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 월별 충원내역 팝업 Service
 *
 * @author JM
 *
 */
@Service("OrgCapaEmpPopupService")
public class OrgCapaEmpPopupService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 월별 충원내역 팝업조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getOrgCapaEmpList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getOrgCapaEmpList", paramMap);
	}
}