package com.hr.hrm.psnalInfoUpload;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
/**
 * 급여코드관리 Service
 * 
 * @author 이름
 *
 */
@Service("PsnalInfoUploadService")  
public class PsnalInfoUploadService{
	@Inject
	@Named("Dao")
	private Dao dao;
	/**
	 * 엑셀업로드 테이블 정보조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getTableInfoList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTableInfoList", paramMap);
	}

	/**
	 * 엑셀업로드 테이블 정보조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getTableNameList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getTableNameList", paramMap);
	}
	/**
	 * 엑셀업로드 테이블 정보조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<?> getTableOtherList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getHrmApplyTypeUserAppList", paramMap);
	}

	/**
	 * 인사 업로드 조회
	 * 
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getPsnalInfoUploadList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>) dao.getList("getPsnalInfoUploadList", paramMap);
	}
	//savePerPayYearStd
	/**
	 * 엑셀 업로드 입력
	 * 
	 * @param convertMap
	 * @return int
	 * @throws Exception
	 */
	//20240730 사용안함 jyp
	/*public int insertPsnalInfoUpload(Map<?, ?> convertMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("insertPsnalInfoUpload", convertMap);
		return cnt;
	}*/
	/**
	 * 엑셀업로드 수정
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
//	20240717 jyp 사용안함처리	
//	public int updatePsnalInfoUpload(Map<?, ?> convertMap) throws Exception {
//		Log.Debug();
//		int cnt = dao.update("updatePsnalInfoUpload", convertMap);
//		return cnt;
//	}
	/**
	 * 엑셀업로드 삭제
	 * @param convertMap
	 * @return
	 * @throws Exception
	 */
	/* 20240717 jyp 사용안함
	public int deletePsnalInfoUpload(Map<?, ?> convertMap) throws Exception {

		Log.Debug();
		int cnt = dao.update("deletePsnalInfoUpload", convertMap);
		return cnt;
	}
	
	 */
	/**
	 * 엑셀 업로드 추가 수정 삭제
	 * @param iudDataList
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public int iudPsnalInfoUpload(List<Serializable> iudDataList) throws Exception {
		Log.Debug();
		HashMap <String,Object> convertMap = null;
		int cnt = 0;
		String iudFlag = "";
		for(int i=0; i<iudDataList.size(); i++) {
			convertMap = (HashMap<String,Object>)iudDataList.get(i);
			iudFlag = convertMap.get("iudFlag").toString();
			
			if(iudFlag.equals("I") || iudFlag.equals("U")) {
				cnt += dao.update("mergePsnalInfoUpload", convertMap);
			} else if(iudFlag.equals("D")) {
				cnt += dao.delete("deletePsnalInfoUpload", convertMap);
			}
			/*
			if(iudFlag.equals("I")) {
				cnt += dao.update("insertPsnalInfoUpload", convertMap);
			} else if(iudFlag.equals("U")) {
				cnt += dao.update("updatePsnalInfoUpload", convertMap);
			} else if(iudFlag.equals("D")) {
				cnt += dao.delete("deletePsnalInfoUpload", convertMap);
			}
			*/
		}
		return cnt;
	}
	
	/**
	 * 엑셀 업로드 추가 수정 삭제
	 * @param iudDataList
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public int iudPsnalInfoUpload3(Map<?,?> convertMap) throws Exception {
		Log.Debug();

		int cnt=0;
		
		if( ((List<?>)convertMap.get("deleteRows")).size() > 0){
			
			List<?> list = ((List<?>)convertMap.get("deleteRows"));
			
			Map<String, Object> param = new HashMap<String, Object>();
			
			String deleteQuery = "";
			
			String tableName = (String) convertMap.get("searchTableName");
			param.put("tableName", tableName);
			
			List<?> tableInfoList = (List<?>) dao.getList("getTableInfoList", param);
			
			if ( !tableInfoList.isEmpty()) {
				
				param.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
				param.put("ssnSabun",(String) convertMap.get("ssnSabun"));
				
					for(int g=0; g < list.size(); g++) {
						
						deleteQuery = deleteQuery + " ENTER_CD = '" + (String) convertMap.get("ssnEnterCd") + "' ";
						HashMap<String, String> listMap  =  (HashMap<String, String>)list.get(g);
					
						for ( int i=0; i<tableInfoList.size(); i++) {
							
							Map<String, Object> rtn = (Map<String, Object>)tableInfoList.get(i);
							
							if ( "P".equals(rtn.get("pkType"))) {
								deleteQuery = deleteQuery + " AND " + rtn.get("columnCd") + " = '" + 
										((null != listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) && !"null".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))))) ? listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) : "" )
										+ "'";
							}else if ( "S".equals(rtn.get("pkType"))) {
								deleteQuery = deleteQuery + " AND " + rtn.get("columnCd") + " = '" + 
										((null != listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) && !"null".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))))) ? listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) : "" )
										+ "'";
							}
						}
					
					param.put("deleteQuery", deleteQuery);
					
					cnt += dao.delete("deletePsnalInfoUpload3", param);
					deleteQuery = "";
				}
			}
		}
		
		if( ((List<?>)convertMap.get("mergeRows")).size() > 0){
			
			List<?> list = ((List<?>)convertMap.get("mergeRows"));
		
			Map<String, Object> param = new HashMap<String, Object>();
			
			String selectQuery = "";
			String updateQuery = "";
			String insertQuery = "";
			String valuesQuery = "";
			String onValsQuery = "";
			

			String tableName = (String) convertMap.get("searchTableName");
			param.put("tableName", tableName);
			
			List<?> tableInfoList = (List<?>) dao.getList("getTableInfoList", param);
			
			if ( !tableInfoList.isEmpty()) {
				
				param.put("ssnEnterCd",(String) convertMap.get("ssnEnterCd"));
				param.put("ssnSabun",(String) convertMap.get("ssnSabun"));
				
				
				for(int g=0; g < list.size(); g++) {
					
					selectQuery = "'" + (String) convertMap.get("ssnEnterCd") + "' AS ENTER_CD";
					
					insertQuery = " T.ENTER_CD";
					updateQuery = " T.CHKDATE = SYSDATE" + ", T.CHKID   = '" + (String) convertMap.get("ssnSabun") + "'";
					valuesQuery = " S.ENTER_CD";
					onValsQuery = " T.ENTER_CD = S.ENTER_CD";
					
					HashMap<String, String> listMap  =  (HashMap<String, String>)list.get(g);
				
					for ( int i=0; i<tableInfoList.size(); i++) {
						
						Map<String, Object> rtn = (Map<String, Object>)tableInfoList.get(i);
						
						if ( "twoWay".equals(rtn.get("cryptKey")) ) {
							selectQuery = selectQuery + ", " + ((null != listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) && !"null".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd")))) && !"".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd")))) ) ? "CRYPTIT.ENCRYPT('"+listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd")))+"', '"+(String) convertMap.get("ssnEnterCd")+"')" : "''" )+ " AS " + rtn.get("columnCd");
						}else if ( "oneWay".equals(rtn.get("cryptKey")) ) {
							selectQuery = selectQuery + ", " + ((null != listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) && !"null".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd")))) && !"".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd")))) ) ? "CRYPTIT.CRYPT('"+listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd")))+"', '"+(String) convertMap.get("ssnEnterCd")+"')" : "''" )+ " AS " + rtn.get("columnCd");
						}else {
							if ( "S".equals(rtn.get("pkType"))) {
								selectQuery = selectQuery + ", " + ((null != listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) && !"null".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd")))) && !"".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd")))) ) ? 
										" '" + listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) + "' AS " 
										: " TO_CHAR( (" + 
										"SELECT (NVL(MAX(TO_NUMBER(" + rtn.get("columnCd") + ")), 0) + 1)" + 
										" FROM " + tableName + " " + 
										" WHERE ENTER_CD = TRIM( '" + (String) convertMap.get("ssnEnterCd") + "' ))) " + " AS "
									) + rtn.get("columnCd");
							}else {
								selectQuery = selectQuery + ", '" + ((null != listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) && !"null".equals(listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))))) ? listMap.get(StringUtil.getCamelize((String)rtn.get("columnCd"))) : "" )+ "' AS " + rtn.get("columnCd");
							}
						}
						
						if ( "P".equals(rtn.get("pkType"))) {
							onValsQuery = onValsQuery + " AND T." + rtn.get("columnCd") + " = S." + rtn.get("columnCd");
						}else if ( "S".equals(rtn.get("pkType"))) {
							onValsQuery = onValsQuery + " AND T." + rtn.get("columnCd") + " = S." + rtn.get("columnCd");
						}else {
							updateQuery = updateQuery + ", T." + rtn.get("columnCd") + " = S." + rtn.get("columnCd");
						}
						insertQuery = insertQuery + ", T." + rtn.get("columnCd");
						valuesQuery = valuesQuery + ", S." + rtn.get("columnCd");
					}
					insertQuery = insertQuery + ", T.CHKDATE";
					valuesQuery = valuesQuery + ", SYSDATE";
					
					insertQuery = insertQuery + ", T.CHKID";
					valuesQuery = valuesQuery + ", '" + (String) convertMap.get("ssnSabun") + "'";
					
					param.put("selectQuery", selectQuery);
					param.put("updateQuery", updateQuery);
					param.put("insertQuery", insertQuery);
					param.put("valuesQuery", valuesQuery);
					param.put("onValsQuery", onValsQuery);
					
					selectQuery = "";
					updateQuery = "";
					insertQuery = "";
					valuesQuery = "";
					onValsQuery = "";
					
					cnt += dao.update("savePsnalInfoUpload3", param);
				}
			}
		}
		
		return cnt;
	}
}