package com.hr.tim.annual.annualPlanAgrAppDet;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 휴가계획신청 세부내역 Service
 *
 * @author
 *
 */
@Service("AnnualPlanAgrAppDetService")
public class AnnualPlanAgrAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 휴가계획신청 건수 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAnnualPlanAgrAppDetMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap(paramMap.get("cmd").toString(), paramMap);
	}

	/**
	 * 휴가계획신청팝업 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualPlanAgrAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList(paramMap.get("cmd").toString(), paramMap);
	}

	/**
	 * 휴가계획신청팝업 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnnualPlanAgrAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		cnt += dao.update("saveAnnualPlanAgrAppDetMain", convertMap);

		// TTIM562 전체 삭제 후,
		dao.delete("deleteAnnualPlanAgrAppDetSub", convertMap);

		// TTIM562 INSERT
		cnt += dao.update("saveAnnualPlanAgrAppDetSub", convertMap);
		return cnt;
	}
}