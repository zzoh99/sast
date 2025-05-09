package com.hr.tim.schedule.workOrgScheduleCre;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근무스케줄 생성 Service
 *
 * @author 
 *
 */
@Service("WorkOrgScheduleCreService")
public class WorkOrgScheduleCreService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근무스케줄 생성 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?,?> getWorkOrgScheduleCre(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>) dao.getMap("getWorkOrgScheduleCre", paramMap);
	}
	
	/**
	 * getWorkOrgScheduleProgress 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getWorkOrgScheduleProgress(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getWorkOrgScheduleProgress", paramMap);
		Log.Debug();
		return resultMap;
	}
	
	/**
	 * 근무스케줄 생성(처리) 프로시저 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcWorkOrgScheduleCre(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcWorkOrgScheduleCre", paramMap);
	}
	
	public Map prcWorkOrgScheduleCre2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();

		return (Map) dao.excute("prcWorkOrgScheduleCre2", paramMap);
	}


}