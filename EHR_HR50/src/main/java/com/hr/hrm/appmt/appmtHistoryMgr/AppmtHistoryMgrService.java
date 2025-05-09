package com.hr.hrm.appmt.appmtHistoryMgr;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;

/**
 * 발령내역수정 Service
 *
 * @author 이름
 *
 */
@Service("AppmtHistoryMgrService")
public class AppmtHistoryMgrService{

	@Inject
	@Named("Dao")
	private Dao dao;

	/**
	 * 발령내역수정(개인발령내역) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtHistoryMgrExecList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtHistoryMgrExecList", paramMap);
	}

	/**
	 * 발령내역수정(개인조직사항) 다건 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getAppmtHistoryMgrOrgList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getAppmtHistoryMgrOrgList", paramMap);
	}

	/**
	 * 발령내역수정(개인발령내역) 저장 Service
	 *
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	public int saveAppmtHistoryMgrExec(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt=0;
		HashMap<String, String> retMap ;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			//cnt += dao.delete("deleteAppmtHistoryMgrExec", convertMap);
			List<?> list = ((List<?>)convertMap.get("deleteRows"));
			for(int i=0; i < list.size(); i++){
				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);
				map.put("ssnEnterCd", String.valueOf(convertMap.get("ssnEnterCd")));
				map.put("ssnSabun",   String.valueOf(convertMap.get("ssnSabun")));
				map.put("modifyCmt",  String.valueOf(convertMap.get("modifyCmt")));
				map.put("modifyMode", "D");
				try {
					//추후 [발령처리] THRM223의 직전 발령이 정상 참조되도록 
					//발령처리 없이 [발령내역수정]에서 THRM191이 곧바로 수정되면 THRM223을 갱신하는 작업을 추가 진행함. 20220405
					dao.excute("prcAppmtHistorySync", map);				
				} catch(Exception e) {
					Log.Error(e.getMessage()) ;
					Log.Error(e.toString()) ;
				}
				cnt += 1;
			}
			
		}
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			
			List<?> list = ((List<?>)convertMap.get("mergeRows"));

			String selectQuery = "";
			String updateQuery = "";
			String insertQuery = "";
			String valuesQuery = "";
			

			for(int i=0; i < list.size(); i++){

				HashMap<String, String> map  =  (HashMap<String, String>)list.get(i);

				map.put("ssnEnterCd", String.valueOf(convertMap.get("ssnEnterCd")));
				map.put("ssnSabun",   String.valueOf(convertMap.get("ssnSabun")));
				map.put("modifyCmt",  String.valueOf(convertMap.get("modifyCmt")));
				map.put("modifyMode", "U");
				
				selectQuery = "'" + (String) convertMap.get("ssnEnterCd") + "' AS ENTER_CD";
				
				insertQuery = " T.ENTER_CD";
				updateQuery = " T.CHKDATE = SYSDATE" + ", T.CHKID   = '" + (String) convertMap.get("ssnSabun") + "'";
				valuesQuery = " S.ENTER_CD";
				
				
				String saveNameAry[] = ((String)convertMap.get("s_SAVENAME2")).split(",");
				
				for ( int g=0; g < saveNameAry.length; g++ ) {
					
					selectQuery = selectQuery + ", '" + (  !"null".equals(map.get(StringUtil.getCamelize(saveNameAry[g]))) ? map.get(StringUtil.getCamelize(saveNameAry[g])) : "" )+ "' AS " + saveNameAry[g];
					if ( !"SABUN".equals(saveNameAry[g]) && !"ORD_TYPE_CD".equals(saveNameAry[g]) && !"ORD_DETAIL_CD".equals(saveNameAry[g]) && !"ORD_YMD".equals(saveNameAry[g]) && !"APPLY_SEQ".equals(saveNameAry[g])) {
						updateQuery = updateQuery + ", T." + saveNameAry[g] + " = S." + saveNameAry[g];
					}
					insertQuery = insertQuery + ", T." + saveNameAry[g];
					valuesQuery = valuesQuery + ", S." + saveNameAry[g];
					
				}
				
				insertQuery = insertQuery + ", T.CHKDATE";
				valuesQuery = valuesQuery + ", SYSDATE";
				
				insertQuery = insertQuery + ", T.CHKID";
				valuesQuery = valuesQuery + ", '" + (String) convertMap.get("ssnSabun") + "'";
				
				map.put("selectQuery", selectQuery);
				map.put("updateQuery", updateQuery);
				map.put("insertQuery", insertQuery);
				map.put("valuesQuery", valuesQuery);

				cnt += dao.update("saveAppmtHistoryMgrExec", map);
				
				selectQuery = "";
				updateQuery = "";
				insertQuery = "";
				valuesQuery = "";

				try {
					//추후 [발령처리] THRM223의 직전 발령이 정상 참조되도록 
					//발령처리 없이 [발령내역수정]에서 THRM191이 곧바로 수정되면 THRM223을 갱신하는 작업을 추가 진행함. 20220405
					dao.excute("prcAppmtHistorySync", map);				
				} catch(Exception e) {
					Log.Error(e.getMessage()) ;
					Log.Error(e.toString()) ;
				}
				
			}
			
		}
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
	public Map prcAppmtHistoryEdateCreate(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (Map) dao.excute("prcAppmtHistoryEdateCreate", paramMap);
	}
	
	/**
	 * 발령처리 프로시저
	 *
	 * @param paramMap
	 * @return Map
	 * @throws Exception
	 */
	public Map prcAppmtHistoryCreate(Map<?, ?> paramMap) throws Exception {
		Log.DebugStart();
		return (Map) dao.excute("prcAppmtHistoryCreate", paramMap);
	}		
}