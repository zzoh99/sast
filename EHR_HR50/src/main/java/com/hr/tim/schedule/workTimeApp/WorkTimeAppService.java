package com.hr.tim.schedule.workTimeApp;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 조직근무시간신청 Service
 *
 * @author
 *
 */
@Service("WorkTimeAppService")
public class WorkTimeAppService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * getWorkTimeAppList 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getWorkTimeAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getWorkTimeAppList", paramMap);
	}
	
	/**
	 * 조직근무시간신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWorkTimeApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteWorkTimeApp1", convertMap);
			cnt += dao.delete("deleteWorkTimeApp2", convertMap);
			dao.delete("deleteWorkTimeAppEx103", convertMap);
			dao.delete("deleteWorkTimeAppEx107", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}