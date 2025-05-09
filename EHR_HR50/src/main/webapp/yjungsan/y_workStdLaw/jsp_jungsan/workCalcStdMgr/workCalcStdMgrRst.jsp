<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
 
<%@ page import="org.json.*" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//private Logger log = Logger.getLogger(this.getClass());
//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//근태/근무산정기준관리 조회
public List selectWorkCalcStdMgrList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	String searchSYm = String.valueOf(pm.get("searchSYm"));
	String searchEYm = String.valueOf(pm.get("searchEYm"));
	StringBuffer query  = new StringBuffer();
	query.setLength(0);
// 	if(searchSYm.trim().length() != 0 || searchEYm.trim().length() != 0){
// 		query.append(" AND (T1.S_YM BETWEEN REPLACE('"+searchSYm+"', '-', '') AND REPLACE('"+searchSYm+"', '-', '') OR  T1.E_YM BETWEEN REPLACE('"+searchEYm+"', '-', '') AND REPLACE('"+searchEYm+"', '-', ''))");
// 	}
	if (searchSYm.trim().length() != 0) {
		query.append(" AND (T1.S_YM >= REPLACE('" + searchSYm + "', '-', '') OR REPLACE('" + searchSYm + "', '-', '') BETWEEN T1.S_YM AND NVL(T1.E_YM, '999912'))");
	}
	if (searchEYm.trim().length() != 0) {
		query.append(" AND (NVL(T1.E_YM, '999912') <= REPLACE('" + searchEYm + "', '-', '') OR REPLACE('" + searchEYm + "', '-', '') BETWEEN T1.S_YM AND NVL(T1.E_YM, '999912'))");
	}
		
	pm.put("query", query.toString());		
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectWorkCalcStdMgrList", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

public List selectWorkCalcStdMgrRngPopRstList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectWorkCalcStdMgrRngPopRstList", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

public Map<?, ?> selectWorkCalcStdMgrRngPopTempQueryMap(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	Map pm =  StringUtil.getParamMapData(paramMap);
	
	Map<?, ?> mapData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		mapData  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap, "selectWorkCalcStdMgrRngPopTempQueryMap", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	return mapData;
}

public List selectWorkCalcStdMgrRngOrgPopList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectWorkCalcStdMgrRngOrgPopList", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

public List selectWorkCalcStdMgrRngPopRstList2(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectWorkCalcStdMgrRngPopRstList2", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

public List selectWorkCalcStdMgrRngPopRstList3(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectWorkCalcStdMgrRngPopRstList3", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

public List selectWorkCalcStdMgrRngPopRstList4(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectWorkCalcStdMgrRngPopRstList4", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

public List selectWorkCalcStdMgrRngPopRstList5(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectWorkCalcStdMgrRngPopRstList5", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}




//근태/근무산정기준관리 저장
public int saveWorkCalcStdMgr(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	if(conn != null && list != null && list.size() > 0) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		String ssnEnterCd = (String)paramMap.get("ssnEnterCd");
		String ssnSabun = (String)paramMap.get("ssnSabun");

		try{
			
			for(int i = 0; i < list.size(); i++ ) {
				//String query = "";
				Map mp = (Map)list.get(i);
				mp.put("ssnEnterCd", ssnEnterCd);
				mp.put("ssnSabun", ssnSabun);
				
				String sStatus = (String)mp.get("sStatus");
				if("D".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteWorkCalcStdMgr", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateWorkCalcStdMgr", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertWorkCalcStdMgr", mp);
				}
			}
			//커밋
			conn.commit();
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


//근태/근무산정기준관리 범위항목저장
public int saveWorkCalcStdMgrRngPop(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	if(conn != null && list != null && list.size() > 0) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		String ssnEnterCd = (String)paramMap.get("ssnEnterCd");
		String ssnSabun = (String)paramMap.get("ssnSabun");
		String searchUseGubun = (String)paramMap.get("searchUseGubun");
		String searchItemValue1 = (String)paramMap.get("searchItemValue1");
		String searchItemValue2 = (String)paramMap.get("searchItemValue2");
		String searchItemValue3 = (String)paramMap.get("searchItemValue3");
		String searchAuthScopeCd = (String)paramMap.get("searchAuthScopeCd");
	
		
		try{
			
			for(int i = 0; i < list.size(); i++ ) {
				//String query = "";
				Map mp = (Map)list.get(i);
				mp.put("ssnEnterCd", ssnEnterCd);
				mp.put("ssnSabun", ssnSabun);
				mp.put("searchUseGubun", searchUseGubun);
				mp.put("searchItemValue1", searchItemValue1);
				mp.put("searchItemValue2", searchItemValue2);
				mp.put("searchItemValue3", searchItemValue3);
				mp.put("searchAuthScopeCd", searchAuthScopeCd);
				
				String sStatus = (String)mp.get("sStatus");
				
				if("D".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteWorkCalcStdMgrRngPop", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertWorkCalcStdMgrRngPop", mp);
				}
				
			}
			//커밋
			conn.commit();
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


%>


<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectWorkCalcStdMgrList".equals(cmd)) {
		//원천징수부승인 대상자 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectWorkCalcStdMgrList(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);
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
	} else if("saveWorkCalcStdMgr".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = saveWorkCalcStdMgr(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);

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

	} else if("selectWorkCalcStdMgrRngPopRstList".equals(cmd)){
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectWorkCalcStdMgrRngPopRstList(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);
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
	} else if("selectWorkCalcStdMgrRngPopRstList2".equals(cmd)){
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			Map<?, ?> query = selectWorkCalcStdMgrRngPopTempQueryMap(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);
			
			if (query == null) {
				mp.put("query", "");
			} else {
				mp.put("query", query.get("query"));
			}
			
			listData = selectWorkCalcStdMgrRngPopRstList2(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);
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
	} else if("selectWorkCalcStdMgrRngPopRstList3".equals(cmd)){
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectWorkCalcStdMgrRngPopRstList3(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);
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
	} else if("selectWorkCalcStdMgrRngPopRstList4".equals(cmd)){
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectWorkCalcStdMgrRngPopRstList4(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);
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
	} else if("selectWorkCalcStdMgrRngPopRstList5".equals(cmd)){
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectWorkCalcStdMgrRngPopRstList5(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);
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
	} else if("saveWorkCalcStdMgrRngPop".equals(cmd)){
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("searchUseGubun", (String)request.getParameter("searchUseGubun"));
		mp.put("searchItemValue1", (String)request.getParameter("searchItemValue1"));
		mp.put("searchItemValue2", (String)request.getParameter("searchItemValue2"));
		mp.put("searchItemValue3", (String)request.getParameter("searchItemValue3"));
		mp.put("searchAuthScopeCd", (String)request.getParameter("searchAuthScopeCd"));

		String message = "";
		String code = "1";

		try {
			int cnt = saveWorkCalcStdMgrRngPop(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);

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
	} else if ("selectWorkCalcStdMgrRngOrgPopList".equals(cmd)){
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectWorkCalcStdMgrRngOrgPopList(xmlPath+"/workCalcStdMgr/workCalcStdMgr.xml", mp);
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