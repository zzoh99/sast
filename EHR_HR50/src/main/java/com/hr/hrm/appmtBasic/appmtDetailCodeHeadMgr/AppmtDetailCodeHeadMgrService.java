package com.hr.hrm.appmtBasic.appmtDetailCodeHeadMgr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 발령형태코드관리 Service
 *
 * @author bckim
 *
 */
@Service("AppmtDetailCodeHeadMgrService")
public class AppmtDetailCodeHeadMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 발령형태코드 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtDetailCodeHeadMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtDetailCodeHeadMgrList", paramMap);
	}

	/**
	 * 발령세부코드 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtDetailCodeHeadMgrList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtDetailCodeHeadMgrList2", paramMap);
	}

	/**
	 * 발령코드 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtDetailCodeHeadMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppmtDetailCodeHeadAllMgr2", convertMap);
			cnt += dao.delete("deleteAppmtDetailCodeHeadMgr1", convertMap);
			dao.delete("deleteAppmtDetailUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtDetailCodeHeadMgr1", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 발령코드 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtDetailCodeHeadMgr2(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
		    cnt += dao.delete("deleteAppmtDetailCodeHeadMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtDetailCodeHeadMgr2", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * callP_SYS_GRCODE_COPY 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map callP_SYS_ORD_CODE_COPY(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_SYS_ORD_CODE_COPY");
		Log.Debug("Nomal paramMap====================>" + paramMap);
		return (Map) dao.excute("callP_SYS_ORD_CODE_COPY", paramMap);
	}

}