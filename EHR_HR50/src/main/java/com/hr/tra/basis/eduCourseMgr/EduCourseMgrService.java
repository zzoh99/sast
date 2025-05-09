package com.hr.tra.basis.eduCourseMgr;

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
 * 교육과정관리 Service
 *
 * @author
 *
 */
@SuppressWarnings("unchecked")
@Service("EduCourseMgrService")
public class EduCourseMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 교육과정관리 - 교육과정관리 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduCourseMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduCourseMgrList", paramMap);
	}

	/**
	 * 교육담당자 개인정보 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getEduCourseMgrUserInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		Map<?, ?> resultMap = dao.getMap("getEduCourseMgrUserInfo", paramMap);
		Log.Debug();
		return resultMap;
	}

	/**
	 * 교교육과정관리-교육분류 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduMBranchMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduMBranchMgrList", paramMap);
	}

	/**
	 *  교육과정관리 - 교육과정관리 (다건) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduCourseMgrSheet(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduCourseMgrSheet", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduCourseMgrSheet", convertMap);
		}

		return cnt;
	}

	/**
	 *  교육과정관리 - 교육과정관리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduCourseMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduCourseMgr", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduCourseMgr", convertMap);
		}

		return cnt;
	}


	/**
	 * 교육과정 세부내역 저장 (과정/회차 저장) Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduCourseMgrDet(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("seqId","EDU");
		
		String eduSeq      = String.valueOf(convertMap.get("eduSeq"));
		String eduEventSeq = String.valueOf(convertMap.get("eduEventSeq"));
		
		if( eduSeq == null || eduSeq.equals("")){
			// 교육과정SEQ 조회
			Map<?, ?> seqMax = dao.getMap("getSequence", paramMap);
			if(seqMax != null) {
				eduSeq = String.valueOf(seqMax.get("getSeq"));
			}
			
			//교육과정 신규 등록
			convertMap.put("eduSeq", eduSeq);
		}
		//교육과정 저장
		cnt += dao.update("saveEduCourseMgr", convertMap);

		if( eduEventSeq == null || eduEventSeq.equals("")){
			//중복회차 체크
			Map<String, String> chkEvt = (Map<String, String>) dao.getMap("getEduEventMgrDupChk", convertMap);
			String chkEvtCnt = "";
			if(chkEvt != null) {
				chkEvtCnt = String.valueOf(chkEvt.get("cnt"));
			}
			if(!"0".equals(chkEvtCnt) ){
				return -99;
			}

			Map<?, ?> seqMax = dao.getMap("getSequence", paramMap);
			if(seqMax != null) {
				eduEventSeq = String.valueOf(seqMax.get("getSeq"));
			}
			convertMap.put("eduEventSeq", eduEventSeq);
		}

		//교육회차 등록
		cnt += dao.update("saveEduEventMgr", convertMap); 

		//강사내역 삭제
		cnt += dao.delete("deleteEduCourseTeacher", convertMap);  
		
		//강사내역 등록
		if( convertMap.get("mergeRows") != null && ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("insertEduCourseTeacher", convertMap); 
		}

		//관련역량 삭제
		cnt += dao.delete("deleteEduMgrComptyAll", convertMap);  
		
		//관련역량 등록
		if( convertMap.get("cmtyRows") != null && ((List<?>)convertMap.get("cmtyRows")).size() > 0){
			cnt += dao.update("insertEduMgrCompty", convertMap); 
		}

		return cnt;
	}

	/**
	 * 교육과정관리 관련역량 Popup 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduMgrComptyList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduMgrComptyList", paramMap);
	}

	/**
	 * 교육과정관리 관련역량-역량분류표 Popup 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEduMgrComptyStdList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getEduMgrComptyStdList", paramMap);
	}

	/**
	 *  교육과정관리 관련역량 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduMgrCompty(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;

		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteEduMgrCompty", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveEduMgrCompty", convertMap);
		}

		return cnt;
	}
}
