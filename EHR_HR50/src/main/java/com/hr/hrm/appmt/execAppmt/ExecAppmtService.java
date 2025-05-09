package com.hr.hrm.appmt.execAppmt;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 발령처리 Service
 *
 * @author bckim
 *
 */
@Service("ExecAppmtService")
public class ExecAppmtService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 발령처리 권한 정보 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getExecAppmtAuthInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getExecAppmtAuthInfo", paramMap);
	}

	/**
	 * 발령처리 다건 조회 Service :페이징된 목록 ( 발령상세내역도 같이 조회)
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getExecAppmtList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExecAppmtList", paramMap);
	}
	/**
	 * 발령 다건조회, 페이징없음, 발령상세내역 조회하지 않음
	 * 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getExecAppmtList2(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExecAppmtList2", paramMap);
	}

	public List<?> getExecAppmtSoredList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExecAppmtSoredList", paramMap);
	}
	/**
	 * 발령처리 단건 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getExecAppmtMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getExecAppmtMap", paramMap);
	}

	/**
	 * 발령세부내역 팝업(발령항목) 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getExecAppmtPopColumMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getExecAppmtPopColumMap", paramMap);
	}

	/**
	 * 발령세부내역 팝업(발령전내역) 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getExecAppmtPopBeforeMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getExecAppmtPopBeforeMap", paramMap);
	}

	/**
	 * 발령세부내역 팝업(발령후내역) 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getExecAppmtPopAfterMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getExecAppmtPopAfterMap", paramMap);
	}

	/**
	 * 발령 APPLY_SEQ 조회 Service
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> getExecAppmtApplySeqMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getExecAppmtApplySeqMap", paramMap);
	}

	/**
	 * 발령처리 삭제 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int deleteExecAppmt(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExecAppmt", convertMap);
		}
		Log.Debug();
		return cnt;
	}
	
	/**
	 * 발령처리 시스템 기준값 가져오기
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public Map<?, ?> getSystemStdValue(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getSystemStdValue", paramMap);
	}

	
	public Map<?, ?> getPunishSeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPunishSeq", paramMap);
	}

	/**
	 * 발령처리 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public int saveExecAppmt(Map<?, ?> convertMap, Map<?, ?> convertMap2) throws Exception {
		Log.Debug();
		int cnt=0;
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			cnt += dao.delete("deleteExecAppmt", convertMap);
		}
		if( ((List<?>)convertMap2.get("deleteRows")).size() > 0){
			dao.delete("deleteExecAppmt2", convertMap2);
		}
		//징계발령
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteExecAppmt3", convertMap);
		}
		//육아휴직발령
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			dao.delete("deleteExecAppmt4", convertMap);
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			cnt += dao.update("saveExecAppmt", convertMap);
		}
		if( ((List<?>)convertMap2.get("mergeRows")).size() > 0){
			dao.update("saveExecAppmt2", convertMap2);
		}
		
		List<Map<String,Object>> mergeList = (List<Map<String,Object>>) convertMap.get("mergeRows");

		if( mergeList.size() > 0){
			for(Map<String,Object> mp : mergeList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );
				
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("ssnEnterCd", convertMap.get("ssnEnterCd")); //회사코드
				paramMap.put("searchStdCd",  "PUNISH_ORD_DETAIL_CD");
				
				Map<?, ?> resultMap1 = dao.getMap("getSystemStdValue", paramMap);
				String punish = "";
				if(resultMap1 != null) {
					punish = String.valueOf(resultMap1.get("CodeNm"));
				}
				//징계발령
				Log.Debug("징계 시스템 기준 값 ====================>" + resultMap1);
				Log.Debug("징계 시스템 기준 값 ====================>" + punish);
				Log.Debug("징계 발령형태 ====================>" + mp.get("ordTypeCd"));
				
				
				Map<String, Object> paramMap2 = new HashMap<String, Object>();
				paramMap2.put("ssnEnterCd", convertMap.get("ssnEnterCd")); //회사코드
				paramMap2.put("searchStdCd",  "REST_CHILD_ORD_DETAIL_CD");
				
				Map<?, ?> resultMap2 = dao.getMap("getSystemStdValue", paramMap2);
				String hol = "";
				if(resultMap2 != null) {
					hol  = String.valueOf(resultMap2.get("CodeNm"));
				}
				
				Log.Debug("육아휴직 시스템 기준 값 ====================>" + resultMap2);
				
				if(punish.equals(mp.get("ordTypeCd"))) {
					Log.Debug("징계 데이터 저장!!!");
					dao.update("saveExecAppmt3", mp);
				}
				
				/*
				if("N".equals(mp.get("ordTypeCd"))) {
					dao.update("saveExecAppmt3", mp);
				}
				*/
				///육아휴직
				if(hol.equals(mp.get("ordDetailCd")) && mp.get("famres") != null && ((String)mp.get("famres")).length() > 0) {
					dao.update("saveExecAppmt4", mp);
				}
				/*
				if("C01".equals(mp.get("ordDetailCd")) && mp.get("famres") != null && ((String)mp.get("famres")).length() > 0) {
					dao.update("saveExecAppmt4", mp);
				}
				*/
			}
		}
		
		/*List<Map<String,Object>> mergeList = (List<Map<String,Object>>)convertMap.get("mergeRows");

		if( mergeList.size() > 0){
			for(Map<String,Object> mp : mergeList) {
				mp.put("ssnEnterCd", convertMap.get("ssnEnterCd") );
				mp.put("ssnSabun", convertMap.get("ssnSabun") );

				cnt += dao.update("saveExecAppmt", mp);

				if("K3".equals(mp.get("ordTypeCd")) && mp.get("dispatchOrgCd") != null && ((String)mp.get("dispatchOrgCd")).length() > 0) {
					dao.update("saveExecAppmt227", mp);
				}
			}
		}*/


		Log.Debug();
		return cnt;
	}

	/**
	 * 발령처리 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<Map<?, ?>> prcExecAppmtSave(List<Map<String,Object>> mergeList) throws Exception {
		Log.Debug();
		List<Map<?, ?>> result = new ArrayList<Map<?, ?>>();
		if( mergeList.size() > 0){
			for(Map<String,Object> mp : mergeList) {

				// 직책변경 - 직책부여시 권한그룹 추가
				if("M01".equals(mp.get("ordDetailCd")) ) {
					dao.update("saveExecAppmtAuthGrp", mp);
				}

				// 직책변경 - 직책해제시 권한그룹 삭제
				if("M02".equals(mp.get("ordDetailCd"))) {
					dao.delete("deleteExecAppmtAuthGrp", mp);
				}

				result.add((Map<?, ?>) dao.excute("prcExecAppmtSave", mp));
			}
		}
		return result;
	}
	/**
	 * 발령처리 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map<?, ?> prcExecAppmtSave(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map<?, ?>) dao.excute("prcExecAppmtLaregeSave", paramMap);
	}

	/**
	 * 발령처리 취소 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public List<Map<?, ?>> prcExecAppmtCancel(List<Map<String,Object>> mergeList) throws Exception {
		Log.Debug();
		List<Map<?, ?>> result = new ArrayList<Map<?, ?>>();
		if( mergeList.size() > 0){
			for(Map<String,Object> mp : mergeList) {

				// 직책변경 - 직책부여시 권한그룹 부여건 회수
				if("M01".equals(mp.get("ordDetailCd"))) {
					dao.update("deleteExecAppmtAuthGrp", mp);
				}

				result.add((Map<?, ?>) dao.excute("prcExecAppmtCancel", mp));
			}
		}
		return result;
	}
	
	/**
	 * callP_COM_SET_LOG 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> callP_COM_SET_LOG(Map<?, ?> paramMap) throws Exception {
		Log.Debug("callP_COM_SET_LOG");
		Log.Debug("Jco paramMap====================>" + paramMap);
		return (Map<?, ?>) dao.excute("callP_COM_SET_LOG", paramMap);
	}

	public List<?> getEmployeePostInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmployeePostInfo", paramMap);
	}
	
	public List<?> getPostItemPropList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPostItemPropList", paramMap);
	}
	public Map<?, ?> getExecAppmtCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getExecAppmtCnt", paramMap);
	}
	public List<?> getPostDetailTypeList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getPostDetailTypeList", paramMap);
	}
	public Map<?, ?> getMaxApplySeq(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMaxApplySeq", paramMap);
	}
	
	public Map<?, ?> getPostDupChk(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getPostDupChk", paramMap);
	}
	
	public Map<?, ?> getOrdTypeYn(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getOrdTypeYn", paramMap);
	}
	
	public Map<?, ?> getMainDeptCnt(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMainDeptCnt", paramMap);
	}
	
	public List<?> getExecAppmtMdHstListPop(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getExecAppmtMdHstListPop", paramMap);
	}
	

	public Map<?, ?> getOrdTypeStatusCd(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getOrdTypeStatusCd", paramMap);
	}
	
	
}