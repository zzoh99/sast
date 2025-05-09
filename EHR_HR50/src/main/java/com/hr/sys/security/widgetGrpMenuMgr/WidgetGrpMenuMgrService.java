package com.hr.sys.security.widgetGrpMenuMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 권한그룹프로그램관리 Service
 * 
 * @author ParkMoohun
 *
 */
@Service("WidgetGrpMenuMgrService")  
public class WidgetGrpMenuMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	
	/**
	 * 권한그룹프로그램관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int insertWidgetGrpMenuMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.update("insertWidgetGrpMenuMgr", convertMap);
		}
		
		return cnt;
	}
	/**
	 * 권한그룹프로그램관리 삭제 Service
	 * 
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteWidgetGrpMenuMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.delete("deleteWidgetGrpMenuMgr", paramMap);
	}
	
	/**
	 * 위젯권한관리 그룹간 복사 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int copyWidgetGrpMenuMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		dao.delete("deleteWidgetGrpMenuMgrAll", paramMap);
		int cnt = dao.create("copyWidgetGrpMenuMgrAll", paramMap);
		
		return cnt;
	}
}