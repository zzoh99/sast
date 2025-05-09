package com.hr.hrm.appmtBasic.appmtCodeMgr;
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
@Service("AppmtCodeMgrService")
public class AppmtCodeMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 발령형태코드 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtCodeMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppmtCodeMgr1", convertMap);
			dao.delete("deleteAppmtCodeMgr2", convertMap);
			dao.delete("deleteAppmtUserMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtCodeMgr1", convertMap);
			//cnt += dao.update("saveAppmtCodeMgr2", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 발령담당자 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtUserMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppmtUserMgr2", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppmtUserMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

    public List<?> getAppmtCodeMgrList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getAppmtCodeMgrList", paramMap);
    }

    public List<?> getAppmtUserMgrList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getAppmtUserMgrList", paramMap);
    }

    public List<?> getAppmtCodeDetailMgrList(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (List<?>) dao.getList("getAppmtCodeDetailMgrList", paramMap);
    }

    public int saveAppmtCodeDetailMgr(Map<?, ?> convertMap) throws Exception {
        Log.Debug();
        int cnt=0;
        if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
            cnt += dao.delete("deleteAppmtCodeDetailMgr", convertMap);
        }
        if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
            cnt += dao.update("saveAppmtCodeDetailMgr", convertMap);
        }
        Log.Debug();
        return cnt;
    }
}