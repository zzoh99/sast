package com.hr.tim.request.vacationUpdAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 근태취소신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("VacationUpdAppDetService")
public class VacationUpdAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 근태취소신청 세부내역 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveVacationUpdAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveVacationUpdAppDet", convertMap);
		
		Log.Debug();
		return cnt;
	}
}