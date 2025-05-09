package com.hr.pap.evaluation.app1st2nd;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 1차/2차 평가 Service
 *
 * @author jcy
 *
 */
@Service("App1st2ndService")
public class App1st2ndService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 1차/2차 평가 다건 조회 Service(업적평가 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApp1st2ndPopKpiList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getApp1st2ndPopKpiList", paramMap);
	}

	/**
	 *  1차/2차 평가 단건 조회 Service (업적평가 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getApp1st2ndPopKpiMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getApp1st2ndPopKpiMap", paramMap);
	}

	/**
	 * 1차/2차 평가 다건 조회 Service(역량평가 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getApp1st2ndPopCompetencyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getApp1st2ndPopCompetencyList", paramMap);
	}

	/**
	 *  1차/2차 평가 단건 조회 Service (역량평가 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getApp1st2ndPopCompetencyMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getApp1st2ndPopCompetencyMap", paramMap);
	}

	/**
	 * 1차/2차 평가 저장 Service(업적평가 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveApp1st2ndPopKpi(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveApp1st2ndPopKpi", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 1차/2차 평가 저장 Service(업적평가 본인의견 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveApp1st2ndPopKpi350(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveApp1st2ndPopKpi350", convertMap);

		Log.Debug();
		return cnt;
	}

	/**
	 * 1차/2차 평가 저장 Service(역량평가 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveApp1st2ndPopCompetency(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveApp1st2ndPopCompetency", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 1차/2차 평가 저장 Service(리스트 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveApp1st2ndClassCd350(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveApp1st2ndClassCd350", convertMap);
		}

		Log.Debug();
		return cnt;
	}

	/**
	 * 1차/2차 평가 저장 Service(역량평가 본인의견 저장)
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveApp1st2ndPopCompetency350(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveApp1st2ndPopCompetency350", convertMap);

		Log.Debug();
		return cnt;
	}

	/**
	 * 1차/2차 평가 저장 -  - (업적평가 저장)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcApp1st2ndPopKpi(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcApp1st2ndPopKpi", paramMap);
	}
    
	/**
     *  1차 평가 배분율 정보 단건 조회 Service (업적평가 조회)
     * 
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public Map<?, ?> getApp1st2ndPointInfoMap(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return dao.getMap("getApp1st2ndPointInfoMap", paramMap);
    }
    
}