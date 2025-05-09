package com.hr.tra.requestApproval.eduAppDet;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 교육신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("EduAppDetService")
public class EduAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 교육신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduAppDet(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String inOutType   = String.valueOf(convertMap.get("inOutType")); //사내/외 구분
		String eduSeq      = String.valueOf(convertMap.get("eduSeq"));     //과정순번
		String eduEventSeq = String.valueOf(convertMap.get("eduEventSeq")); //회차순번
		String eduOrgCd    = String.valueOf(convertMap.get("eduOrgCd")); //교육기관
		//String searchApplSeq = String.valueOf(convertMap.get("searchApplSeq")); //신청서순번
		
		//사내이면 교육신청(TTRA301)
		//사외이면 회차 존재 여부 확인 후 
		
		if( inOutType.equals("OUT") ){
			//-------------------------------------------------------------------
			//  교육기관 등록 ( TTRA001 )
			//-------------------------------------------------------------------
			if( eduOrgCd == null || eduOrgCd.equals("") ){  // 교육기관 등록.
				
				// 교육기관SEQ 조회
				paramMap.put("seqId","EDUORG");
				Map<?, ?> seqEduOrg = dao.getMap("getSequence", paramMap);
				eduOrgCd = String.valueOf(seqEduOrg.get("getSeq"));
				convertMap.put("eduOrgCd",eduOrgCd);
				
				//교육기관등록
				cnt += dao.update("insertEduAppDetEduOrg", convertMap);
			}

			//-------------------------------------------------------------------
			//  교육과정 등록 ( TTRA101 )
			//-------------------------------------------------------------------
			if( eduSeq == null || eduSeq.equals("") ){  // 교육과정 등록.
				// 교육과정SEQ 조회
				paramMap.put("seqId","EDU");
				Map<?, ?> eduSeqMap = dao.getMap("getSequence", paramMap);
				eduSeq = String.valueOf(eduSeqMap.get("getSeq"));
				convertMap.put("eduSeq",eduSeq);
				
				//교육과정등록
				cnt += dao.update("insertEduAppDetEdu", convertMap);
			}

			//-------------------------------------------------------------------
			//  교육회차 등록 ( TTRA121 )
			//-------------------------------------------------------------------
			//교육회차 중복 조회 
			Map<?, ?> evtDupMap = dao.getMap("getEduAppDetEduEvtDup", convertMap);

			if( evtDupMap == null || "".equals(String.valueOf(evtDupMap.get("eduEventSeq"))) || "null".equals(String.valueOf(evtDupMap.get("eduEventSeq"))) ){ //동일한 회차가 없으면 회차순번 생성
				
				paramMap.put("seqId","EDU");
				Map<?, ?> evtSeqMap = dao.getMap("getSequence", paramMap);
				eduEventSeq = String.valueOf(evtSeqMap.get("getSeq"));
				
				//교육회차등록
				convertMap.put("eduEventSeq",eduEventSeq);
				cnt += dao.update("insertEduAppDetEduEvt", convertMap);
				
			}else {//해당회차 사용

				convertMap.put("eduEventSeq", String.valueOf(evtDupMap.get("eduEventSeq")));
			}
				
		}

		//-------------------------------------------------------------------
		//  교육신청내역 등록 ( TTRA201 )
		//-------------------------------------------------------------------
		cnt += dao.update("saveEduAppDet", convertMap);
		
		return cnt;
	}
}