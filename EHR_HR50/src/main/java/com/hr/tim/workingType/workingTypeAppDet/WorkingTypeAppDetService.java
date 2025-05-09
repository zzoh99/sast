package com.hr.tim.workingType.workingTypeAppDet;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 휴직/복직/사직원 신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("WorkingTypeAppDetService")
public class WorkingTypeAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근로시간단축 신청 세부내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkingTypeAppDetList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkingTypeAppDetList", paramMap);
	}


	/**
	 * 근로시간단축 신청 세부내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveWorkingTypeAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveWorkingTypeAppDet", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/* 생년월일 */
	public List<?> getBirthYmd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getBirthYmd", paramMap);
	}

	/* 생년월일 */
	public List<?> getFlexChk(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getFlexChk", paramMap);
	}
}