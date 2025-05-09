package com.hr.tra.outcome.required.requiredMgr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.com.ComService;
import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.common.util.ParamUtils;

/**
 * 필수교육과정 대상자관리 Service
 * 
 * @author 이름
 *
 */
@SuppressWarnings("unchecked")
@Service("RequiredMgrService")  
public class RequiredMgrService {
	
	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("ComService")
	private ComService comService;

	/**
	 *  필수교육과정 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRequiredMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = 1;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("deleteRows"));
			dao.batchUpdate("deleteRequiredMgr", (List<Map<?,?>>)convertMap.get("deleteRows")); //TTRA161삭제
			dao.batchUpdate("deleteRequiredMgr201", (List<Map<?,?>>)convertMap.get("deleteRows")); //TTRA201삭제
			dao.batchUpdate("deleteRequiredMgr103", (List<Map<?,?>>)convertMap.get("deleteRows")); //TTRA103삭제
			dao.batchUpdate("deleteRequiredMgr107", (List<Map<?,?>>)convertMap.get("deleteRows")); //TTRA107삭제
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("mergeRows"));
			dao.batchUpdate("saveRequiredMgr", (List<Map<?,?>>)convertMap.get("mergeRows"));
		}
		return cnt;
	}
	

	

	/**
	 * 필수교육과정 - 입과 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveRequiredMgrApp(Map<String, Object> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			
			List<?> list = ((List<?>)convertMap.get("mergeRows"));
			
			for(int i=0; i < list.size(); i++){
				
				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("year",		String.valueOf(map.get("year")));
				paramMap.put("sabun",		String.valueOf(map.get("sabun")));
				paramMap.put("gubunCd",		String.valueOf(map.get("gubunCd")));
				paramMap.put("eduSeq",		String.valueOf(map.get("eduSeq")));
				paramMap.put("eduYm",		String.valueOf(map.get("eduYm")));

				//입과여부
				Map<?, ?> eduAppMap = dao.getMap("getRequiredMgrEduApp", map);
				String eduAppCnt = String.valueOf(eduAppMap.get("cnt")); //입과여부
				if( eduAppCnt != null && !eduAppCnt.equals("") && !eduAppCnt.equals("0") ){
					//재입과 대상자 생성
					cnt += dao.update("saveRequiredMgrEmp", map); 
					
					String eduYm = String.valueOf(map.get("eduYm"));
					paramMap.put("eduYm",	DateUtil.getMonthAddTight( eduYm.substring(0, 4), eduYm.substring(4, 6), 1) ); //다음달.
					
				}
				//교육회차순번 검색
				Map<?, ?> seqMax = dao.getMap("getRequiredMgrEvtSeq", paramMap);
				if( seqMax == null || seqMax.get("eduEventSeq") == null || "".equals(String.valueOf(seqMax.get("eduEventSeq")))){
					paramMap.put("err", "해당월에 교육회차가 없습니다.");
					dao.update("saveRequiredMgrErr", paramMap); 
				}else{
					paramMap.put("eduEventSeq", String.valueOf(seqMax.get("eduEventSeq")));
					
					Log.Debug(paramMap.toString());
					
					HashMap<String, Object> returnMap = (HashMap<String, Object>) dao.excute("prcRequiredMgrApp", paramMap);

					String sqlErr = String.valueOf(returnMap.get("sqlErrm"));
					if("".equals(sqlErr) || "null".equals(sqlErr) ) {
						paramMap.put("applSeq", String.valueOf(returnMap.get("sqlCode")));
						paramMap.put("err", "");
					}else{
						paramMap.put("eduEventSeq", "");
						paramMap.put("applSeq", "");
						paramMap.put("err", sqlErr);
					}
					dao.update("saveRequiredMgrErr", paramMap);  
					
					if( returnMap.get("sqlErrm") == null || String.valueOf(returnMap.get("sqlErrm")) == "" ){
						cnt += 1 ;
					}
					
				}
			
			}
		}
		Log.Debug();
		return cnt;
	}

	/**
	 * 필수교육과정 - 대상자생성 프로시저
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map prcRequiredMgr(Map<?, ?> paramMap) throws Exception {
		Log.Debug("prcRequiredMgr");
		return (Map) dao.excute("prcRequiredMgr", paramMap);
	}
}