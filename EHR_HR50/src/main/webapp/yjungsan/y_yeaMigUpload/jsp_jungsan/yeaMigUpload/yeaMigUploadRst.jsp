<%@page import="aab.fo"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//private Logger log = Logger.getLogger(this.getClass());

//이관업로드 동적필드 조회
public List selectHeaderList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	String tabNum = String.valueOf(pm.get("tabNum"));
	String searchTable  = "TYEA00";

	StringBuffer pTable   = new StringBuffer();
	pTable.setLength(0);
	 
	if(searchTable.trim().length() != 0){
		searchTable = searchTable+tabNum;
		pTable.append("AND TB_NM = '"+searchTable+"'");
	}

	pm.put("pTable"  , pTable.toString());
	try{
		//쿼리 실행및 결과 받기.
		list = DBConn.executeQueryList(queryMap,"selectHeaderList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	return list;
}

//이관업로드 관리 (기본정보 데이터 조회)
public List getColDataList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	// 기본정보 컬럼 수 (TYEA001)
	String cCnt = String.valueOf(pm.get("colCnt"));
	int colCnt  = Integer.parseInt(cCnt);

	String tabNum  = String.valueOf(pm.get("tabNum"));
	String searchWorkCd  = ""
;	String searchTable  = "TYEA00";

	StringBuffer colColumn  = new StringBuffer();
	StringBuffer tabTable   = new StringBuffer();
	StringBuffer WorkCd     = new StringBuffer();
	colColumn.setLength(0);
	tabTable.setLength(0);
	WorkCd.setLength(0);

	if(colCnt > 0){
		for(int i = 1; i < colCnt+1 ; i++){
			if(i == colCnt){
				colColumn.append("DATA_"+i+" AS COL_DATA");
			}else{
				colColumn.append("DATA_"+i+"||'_'||");
			}
		}
	}
	searchTable = searchTable+tabNum;
	if("3".equals(tabNum)){
		searchWorkCd  = String.valueOf(pm.get("searchWorkCd"));
		pm.put("WorkCd"  , "AND WORK_CD = '"+searchWorkCd.toString()+"'");
	}else{
		pm.put("WorkCd" ,"");
	}
	pm.put("colColumn"  , colColumn.toString());
	pm.put("tabTable"   , searchTable.toString());
		
	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"getColDataList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//이관업로드 관리 (기본정보 조회)
public List selectMigInfoMgrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	//String cCnt = String.valueOf(pm.get("colCnt"));
	//int colCnt  = Integer.parseInt(cCnt);

	StringBuffer InfoColumn1  = new StringBuffer();
	InfoColumn1.setLength(0);

	List list = null;

	String tabNum = String.valueOf(pm.get("tabNum"));
	String searchTable  = "TYEA00";

	StringBuffer pTable   = new StringBuffer();
	pTable.setLength(0);
	 
	if(searchTable.trim().length() != 0){
		searchTable = searchTable+tabNum;
		pTable.append("AND TB_NM = '"+searchTable+"'");
	}

	pm.put("pTable"  , pTable.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		list = DBConn.executeQueryList(queryMap,"selectHeaderList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	if ( !list.isEmpty() ){
		for ( int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>) list.get(i);
			String [] column_nm_arr = {};
			
			String header_col_nm = map.get("header_col_nm");
			
			column_nm_arr = header_col_nm.split("\\|");
			
			if ( column_nm_arr.length > 0 ){
				for ( int r=0; r<column_nm_arr.length; r++){
					InfoColumn1.append(", "+ column_nm_arr[r]);
				}
			}
		}
	}
	pm.put("InfoColumn1"  , InfoColumn1.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectMigInfoMgrList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//이관업로드 관리 (현근무지정보 조회)
public List selectMigCurWpMgrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	//String cCnt = String.valueOf(pm.get("colCnt"));
	//int colCnt  = Integer.parseInt(cCnt);

	StringBuffer curWpColumn1  = new StringBuffer();
	curWpColumn1.setLength(0);

	List list = null;

	String tabNum = String.valueOf(pm.get("tabNum"));
	String searchTable  = "TYEA00";

	StringBuffer pTable   = new StringBuffer();
	pTable.setLength(0);
	 
	if(searchTable.trim().length() != 0){
		searchTable = searchTable+tabNum;
		pTable.append("AND TB_NM = '"+searchTable+"'");
	}

	pm.put("pTable"  , pTable.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		list = DBConn.executeQueryList(queryMap,"selectHeaderList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	if ( !list.isEmpty() ){
		for ( int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>) list.get(i);
			String [] column_nm_arr = {};
			
			String header_col_nm = map.get("header_col_nm");
			
			column_nm_arr = header_col_nm.split("\\|");
			
			if ( column_nm_arr.length > 0 ){
				for ( int r=0; r<column_nm_arr.length; r++){
					curWpColumn1.append(", "+ column_nm_arr[r]);
				}
			}
		}
	}
	pm.put("curWpColumn1"  , curWpColumn1.toString());
	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectMigCurWpMgrList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//이관업로드 관리 (소득공제 조회)
public List selectIncomeDdctList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	//String cCnt = String.valueOf(pm.get("colCnt"));
	//int colCnt  = Integer.parseInt(cCnt);

	StringBuffer incomeDdctColumn  = new StringBuffer();
	incomeDdctColumn.setLength(0);

	List list = null;

	String tabNum = String.valueOf(pm.get("tabNum"));
	String searchTable  = "TYEA00";

	StringBuffer pTable   = new StringBuffer();
	pTable.setLength(0);
	 
	if(searchTable.trim().length() != 0){
		searchTable = searchTable+tabNum;
		pTable.append("AND TB_NM = '"+searchTable+"'");
	}

	pm.put("pTable"  , pTable.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		list = DBConn.executeQueryList(queryMap,"selectHeaderList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	if ( !list.isEmpty() ){
		for ( int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>) list.get(i);
			String [] column_nm_arr = {};
			
			String header_col_nm = map.get("header_col_nm");
			
			column_nm_arr = header_col_nm.split("\\|");
			
			if ( column_nm_arr.length > 0 ){
				for ( int r=0; r<column_nm_arr.length; r++){
					incomeDdctColumn.append(", "+ column_nm_arr[r]);
				}
			}
		}
	}
	pm.put("incomeDdctColumn"  , incomeDdctColumn.toString());
	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectIncomeDdctList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//이관업로드 관리 (세액감면세액공제 조회)
public List selectTaxReductDdctList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	//String cCnt = String.valueOf(pm.get("colCnt"));
	//int colCnt  = Integer.parseInt(cCnt);

	StringBuffer taxRdtDdctColumn  = new StringBuffer();
	taxRdtDdctColumn.setLength(0);

	List list = null;

	String tabNum = String.valueOf(pm.get("tabNum"));
	String searchTable  = "TYEA00";

	StringBuffer pTable   = new StringBuffer();
	pTable.setLength(0);
	 
	if(searchTable.trim().length() != 0){
		searchTable = searchTable+tabNum;
		pTable.append("AND TB_NM = '"+searchTable+"'");
	}

	pm.put("pTable"  , pTable.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		list = DBConn.executeQueryList(queryMap,"selectHeaderList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	if ( !list.isEmpty() ){
		for ( int i=0; i<list.size(); i++){
			Map<String, String> map = (Map<String, String>) list.get(i);
			String [] column_nm_arr = {};
			
			String header_col_nm = map.get("header_col_nm");
			
			column_nm_arr = header_col_nm.split("\\|");
			
			if ( column_nm_arr.length > 0 ){
				for ( int r=0; r<column_nm_arr.length; r++){
					taxRdtDdctColumn.append(", "+ column_nm_arr[r]);
				}
			}
		}
	}
	pm.put("taxRdtDdctColumn"  , taxRdtDdctColumn.toString());
	try{
		//쿼리 실행및 결과 받기.
		listData  = DBConn.executeQueryList(queryMap,"selectTaxReductDdctList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//이관업로드 관리 (저장)
public int saveMigUploadMgr(Map paramMap, String locPath) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map pm =  StringUtil.getParamMapData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.	
	Connection conn = DBConn.getConnection();
    int rstCnt = 0;

	StringBuffer colHeader  = new StringBuffer();
	StringBuffer colData  	= new StringBuffer();
	StringBuffer upColData  = new StringBuffer();
	
	
	String [] columnArry = {};
	
	colHeader.setLength(0);
	colData.setLength(0);
	upColData.setLength(0);

	// 기본정보 컬럼 수 (TYEA001)
	//String cCnt = String.valueOf(pm.get("colCnt"));
	//int colCnt  = Integer.parseInt(cCnt);

	//컬럼 치환변수
    String toStr   = "";
	
	Map hd = StringUtil.getParamMapData(paramMap);
	
	String tabNum = String.valueOf(hd.get("tabNum"));
	
	paramMap.put("tabNm", "TYEA00"+tabNum);
	
	String selectQueryDummy  = "";
	String updateQueryDummy  = " T.CHKDATE = SYSDATE" + ", T.CHKID   = '" + (String) paramMap.get("ssnSabun") + "'";
	String insertQueryDummy  = "T.CHKDATE, T.CHKID, T.ENTER_CD, T.WORK_YY, T.ADJUST_TYPE, T.SABUN"; 
	String valuesQueryDummy  = "SYSDATE, '" + (String) paramMap.get("ssnSabun") + "', S.ENTER_CD, S.WORK_YY, S.ADJUST_TYPE, S.SABUN";
	String deleteQueryDummy  = "";
	
	String selectQuery  = "";
	String updateQuery  = "";
	String insertQuery  = ""; 
	String valuesQuery  = "";
	String deleteQuery  = "";
	String deletePrev   = "ENTER_CD||'_'||WORK_YY||'_'||ADJUST_TYPE||'_'||SABUN";
	String onQuery      = "T.ENTER_CD	= S.ENTER_CD AND T.WORK_YY = S.WORK_YY AND T.ADJUST_TYPE = S.ADJUST_TYPE AND T.SABUN = S.SABUN";
	
	if ( "3".equals(tabNum)){
		selectQueryDummy  = "";
		updateQueryDummy  = " T.CHKDATE = SYSDATE" + ", T.CHKID   = '" + (String) paramMap.get("ssnSabun") + "'";
		insertQueryDummy  = "T.CHKDATE, T.CHKID, T.ENTER_CD, T.WORK_YY, T.ADJUST_TYPE, T.SABUN, T.WORK_CD"; 
		valuesQueryDummy  = "SYSDATE, '" + (String) paramMap.get("ssnSabun") + "', S.ENTER_CD, S.WORK_YY, S.ADJUST_TYPE, S.SABUN, S.WORK_CD";
		deleteQueryDummy  = "";
		deletePrev   = "ENTER_CD||'_'||WORK_YY||'_'||ADJUST_TYPE||'_'||SABUN||'_'||WORK_CD";
		onQuery           = "T.ENTER_CD	= S.ENTER_CD AND T.WORK_YY = S.WORK_YY AND T.ADJUST_TYPE = S.ADJUST_TYPE AND T.SABUN = S.SABUN AND T.WORK_CD = S.WORK_CD";
	}else{
		
	}
	
	paramMap.put("deletePrev", deletePrev);
	paramMap.put("onQuery", onQuery);
	
	//hd.put("tabNum", tabNum);//tabNum
	List<?> headerListData = selectHeaderList(hd, locPath);
	
//System.out.println("headerListData : " + headerListData);
	if ( !headerListData.isEmpty() ){
		for ( int r=0; r<headerListData.size(); r++ ){
//			System.out.println(headerListData.get(r));
			
			Map<String, String> map = (Map<String, String>) headerListData.get(r);
//System.out.println("map : " + map);
			String column_nm = map.get("column_nm");
//System.out.println("column_nm : " + column_nm);
			columnArry = column_nm.split("\\|");
		}
	}
	
//	System.out.println("columnArry : " + columnArry);
	
 	for ( int i=0; i<columnArry.length; i++){
 		insertQueryDummy = insertQueryDummy + ", T." + columnArry[i];
 		valuesQueryDummy = valuesQueryDummy + ", S." + columnArry[i];
 		updateQueryDummy = updateQueryDummy + ", T." + columnArry[i] + " = S." + columnArry[i];
	} 
	
	selectQuery = selectQueryDummy;
	updateQuery = updateQueryDummy;
	insertQuery = insertQueryDummy;
	valuesQuery = valuesQueryDummy;
	deleteQuery = deleteQueryDummy;
 	
	//System.out.println("columnArry : " + columnArry.toString());
	
	try{
		
//System.out.println("list : " + list);
		if(!list.isEmpty()){
			
			List updateList = new ArrayList();
			List deleteList = new ArrayList();
			
			for ( int i=0; i<list.size(); i++){
				Map<String, String> map = (Map<String, String>) list.get(i);
				
				String sStatus = (String)map.get("sStatus");
				
				if ( "I".equals(sStatus)){
					updateList.add(map);
				}else if ( "U".equals(sStatus) ){
					updateList.add(map);
				}else if ( "D".equals(sStatus) ){
					deleteList.add(map);
				}
			}
			
//System.out.println("updateList : " + updateList.size());
//System.out.println("deleteList : " + deleteList.size());
			
			//사용자가 직접 트랜젝션 관리
			conn.setAutoCommit(false);
			
			if(!deleteList.isEmpty()){
				
				int totCnt = deleteList.size();
				int chkCnt = 0;
				int nCnt = totCnt%100;
				
				for ( int i=0; i<deleteList.size(); i++){
					
					Map<String, String> map = (Map<String, String>) deleteList.get(i);
					
					if( totCnt >= chkCnt ){
						chkCnt++;
					}

					deleteQuery = deleteQuery + ",'" + (String) paramMap.get("ssnEnterCd") + "'||'_'||";
		 			deleteQuery = deleteQuery + "'" + String.valueOf(map.get("work_yy")) + "'||'_'||";
		 			deleteQuery = deleteQuery + "'" + String.valueOf(map.get("adjust_type")) + "'||'_'||";
		 			deleteQuery = deleteQuery + "'" + String.valueOf(map.get("sabun")) + "'";
		 			
		 			if ( "3".equals(tabNum)){
		 				deleteQuery = deleteQuery + "||'_'||'" + String.valueOf(map.get("work_cd")) + "'";
		 			}
					
					if ( chkCnt == 100 ){
					
						paramMap.put("deleteQuery", deleteQuery);
					 	rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteMigInfo", paramMap);
					 	
						totCnt = totCnt - chkCnt;
						chkCnt = 0;
					 	deleteQuery  = "";
						
					}else {
						if ( totCnt == nCnt && totCnt == chkCnt ){
							paramMap.put("deleteQuery", deleteQuery);
						 	rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteMigInfo", paramMap);
						 	deleteQuery  = "";
						}
					}
				}
			}
			
			if(!updateList.isEmpty()){
			
				int totCnt = updateList.size();
				int chkCnt = 0;
				int nCnt = totCnt%100;
				
				for ( int i=0; i<updateList.size(); i++){
					
					Map<String, String> map = (Map<String, String>) updateList.get(i);
					List<String> keyList = new ArrayList<>(map.keySet());
					
//					System.out.println("keyList : " + keyList);
					
					if( totCnt >= chkCnt ){
						chkCnt++;
					}
					
		 			if ( "".equals(selectQuery) ){
						selectQuery = selectQuery + "\n SELECT ";
					}else{
						selectQuery = selectQuery + "\n UNION ALL SELECT ";
					}
					
					selectQuery = selectQuery + "'" + (String) paramMap.get("ssnEnterCd") + "' AS ENTER_CD, ";
					selectQuery = selectQuery + "'" + String.valueOf(map.get("work_yy")) + "' AS WORK_YY, ";
					selectQuery = selectQuery + "'" + String.valueOf(map.get("adjust_type")) + "' AS ADJUST_TYPE, ";
					selectQuery = selectQuery + "'" + String.valueOf(map.get("sabun")) + "' AS SABUN, ";
					
		 			if ( "3".equals(tabNum)){
		 				selectQuery = selectQuery + "'" + String.valueOf(map.get("work_cd")) + "' AS WORK_CD, ";
		 			}
					
					// ENTER_CD|WORK_YY|ADJUST_TYPE|SABUN
					
				 	for ( int r=0; r<columnArry.length; r++){
				 		
				 		String column_nm = columnArry[r];
				 		
//System.out.println("column_nm : " + column_nm);
//System.out.println("map.get(column_nm.toLowerCase()) : " + map.get("DATA_37"));
//System.out.println("map.get(column_nm.toLowerCase()) : " + map.get("data_37"));
				 		
				 		if ( r==0 ){
				 			
				 			if ( "PRESIDENT_RES_NO".equals(column_nm) ){
						 		selectQuery = selectQuery + "CRYPTIT.ENCRYPT('" + map.get(column_nm.toLowerCase()) + "','" + (String) paramMap.get("ssnEnterCd") + "') AS " + column_nm;
				 			}else if ( "RES_NO".equals(column_nm) ){
						 		selectQuery = selectQuery + "CRYPTIT.ENCRYPT('" + map.get(column_nm.toLowerCase()) + "','" + (String) paramMap.get("ssnEnterCd") + "') AS " + column_nm;
				 			}else{
						 		selectQuery = selectQuery + "'" + map.get(column_nm.toLowerCase()) + "' AS " + column_nm;
				 			}
				 		}else{
				 			if ( "PRESIDENT_RES_NO".equals(column_nm) ){
						 		selectQuery = selectQuery + ", CRYPTIT.ENCRYPT('" + map.get(column_nm.toLowerCase()) + "','" + (String) paramMap.get("ssnEnterCd") + "') AS " + column_nm;
				 			}else if ( "RES_NO".equals(column_nm) ){
						 		selectQuery = selectQuery + ", CRYPTIT.ENCRYPT('" + map.get(column_nm.toLowerCase()) + "','" + (String) paramMap.get("ssnEnterCd") + "') AS " + column_nm;
				 			}else{
						 		selectQuery = selectQuery + ", '" + map.get(column_nm.toLowerCase()) + "' AS " + column_nm;
				 			}
				 		}
					} 
				 	selectQuery = selectQuery + "\n FROM DUAL ";
					
					if ( chkCnt == 100 ){
					
						paramMap.put("selectQuery", selectQuery);
						paramMap.put("updateQuery", updateQuery);
						paramMap.put("insertQuery", insertQuery);
						paramMap.put("valuesQuery", valuesQuery);
			
					 	rstCnt += DBConn.executeUpdate(conn, queryMap, "mergeMigInfo", paramMap);
					 	
						totCnt = totCnt - chkCnt;
						chkCnt = 0;
						
						selectQuery = "";
						updateQuery = updateQueryDummy;
						insertQuery = insertQueryDummy;
						valuesQuery = valuesQueryDummy;
					 	
					}else {
						if ( totCnt == nCnt && totCnt == chkCnt ){
							paramMap.put("selectQuery", selectQuery);
							paramMap.put("updateQuery", updateQuery);
							paramMap.put("insertQuery", insertQuery);
							paramMap.put("valuesQuery", valuesQuery);
				
						 	rstCnt += DBConn.executeUpdate(conn, queryMap, "mergeMigInfo", paramMap);
						 	
							selectQuery = "";
							updateQuery = updateQueryDummy;
							insertQuery = insertQueryDummy;
							valuesQuery = valuesQueryDummy;
						}
					}
				}
			}
			
			//System.out.println("selectQuery : " + selectQuery);
			//System.out.println("updateQuery : " + updateQuery);
			//System.out.println("insertQuery : " + insertQuery);
			//System.out.println("valuesQuery : " + valuesQuery);
				
		}
		conn.commit();
		
	} catch(UserException e) {
		try {
			//롤백
			conn.rollback();
		} catch (Exception e1) {
			Log.Error("[rollback Exception] " + e);
		}
		rstCnt = 0;
		Log.Error("[Exception] " + e);
		throw new Exception(e.getMessage());
	} catch(Exception e) {
		try {
			//롤백
			conn.rollback();
		} catch (Exception e1) {
			Log.Error("[rollback Exception] " + e);
		}
		rstCnt = 0;
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	} finally {
		DBConn.closeConnection(conn, null, null);
		queryMap = null;
	}

/* 	if(list != null && list.size() > 0) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);

		//colData 초기화 체크 변수
		int enterChk1 = 0;
		int enterChk2 = 1;

		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
              	Map mp2 = (Map)list.get(0);
              	String menuNm = (String)mp2.get("menuNm");
              	mp.put("menuNm", menuNm);

              	enterChk1 = i;

              	if("I".equals(sStatus)) {
                  	if(colCnt > 0){
                  		for(int j = 1; j < colCnt+1; j++ ) {
                  			if(enterChk1 == enterChk2){
                  				//한 대상자의 동적 컬럼 데이터 세팅 완료 후 초기화
                  				colData.delete(0, colData.length());
                  				enterChk2++;
                  			}
                  			toStr = Integer.toString(j);
                  			if(i == 0){
                  				//최초 진입 시에만 컬럼명 세팅
                  				colHeader.append(", DATA_"+toStr);
                  			}
                  			if("".equals((String)mp.get("data_"+toStr))){
                  				colData.append(",''");
                  			}else{
                  				colData.append(","+(String)mp.get("data_"+toStr));	
                  			}
                      	}
                  	}
              	} else if("U".equals(sStatus)) {
             		for(int k = 1; k < colCnt+1; k++ ) {
             			if(enterChk1 == enterChk2){
              				//한 대상자의 동적 컬럼 데이터 세팅 완료 후 초기화
              				upColData.delete(0, upColData.length());
              				enterChk2++;
             			}
             			toStr = Integer.toString(k);
             			if("".equals((String)mp.get("data_"+toStr))){
             				upColData.append(", DATA_"+toStr + " = " + "''");
             			}else{
             				upColData.append(", DATA_"+toStr + " = '" + (String)mp.get("data_"+toStr)+"'");	
             			}
                  	}
              	}

              	mp.put("colHeader"  , colHeader.toString());
              	mp.put("colData"    , colData.toString());
              	mp.put("upColData"  , upColData.toString());

              	if("2".equals((String)mp2.get("tabNum"))){
              		//기본정보
					if("D".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteMigInfo", mp);
					} else if("U".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateMigInfo", mp);
					} else if("I".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "insertMigInfo", mp);
					}
              	} else if("3".equals((String)mp2.get("tabNum"))){
              		//현근무지정보
					if("D".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteMigCurWp", mp);
					} else if("U".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateMigCurWp", mp);
					} else if("I".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "insertMigCurWp", mp);
					}
              	} else if("4".equals((String)mp2.get("tabNum"))){
              		//소득공제
					if("D".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteMigIncomeDdct", mp);
					} else if("U".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateMigIncomeDdct", mp);
					} else if("I".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "insertMigIncomeDdct", mp);
					}
              	}  else if("5".equals((String)mp2.get("tabNum"))){
              		//세액감면세액공제
					if("D".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteMigTaxReductDdct", mp);
					} else if("U".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateMigTaxReductDdct", mp);
					} else if("I".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "insertMigTaxReductDdct", mp);
					}
              	}
				saveLog(conn, mp);
			}
			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception("저장에 실패하였습니다.");
		} finally {
			DBConn.closeConnection(conn, null, null);
		}
	} */
	return rstCnt;
}
%>
<%
	String locPath = xmlPath+"/yeaMigUpload/yeaMigUpload.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectHeaderList".equals(cmd)) {
		//이관업로드 동적필드 조회
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectHeaderList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);

		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("getColDataList".equals(cmd)){
		//이관업로드 관리 (기본정보 데이터 조회)
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getColDataList(mp, locPath, ssnYeaLogYn);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectMigInfoMgrList".equals(cmd)){
		//이관업로드 관리 (기본정보 조회)
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectMigInfoMgrList(mp, locPath, ssnYeaLogYn);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectMigCurWpMgrList".equals(cmd)){
		//이관업로드 관리 (현근무지정보 조회)
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectMigCurWpMgrList(mp, locPath, ssnYeaLogYn);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectIncomeDdctList".equals(cmd)){
		//이관업로드 관리 (소득공제 조회)
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectIncomeDdctList(mp, locPath, ssnYeaLogYn);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	}  else if("selectTaxReductDdctList".equals(cmd)){
		//이관업로드 관리 (소득공제 조회)
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectTaxReductDdctList(mp, locPath, ssnYeaLogYn);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (List)listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("saveMigUploadMgr".equals(cmd)) {
		//이관업로드 관리 (기본정보 저장)

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = saveMigUploadMgr(mp, locPath);

			if(cnt > 0) {
				message = "저장되었습니다.";
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>