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

//계산식관리 조회
public List selectCalcExpressionMgrList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	
	String srchYmFrom	= String.valueOf(pm.get("srchYmFrom"));
	String srchYmTo		= String.valueOf(pm.get("srchYmTo"));
	StringBuffer query  = new StringBuffer();
	query.setLength(0);
	
// 	if(srchYmFrom.trim().length() != 0 || srchYmTo.trim().length() != 0){
// 		query.append(" AND (A.S_YM BETWEEN REPLACE('"+srchYmFrom+"', '-', '') AND REPLACE('"+srchYmFrom+"', '-', '') OR  A.E_YM BETWEEN REPLACE('"+srchYmTo+"', '-', '') AND REPLACE('"+srchYmTo+"', '-', ''))");
// 	}
	if (srchYmFrom.trim().length() != 0) {
		query.append(" AND (A.S_YM >= REPLACE('" + srchYmFrom + "', '-', '') OR REPLACE('" + srchYmFrom + "', '-', '') BETWEEN A.S_YM AND NVL(A.E_YM, '999912'))");
	}
	if (srchYmTo.trim().length() != 0) {
		query.append(" AND (NVL(A.E_YM, '999912') <= REPLACE('" + srchYmTo + "', '-', '') OR REPLACE('" + srchYmTo + "', '-', '') BETWEEN A.S_YM AND NVL(A.E_YM, '999912'))");
	}
	
	pm.put("query", query.toString());
	
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCalcExpressionMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//계산식관리 저장
public int saveCalcExpressionMgr(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(conn != null && list != null && list.size() > 0) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				
				if("I".equals(sStatus) || "U".equals(sStatus)) {
					
					String sElementCd 			= (String)mp.get("element_cd");
					String sSearchSeq 			= (String)mp.get("search_seq");
					String sSym 				= (String)mp.get("s_ym");
					String sElementLinkTypeNm 	= (String)mp.get("element_link_type_nm");
					String sNo 					= (String)mp.get("sNo");
					
					if("I".equals(sStatus) && sElementCd.trim().length() != 0 && sSearchSeq.trim().length() != 0 && sSym.trim().length() != 0 && "계산식".equals(sElementLinkTypeNm) ){
						
						List listData = null;
						
						listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectChkCalcExpressionMgr",mp);
						Map mapData = (Map)listData.get(0);
						 
 						if(mapData.get("cal_value_nm") == null ||mapData.get("cal_value_nm") == "" || listData.size() <= 0) {
							throw new Exception(sNo+"행의 수당/공제항목과 조건검색에 일치하는 계산식이 존재하지 않습니다.\n항목링크(계산식)메뉴에서 확인 후 진행하시기 바랍니다.");	
						}							
					}
					
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveCalcExpressionMgr", mp);
				}else if ("D".equals(sStatus)){
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteCalcExpressionMgr", mp);
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
			if(e != null && e.getMessage()!=null){
				throw new Exception(e.getMessage());	
			} else{
				throw new Exception("저장에 실패하였습니다.");	
			}
			
		} finally {
			DBConn.closeConnection(conn, null, null);
		}
	}
	
	return rstCnt;
}

//계산방법보기버튼 저장
public int updateCpnFormulaBtnYn(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(conn != null && list != null && list.size() > 0) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				rstCnt += DBConn.executeUpdate(conn, queryMap, "updateCpnFormulaBtnYn", mp);
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

//삭제후 재생성
public int batchCalcExpressionMgrByDel(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	
	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if (conn != null) {
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
			
		try{
			rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteCalcExpressionMgrByBatch", pm);
			rstCnt += DBConn.executeUpdate(conn, queryMap, "insertCalcExpressionMgrByBatch", pm);
			rstCnt += DBConn.executeUpdate(conn, queryMap, "insertCalcExpressionMgrByBatch2", pm);
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

//신규만 재생성
public int batchCalcExpressionMgrByNew(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	
	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if (conn != null) {
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
			
		try{
			rstCnt += DBConn.executeUpdate(conn, queryMap, "insertCalcExpressionMgrByBatch3", pm);
			rstCnt += DBConn.executeUpdate(conn, queryMap, "insertCalcExpressionMgrByBatch2", pm);
			
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

%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/calcExpressionMgr/calcExpressionMgr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	
	if("selectCalcExpressionMgrList".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectCalcExpressionMgrList(xmlPath+"/calcExpressionMgr/calcExpressionMgr.xml", mp);
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
		
	} else if("saveCalcExpressionMgr".equals(cmd)){
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);		
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveCalcExpressionMgr(xmlPath+"/calcExpressionMgr/calcExpressionMgr.xml", mp);
			
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
		
	} else if("updateCpnFormulaBtnYn".equals(cmd)){
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);		
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = updateCpnFormulaBtnYn(xmlPath+"/calcExpressionMgr/calcExpressionMgr.xml", mp);
			
			if(cnt > 0) {
				message = "저장되었습니다. 계산방법보기 버튼이 있는 화면(ex. 개인별급여내역)을 새로고침하면 반영됩니다.";
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
		
	} else if("batchCalcExpressionMgrByDel".equals(cmd)){
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);				
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = batchCalcExpressionMgrByDel(xmlPath+"/calcExpressionMgr/calcExpressionMgr.xml", mp);
			
			if(cnt > 0) {
				message = "재생성 되었습니다.";
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
		
	} else if("batchCalcExpressionMgrByNew".equals(cmd)){
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);				
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = batchCalcExpressionMgrByNew(xmlPath+"/calcExpressionMgr/calcExpressionMgr.xml", mp);
			
			if(cnt > 0) {
				message = "재생성 되었습니다.";
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