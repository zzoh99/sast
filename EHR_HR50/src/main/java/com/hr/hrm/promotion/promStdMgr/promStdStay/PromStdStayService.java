package com.hr.hrm.promotion.promStdMgr.promStdStay;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 승진기준관리 Service
 * 
 * @author 이름
 *
 */
@Service("PromStdStayService")  
public class PromStdStayService{
	
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 승진기준관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPromStdStayList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPromStdStayList", paramMap);
	}	
	
	/**
	 * 승진기준관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int savePromStdStay(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deletePromStdStay", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("savePromStdStay", convertMap);
		}
		Log.Debug();
		return cnt;
	}
}