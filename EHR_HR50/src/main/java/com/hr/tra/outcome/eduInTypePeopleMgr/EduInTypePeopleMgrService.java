package com.hr.tra.outcome.eduInTypePeopleMgr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 교육일괄신청 Service
 *
 * @author JSG
 *
 */
@SuppressWarnings("unchecked")
@Service("EduInTypePeopleMgrService")
public class EduInTypePeopleMgrService{
	@Inject
	@Named("Dao")
	private Dao dao;


	/**
	 * 엑셀업로드 후 검사 Service
	 *
	 * @param paramMap
	 * @return int
	 * @throws Exception
	 */
	public List<?> getEduInTypePeopleMgrChk(Map<?, ?> convertMap) throws Exception {
		Log.Debug();

		List<Map<String,Object>> mergeList = (List<Map<String,Object>>) convertMap.get("mergeRows");
		List<Map<String,Object>> returnRows = new ArrayList<Map<String,Object>>();
		
		if( mergeList.size() > 0){
			for(Map<String,Object> mp : mergeList) {

				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("sabun",		String.valueOf(mp.get("sabun")));
				paramMap.put("eduSeq",		String.valueOf(convertMap.get("searchEduSeq")));
				paramMap.put("eduEventSeq",	String.valueOf(convertMap.get("searchEduEventSeq")));
				
				//중복체크
				Map<?, ?> eduAppMap = dao.getMap("getEduInTypePeopleMgrEduApp", paramMap);
				if(eduAppMap != null) {
					String eduAppCnt = String.valueOf(eduAppMap.get("cnt")); 
					if(!eduAppCnt.equals("") && !eduAppCnt.equals("0") ){
						mp.put("chkResult", "0");
					}else{
						mp.put("chkResult", "1");
					}
				}
				returnRows.add(mp);
			}
		}
		return returnRows;
	}

	/**
	 * 교육일괄신청 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveEduInTypePeopleMgr(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=1;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){

			ParamUtils.mergeParams(convertMap, (List<Map<String, Object>>)convertMap.get("deleteRows"));
			dao.batchUpdate("deleteEduInTypePeopleMgr201", (List<Map<?,?>>)convertMap.get("deleteRows")); //TTRA201삭제
			dao.batchUpdate("deleteEduInTypePeopleMgr301", (List<Map<?,?>>)convertMap.get("deleteRows")); //TTRA201삭제
			dao.batchUpdate("deleteEduInTypePeopleMgr103", (List<Map<?,?>>)convertMap.get("deleteRows")); //TTRA103삭제
			dao.batchUpdate("deleteEduInTypePeopleMgr107", (List<Map<?,?>>)convertMap.get("deleteRows")); //TTRA107삭제
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){

			List<?> list = ((List<?>)convertMap.get("mergeRows"));
			
			for(int i=0; i < list.size(); i++){
 
				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("sabun",		String.valueOf(map.get("sabun")));
				paramMap.put("eduSeq",		String.valueOf(convertMap.get("searchEduSeq")));
				paramMap.put("eduEventSeq",	String.valueOf(convertMap.get("searchEduEventSeq")));
				
				//중복체크
				Map<?, ?> eduAppMap = dao.getMap("getEduInTypePeopleMgrEduApp", paramMap);
				if(eduAppMap != null ) {
					String eduAppCnt = String.valueOf(eduAppMap.get("cnt")); 
					if(!eduAppCnt.equals("") && !eduAppCnt.equals("0") ){
						throw new HrException("해당 교육 신청 내역이 존재합니다.\n( 사번 : "+String.valueOf(map.get("sabun"))+" )");
					}
				}
				
				HashMap<String, Object> returnMap = (HashMap<String, Object>) dao.excute("prcRequiredMgrApp", paramMap);

				String sqlErr = String.valueOf(returnMap.get("sqlErrm"));
				if(!"".equals(sqlErr) && !"null".equals(sqlErr) ) {
					throw new HrException("교육 신청서 생성 시 오류가 발생했습니다.\n"+sqlErr);
				}
			}
		}
		Log.Debug();
		return cnt;
	}
}