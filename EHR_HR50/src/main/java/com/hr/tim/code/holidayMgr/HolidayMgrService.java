package com.hr.tim.code.holidayMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 휴일관리 Service
 *
 * @author bckim
 *
 */
@Service("HolidayMgrService")
public class HolidayMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 휴일관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getHolidayMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHolidayMgrList", paramMap);
	}

	/**
	 *  휴일관리 count Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getHolidayMgrCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getHolidayMgrCnt", paramMap);
	}

	/**
	 * 휴일관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveHolidayMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteHolidayMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveHolidayMgr", convertMap);
		}
		
		return cnt;
	}

	/**
	 * 휴일관리 전년도 복사 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int copyHolidayMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		dao.delete("deleteHolidayMgrAll", paramMap);
		int cnt = dao.create("copyHolidayMgr", paramMap);
		
		return cnt;
	}
}