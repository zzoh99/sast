package com.hr.hrm.appmtBasic.appmtItemMapMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 발령처리담당자관리 Service
 *
 * @author 
 *
 */
@Service("AppmtItemMapMgrService")
public class AppmtItemMapMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 발령처리담당자관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtItemMapMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtItemMapMgrList", paramMap);
	}

	/**
	 * 발령처리담당자관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtItemMapMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppmtItemMapMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtItemMapMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	public List<?> getPostItemPropList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPostItemPropList", paramMap);
	}
}