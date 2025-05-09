package com.hr.hrm.other.empInfoChangeMailMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 메뉴명 Service
 * 
 * @author 이름
 *
 */
@Service("EmpInfoChangeMailMgrService")  
public class EmpInfoChangeMailMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 메뉴명 다건 조회 Service
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpInfoChangeMailMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEmpInfoChangeMailMgrList", paramMap);
	}	
	/**
	 * 메뉴명 저장 Service
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEmpInfoChangeMailMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEmpInfoChangeMailMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEmpInfoChangeMailMgr", convertMap);
		}
		
		return cnt;
	}
}