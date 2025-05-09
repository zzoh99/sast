package com.hr.common.recruitment;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 채용 서비스
 *
 * @author kwook
 *
 */
@Service("RecruitmentService")
public class RecruitmentService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 채용시스템_임직원 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getRemEmployeeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getRemEmployeeList", paramMap);
	}

	/**
	 * 시스템기준관리 코드값 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<?,?> getSystemStdCdValue(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getSystemStdData", paramMap);
	}

	/**
	 * 채용시스템_채용데이터 seq 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<?,?> getRemRecruitSeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?,?>)dao.getMap("getRemRecruitSeq", paramMap);
	}

	/**
	 * 채용시스템_채용 데이터 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int saveRecEmployee(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("saveRecEmployee", paramMap);
		if(cnt > 0) {
			dao.updateClob("saveRecEmployeePerson", paramMap);
		}
		return cnt;
	}
}