package com.hr.tra.requestApproval.eduApp;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 교육신청 Service
 * 
 * @author JSG
 *
 */
@Service("EduAppService")  
public class EduAppService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 교육신청 다건 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List getEduAppList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List)dao.getList("getEduAppList", paramMap);
	}

	/**
	 * 교육신청 임시서장 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteEduApp(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduApp1", convertMap);
			cnt += dao.delete("deleteEduApp2", convertMap);//TTRA101
			cnt += dao.delete("deleteEduApp3", convertMap);//TTRA121
			cnt += dao.delete("deleteEduApp4", convertMap);//TTRA001
			dao.delete("deleteApprovalMgrMaster", convertMap);
			dao.delete("deleteApprovalMgrAppLine", convertMap);
		}

		return cnt;
	}

	/**
	 * 교육결과보고 임시서장 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteEduAppResult(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduAppResult", convertMap);
			dao.delete("deleteApprovalMgrMaster2", convertMap);
			dao.delete("deleteApprovalMgrAppLine2", convertMap);
		}

		return cnt;
	}
	
}