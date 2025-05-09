package com.hr.hrm.retire.retireAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 퇴직신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("RetireAppDetService")
public class RetireAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 퇴직신청 세부내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireAppDetList", paramMap);
	}

	/**
	 * 퇴직신청 결재자 구분 조회 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public Map<?,?> getRetireGb(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getRetireGb", paramMap);
	}

	/**
	 * 퇴직신청 세부내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireAppDet", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 퇴직신청(퇴직설문지) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireSurveyPopList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireSurveyPopList", paramMap);
	}
	
	/**
	 * 퇴직신청(퇴직설문지 저장데이터 없을시 항목관리에서 가져오기) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireSurveyPopList1(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireSurveyPopList1", paramMap);
	}
	
	/**
	 * 퇴직신청(퇴직설문지-불만 이하 리스트) 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getRetireSurveyPopDisList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getRetireSurveyPopDisList", paramMap);
	}
	
	/**
	 * 퇴직신청 퇴직설문지 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRetireSurveyPopList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveRetireSurveyPopList", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 퇴직신청 설문지 등록여부 조회 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public Map<?,?> getRetireSurveyYnMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getRetireSurveyYnMap", paramMap);
	}
}