package com.hr.tim.request.vacationUpdApr;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근태취소승인관리 Service
 *
 * @author bckim
 *
 */
@Service("VacationUpdAprService")
public class VacationUpdAprService{

	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * vacationUpdApr 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getVacationUpdAprList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getVacationUpdAprList", paramMap);
	}

	/**
	 * 근태취소승인관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveVacationUpdApr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteVacationUpdApr103", convertMap);
			cnt += dao.delete("deleteVacationUpdApr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

}