package com.hr.tim.annual.annualPlanApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연차휴가계획신청  Service
 *
 * @author bckim
 *
 */
@Service("AnnualPlanAppService")
public class AnnualPlanAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연차휴가계획신청 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnnualPlanApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteThri103", convertMap);
			dao.delete("deleteThri107", convertMap);
			// TTIM543 개인휴가계획서 잔여일수 삭제
			dao.delete("deleteAnnualPlanCnt", convertMap);

			cnt += dao.delete("deleteAnnualPlanApp", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * annualPlanApp 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualPlanAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualPlanAppList", paramMap);
	}
	
	/**
	 * annualPlanApp 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getAbleAnnualPlanCount(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getAbleAnnualPlanCount", paramMap);
		Log.Debug();
		return resultMap;
	}
}