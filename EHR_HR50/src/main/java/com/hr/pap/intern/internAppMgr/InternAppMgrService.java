package com.hr.pap.intern.internAppMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 수습평가 Service
 * 
 * @author 
 *
 */
@Service("InternAppMgrService")  
public class InternAppMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 수습평가 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternAppMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternAppMgrList", paramMap);
	}	
	
	/**
	 * 공지사항 clob저장
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternAppMgrByGuide(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.updateClob("saveInternAppMgrByGuide", convertMap);
		return cnt;
	}		


}