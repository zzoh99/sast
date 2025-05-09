package com.hr.tim.request.vacationChangeAppDet;
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
@Service("VacationChangeAppDetService")
public class VacationChangeAppDetService{

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
	public int saveVacationChangeAppDet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("saveVacationChangeAppDet", convertMap);
		
		Log.Debug();
		return cnt;
	}
	
	public int insertVacationChangeAppDetList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("insertVacationChangeAppDetList", convertMap);
		
		Log.Debug();
		return cnt;
	}
	
	public int deleteVacationChangeAppDetList(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		cnt += dao.update("deleteVacationChangeAppDetList", convertMap);
		
		Log.Debug();
		return cnt;
	}

    public List<?> getVacationChangeAppDetChangeList(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getVacationChangeAppDetChangeList", paramMap);
    }

    public List<?> getVacationChangeAppDetList(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getVacationChangeAppDetList", paramMap);
    }

    public Map<?,?> getVacationChangeAppCheck(Map<String, Object> paramMap) throws Exception {
        Log.Debug();
        Map<?, ?> resultMap = dao.getMap("getVacationChangeAppCheck", paramMap);
        Log.Debug();
        return resultMap;
    }
}
