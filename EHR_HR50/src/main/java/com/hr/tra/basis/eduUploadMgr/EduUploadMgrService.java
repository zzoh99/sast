package com.hr.tra.basis.eduUploadMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
/**
 * 교육과정업로드 Service
 * 
 * @author 이름
 *
 */
@SuppressWarnings("unchecked")
@Service("EduUploadMgrService")  
public class EduUploadMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 교육과정업로드 저장 (과정/회차 저장) Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduUploadMgr(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		

		List<Map<String,Object>> mergeList = (List<Map<String,Object>>)convertMap.get("mergeRows");
		
		if( mergeList.size() > 0){
			for(Map<String,Object> mp : mergeList) {

				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("seqId","EDU");
				
				String eduSeq      = String.valueOf(mp.get("eduSeq"));
				String eduEventSeq = String.valueOf(mp.get("eduEventSeq"));
				String jobCd 	   = String.valueOf(mp.get("jobCd"));
				String jobNm 	   = String.valueOf(mp.get("jobNm"));
				String eduOrgCd    = String.valueOf(mp.get("eduOrgCd"));
				String eduOrgNm    = String.valueOf(mp.get("eduOrgNm"));
				
				if( eduSeq == null || eduSeq.equals("")){
					// 교육과정SEQ 조회
					Map<?, ?> seqMax = dao.getMap("getSequence", paramMap);
					if(seqMax != null) {
						eduSeq = String.valueOf(seqMax.get("getSeq"));
					}
					
					//교육과정 신규 등록
					mp.put("eduSeq", eduSeq);
				}
				//관련직무코드 조회
				if( jobCd == null || !jobNm.equals("")){
					
					Map<?, ?> jobMap = dao.getMap("getEduUploadMgrJobCd", mp);
					if( jobMap != null && jobMap.get("jobCd") != null ){
						jobCd = String.valueOf(jobMap.get("jobCd"));
						mp.put("jobCd", jobCd);
					}
					
				}
				//교육기관코드 조회
				if( eduOrgCd == null || !eduOrgNm.equals("")){
					
					Map<?, ?> eduOrgMap = dao.getMap("getEduUploadMgrEduOrgNm", mp);
					if( eduOrgMap != null && eduOrgMap.get("eduOrgCd") != null ){
						eduOrgCd = String.valueOf(eduOrgMap.get("eduOrgCd"));
						mp.put("eduOrgCd", eduOrgCd);
					}
				}
				
				//교육과정 저장
				cnt += dao.update("saveEduCourseMgr", mp);
		
				if( eduEventSeq == null || eduEventSeq.equals("")){
					Map<String, String> chkEvt = (Map<String, String>)dao.getMap("getEduEventMgrDupChk", mp);
					String chkEvtCnt = "";
					if(chkEvt != null) {
						chkEvtCnt = String.valueOf(chkEvt.get("cnt"));
					}
					Log.Debug("chkEvtCnt:"+chkEvtCnt);
					if(  !"0".equals(chkEvtCnt) ){
						return -99;
					}

					Map<?, ?> seqMax = dao.getMap("getSequence", paramMap);
					if(seqMax != null) {
						eduEventSeq = String.valueOf(seqMax.get("getSeq"));
					}
					mp.put("eduEventSeq", eduEventSeq);
				}
				


				
				//교육회차 등록
				cnt += dao.update("saveEduEventMgr", mp); 

				
			}
		}

		List<Map<String,Object>> deleteList = (List<Map<String,Object>>)convertMap.get("deleteRows");
		if( deleteList.size() > 0){
			//교육회차 삭제
			for(Map<String,Object> mp : deleteList) {
				cnt += dao.delete("deleteEduEventMgr", mp);
			}

			//교육과정 삭제
			for(Map<String,Object> mp : deleteList) {
				//회차가 1개도 없으면 과정삭제
				Map<?, ?> cntMap = dao.getMap("getEduUploadMgrEvtCnt", mp);
				if( cntMap != null && cntMap.get("cnt") != null && "0".equals(String.valueOf(cntMap.get("cnt")))){
					cnt += dao.delete("deleteEduCourseMgr", mp);
				}
			
			}
		}
		return cnt;
	}
}