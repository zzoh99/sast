package com.hr.pap.intern.internAppSubMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 인사소위원회관리 Service
 * 
 * @author 이름
 *
 */
@Service("InternAppSubMgrService")  
public class InternAppSubMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 인사소위원회관리 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getInternAppSubMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getInternAppSubMgrList", paramMap);
	}	
	/**
	 *  인사소위원회관리 단건 조회 Service 
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> getInternAppSubMgrMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getInternAppSubMgrMap", paramMap);
	}
	/**
	 * 인사소위원회관리 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveInternAppSubMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteInternAppSubMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveInternAppSubMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}


}