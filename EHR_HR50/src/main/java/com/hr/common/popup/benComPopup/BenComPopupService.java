package com.hr.common.popup.benComPopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 복리후생 공통팝업 Service
 *
 * @author JM
 *
 */
@Service("BenComPopupService")
public class BenComPopupService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 조직맵핑구분검색팝업조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBenMapComPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getBenMapComPopupList", paramMap);
	}

	/**
	 * 기숙사동/호실검색팝업조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBenDongSilComPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getBenDongSilComPopupList", paramMap);
	}

	/**
	 * 인사마스타&기숙사업체인원팝업조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getBenEmployeeComPopupList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getBenEmployeeComPopupList", paramMap);
	}
}