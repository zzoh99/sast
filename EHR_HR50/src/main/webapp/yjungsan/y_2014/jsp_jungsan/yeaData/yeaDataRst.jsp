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

<%!
//소득공제자료등록 마감 정보 조회
public Map selectYeaDataDefaultInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;
	
	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaDataDefaultInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return pm;
}

//특이사항 표시
public Map selectCheckClearYn(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;
	
	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectCheckClearYn",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return pm;
}

//특이사항 팝업 조회
public List selectUnusualPopupList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap==null) ? null : DBConn.executeQueryList(queryMap,"selectUnusualPopupList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//특이사항 팝업 저장
public int saveUnusualPopup(Map paramMap, String locPath) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(list != null && list.size() > 0 && conn != null) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				
				if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateUnusualPopup", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertUnusualPopup", mp);
				}
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
	}
	
	return rstCnt;
}

//소득공제자료등록 팝업 자료 조회
public List selectRes3List(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap==null) ? null : DBConn.executeQueryList(queryMap,"selectRes3List",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//소득공제자료등록 팝업 자료 조회
public List selectRes2List871(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		
		String gubun = (String)pm.get("searchGubun");
		pm.put("searchTable","");
		//pm.put("searchAnd","");
		
		if("1".equals(gubun)) {
			pm.put("searchTable","TCPN871");
		} else if("2".equals(gubun)) {
			pm.put("searchTable","TCPN841");
		} else {
			pm.put("searchTable","TCPN841_BK");
			// dynamic query 보안 이슈 때문에 수정
// 			pm.put("searchAnd","AND ORI_PAY_ACTION_CD = '"+(String)pm.get("searchPayActionCd")+"'" 
// 					+" AND RE_CALC_SEQ = '"+(String)pm.get("searchReCalcSeq")+"'" );
		}
		
		//쿼리 실행및 결과 받기.
		listData  = (queryMap==null) ? null : DBConn.executeQueryList(queryMap,"selectRes2List871",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//소득공제자료등록 팝업 자료 조회
public List selectRes5List873(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		
		String gubun = (String)pm.get("searchGubun");
		pm.put("searchTable","");
		//pm.put("searchAnd","");
		
		if("1".equals(gubun)) {
			pm.put("searchTable","TCPN873");
		} else if("2".equals(gubun)) {
			pm.put("searchTable","TCPN843");
		} else {
			pm.put("searchTable","TCPN843_BK");
			// dynamic query 보안 이슈 때문에 수정
// 			pm.put("searchAnd","AND ORI_PAY_ACTION_CD = '"+(String)pm.get("searchPayActionCd")+"'" 
// 					+" AND RE_CALC_SEQ = '"+(String)pm.get("searchReCalcSeq")+"'" );
		}
		
		//쿼리 실행및 결과 받기.
		listData  = (queryMap==null) ? null : DBConn.executeQueryList(queryMap,"selectRes5List873",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//소득공제자료등록 기본자료 조회
public List selectCommonSheetList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap==null) ? null : DBConn.executeQueryList(queryMap,"selectCommonSheetList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//소득공제자료등록 기본자료 저장
public int saveCommonSheet(Map paramMap, String locPath) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(list != null && list.size() > 0 && conn != null) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				
				if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateCommonSheet", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertCommonSheet", mp);
				}
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
	}
	
	return rstCnt;
}


//Tab카운트 표시
public Map selectTabCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;
	
	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectTabCnt",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return pm;
}

%>

<%
	String locPath = xmlPath+"/yeaData/yeaData.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataDefaultInfo".equals(cmd)) {
		//소득공제자료등록 마감 정보 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectYeaDataDefaultInfo(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)mapData);
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else 	if("selectCheckClearYn".equals(cmd)) {
		//특이사항 표시
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectCheckClearYn(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)mapData);
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else 	if("selectUnusualPopupList".equals(cmd)) {
		//특이사항 팝업 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectUnusualPopupList(mp, locPath);
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
		
	} else if("saveUnusualPopup".equals(cmd)) {
		//특이사항 팝업 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			
			int cnt = saveUnusualPopup(mp, locPath);
			
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
	} else if("prcYeaClose".equals(cmd)) {
		//일반사용자 마감처리
		
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};
		
		String message = "";
		String code = "1";
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_CLOSE",type,param);
			
			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n"+rstStr[1];
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
		
	} else if("prcYeaCloseCancel".equals(cmd)) {
		//일반사용자 마감처리 취소

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};
		
		String message = "";
		String code = "1";
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_CLOSE_CANCEL",type,param);
			
			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n"+rstStr[1];
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
	} else if("prcYeaCalc".equals(cmd)) {
		//일반사용자 세액계산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};
		
		String message = "";
		String code = "1";
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_EMP.P_MAIN",type,param);
			
			if( "".equals(rstStr[0]) ) {
				message = "";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n" + rstStr[1];
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
	} else if("prcYeaMgrClose".equals(cmd)) {
		//관리자 마감처리
		
		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};
		
		String message = "";
		String code = "1";
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_MGR_CLOSE",type,param);
			
			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n"+rstStr[1];
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
	} else if("prcYeaMgrCloseCancel".equals(cmd)) {
		//관리자 마감처리 취소

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};
		
		String message = "";
		String code = "1";
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_MGR_CLOSE_CANCEL",type,param);
			
			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n"+rstStr[1];
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
	} else 	if("selectRes3List".equals(cmd)) {
		//소득공제자료등록 팝업 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRes3List(mp, locPath);
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
		
	} else 	if("selectRes2List871".equals(cmd)) {
		//소득공제자료등록 팝업 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRes2List871(mp, locPath);
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
		
	} else 	if("selectRes5List873".equals(cmd)) {
		//소득공제자료등록 팝업 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRes5List873(mp, locPath);
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
		
	} else 	if("selectCommonSheetList".equals(cmd)) {
		//소득공제자료등록 기본 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectCommonSheetList(mp, locPath);
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
		
	} else if("saveCommonSheet".equals(cmd)) {
		//소득공제자료등록 기본 자료 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			
			int cnt = saveCommonSheet(mp, locPath);
			
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
	} else 	if("selectTabCnt".equals(cmd)) {
		//특이사항 표시
		
		Map mp = StringUtil.getRequestMap(request);
		
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectTabCnt(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)mapData);
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	}
%>