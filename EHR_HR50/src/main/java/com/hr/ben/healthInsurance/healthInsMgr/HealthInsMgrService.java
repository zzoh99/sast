package com.hr.ben.healthInsurance.healthInsMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 건강보험기본사항 Service
 *
 * @author JM
 *
 */
@Service("HealthInsMgrService")
public class HealthInsMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 건강보험기본사항 기본사항TAB 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHealthInsMgrBasicMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getHealthInsMgrBasicMap", paramMap);
	}

	/**
	 * 건강보험기본사항 변동내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHealthInsMgrChangeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getHealthInsMgrChangeList", paramMap);
	}

	/**
	 * 건강보험기본사항 불입내역TAB 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHealthInsMgrPaymentList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (List<?>) dao.getList("getHealthInsMgrPaymentList", paramMap);
	}

	/**
	 * 건강보험기본사항 기본사항TAB 저장 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHealthInsMgrBasic(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		int cnt = dao.update("saveHealthInsMgrBasic", paramMap);

		return cnt;
	}

	/**
	 * 건강보험기본사항 변동내역TAB 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHealthInsMgrChange(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHealthInsMgrChange", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHealthInsMgrChange", convertMap);
		}

		return cnt;
	}
	/**
	 * 보험료 가져오기 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSelfMonLongTermCareMon(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSelfMonLongTermCareMon", paramMap);
	}
	/**
	 * 보험료 가져오기 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return dao.getMap("getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON", paramMap);
	}
}