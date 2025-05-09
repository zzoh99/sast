package com.hr.hri.applyApproval.appPathMgr;

import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 개인 신청 결재 Service
 *
 * @author ParkMoohun
 *
 */

@Service("AppPathMgrService")
public class AppPathMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 개인 신청 결재 결재 경로 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathMgrList", paramMap);
	}
	/**
	 * 개인 신청 결재 결재자 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathMgrOrgUserList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathMgrOrgUserList", paramMap);
	}
	/**
	 * 개인 신청 결재 결재자 조직도 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathOrgList", paramMap);
	}
	/**
	 * 개인 신청 결재 결재선 내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathMgrApplList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathMgrApplList", paramMap);
	}
	/**
	 * 개인 신청 결재 참조 내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppPathMgrReferList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathMgrReferList", paramMap);
	}

	/**
	 * @param convertMap
	 * @return Int
	 * @throws Exception
	 */
	public int saveAppPathMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppPathMgr127", convertMap);
			cnt += dao.delete("deleteAppPathMgr105", convertMap);
			cnt += dao.delete("deleteAppPathMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppPathMgr", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * @param convertMap
	 * @return Int
	 * @throws Exception
	 */
	public int saveAppPathMgrAppl(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppPathMgrAppl", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppPathMgrAppl", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * @param convertMap
	 * @return Int
	 * @throws Exception
	 */
	public int saveAppPathMgrRefer(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteAppPathMgrRefer", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveAppPathMgrRefer", convertMap);
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 개인 신청 결재 결재선 내역 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getChar(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getChar", paramMap);
	}

	/**
     * 결재선지정(관리자) 기본결재선 생성(개인별) - 프로시저
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public Map prcAppPathMgrPsnlCrt(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map) dao.excute("prcAppPathMgrPsnlCrt", paramMap);
    }


    /**
     * 결재선지정(관리자) 기본결재선 생성(전인원) - 프로시저
     *
     * @param paramMap
     * @return List
     * @throws Exception
     */
    public Map prcAppPathMgrAllCrt(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        return (Map) dao.excute("prcAppPathMgrAllCrt", paramMap);
    }

	public List<?> getAppPathSeqCombo(Map<String, Object> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getAppPathSeqCombo", paramMap);
	}

}