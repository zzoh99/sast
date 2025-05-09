<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
 
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!

//권한그룹코드 검색
public List selectGrpCdList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectGrpCdList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return list;
}


//권한그룹프로그램 검색
public List selectAthGrpMenuMgrList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectAthGrpMenuMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return list;
}

//권한그룹프로그램 팝업 검색
public List selectAthGrpMenuMgrRegPopList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectAthGrpMenuMgrRegPopList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return list;
}

//권한그룹프로그램 팝업 저장.
public int saveAthGrpMenuMgrRegPop(Map paramMap, String locPath) throws Exception {
	
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
				
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteAthGrpMenuMgrRegPop", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateAthGrpMenuMgrRegPop", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertAthGrpMenuMgrRegPop", mp);
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
			queryMap = null;
		}
	}
	
	return rstCnt;
}

//프로그램 팝업 검색
public List selectPrgMgrPopList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectPrgMgrPopList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return list;
}

%>

<%
	//쿼리 맵 셋팅
	String locPath = xmlPath+"/auth/athGrpMenuMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectGrpCdList".equals(cmd)) {
		//권한그룹프로그램 코드 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectGrpCdList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", listData == null ? null : (List)listData);
		
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else if("selectAthGrpMenuMgrList".equals(cmd)) {
		//권한그룹프로그램 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectAthGrpMenuMgrList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData == null ? null : (List)listData);
		
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else	if("selectAthGrpMenuMgrRegPopList".equals(cmd)) {
		//권한그룹프로그램 팝업 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectAthGrpMenuMgrRegPopList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData == null ? null : (List)listData);
		
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	} else if("saveAthGrpMenuMgrRegPop".equals(cmd)) {
		//권한그룹프로그램 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveAthGrpMenuMgrRegPop(mp, locPath);
			
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
		
	} else	if("selectPrgMgrPopList".equals(cmd)) {
		//프로그램 팝업 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectPrgMgrPopList(mp, locPath);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData == null ? null : (List)listData);
		
		out.print((new org.json.JSONObject(rstMap)).toString());
		
	}
%>