package com.hr.tim.annual.annualPlanStaMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 연차휴가계획관리 Service
 *
 * @author bckim
 *
 */
@Service("AnnualPlanStaMgrService")
public class AnnualPlanStaMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 연차휴가계획관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualPlanStaMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualPlanStaMgrList", paramMap);
	}
	
	/**
	 * 연차휴가계획관리 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAnnualPlanStaMgrList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAnnualPlanStaMgrList2", paramMap);
	}

	/**
	 * 연차휴가계획관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAnnualPlanStaMgr(Map convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if(((List<?>)convertMap.get("deleteRows")).size() > 0) {
			cnt += dao.delete("deleteAnnualPlanStaMgr", convertMap);
			if(cnt < 1){
				return cnt;
			}
		}
		
		//입력과 수정을가 있는 데이터와 없는 데이터를 구분한다
		if(((List<?>)convertMap.get("mergeRows")).size() > 0) {
			String spplSeq="";
			String applSabun="";
			if(((List<?>)convertMap.get("insertRows")).size() > 0){
				for (int j = 0; j < ((List<?>)convertMap.get("insertRows")).size(); j++) {
					Map mergeMap=(Map) ((List<?>)convertMap.get("insertRows")).get(j);
					if("".equals(spplSeq)) {
						Map paramMap=new HashMap();
						paramMap.put("seqId","APPL");
						spplSeq=""+((Map)dao.getMap("getSequence", paramMap)).get("getSeq");
					}
					mergeMap.put("applSeq", spplSeq);
					applSabun=""+mergeMap.get("sabun");
					((List)convertMap.get("insertRows")).set(j,mergeMap);
				}				
				cnt = 0;
				convertMap.put("mergeRows", convertMap.get("insertRows"));
				cnt += dao.update("saveAnnualPlanStaMgr", convertMap);
				if(cnt==0){
					return cnt;
				}
				cnt=0;
				Map mergeMap=new HashMap();
				mergeMap.put("searchApplSeq", spplSeq);
				mergeMap.put("applStatusCd", "99");
				mergeMap.put("fileSeq", "");
				mergeMap.put("searchApplSabun", applSabun);
				mergeMap.put("searchSabun", convertMap.get("ssnSabun"));
				mergeMap.put("ssnEnterCd", convertMap.get("ssnEnterCd"));
				mergeMap.put("ssnSabun", convertMap.get("ssnSabun"));
				mergeMap.put("searchApplCd", "26");
				mergeMap.put("applTitle", "휴가계획신청");
				cnt += dao.update("saveApprovalMgrMaster", mergeMap);
				if(cnt < 1){
					return cnt;
				}
			}
			
			if(((List<?>)convertMap.get("updateRows")).size() > 0){
				cnt = 0;
				convertMap.put("mergeRows", convertMap.get("updateRows"));
				cnt += dao.update("saveAnnualPlanStaMgr", convertMap);
				if(cnt < 1){
					return cnt;
				}
			}
			
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 연차휴가계획관리 확정 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public Map saveAnnualPlanStaMgrConfirm(Map convertMap) throws Exception {
		Log.Debug();
		Map result=null;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
				//int cnt=0; 
				//cnt += dao.update("saveAnnualPlanStaMgrConfirm", convertMap);
				//if(cnt==0){
					//return result;
				//}else{
			result=(Map) dao.excute("CallAnnualPlanStaMgrConfirm", convertMap);					
				//}
		}
		Log.Debug();
		return result;
	}

}