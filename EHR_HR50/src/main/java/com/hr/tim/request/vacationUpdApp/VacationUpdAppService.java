package com.hr.tim.request.vacationUpdApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근태취소신청 Service
 *
 * @author bckim
 *
 */
@Service("VacationUpdAppService")
public class VacationUpdAppService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근태취소신청 잔여근태내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationUpdAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationUpdAppList", paramMap);
	}

	/**
	 * 근태취소신청 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationUpdAppExList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationUpdAppExList", paramMap);
	}

	/**
	 * 근태취소신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveVacationUpdAppEx(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteVacationUpdAppEx103", convertMap);
			cnt += dao.delete("deleteVacationUpdAppEx107", convertMap);
			cnt += dao.delete("deleteVacationUpdAppEx", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}