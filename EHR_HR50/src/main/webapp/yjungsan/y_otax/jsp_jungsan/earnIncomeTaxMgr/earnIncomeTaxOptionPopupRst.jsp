<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
 
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//원천세 옵션 조회
public List selectEarnIncomeTaxOptionPopupList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEarnIncomeTaxOptionPopupList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//원천세 옵션 저장.
public int saveEarnIncomeTaxOptionPopup(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	List list = StringUtil.getParamListData(paramMap);

	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(conn != null && list != null && list.size() > 0) {
	
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				
				String workYy = (String)mp.get("work_yy");
				String nowWorkYy = DateUtil.getDateTime() ;
				nowWorkYy = nowWorkYy.substring(0, 4) ;
				
				if("U".equals(sStatus)||"I".equals(sStatus)) {
					//수정
					if(workYy.equals(nowWorkYy)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "saveEarnIncomeTaxOptionPopup", mp);
					}
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveEarnIncomeTaxOptionPopupYea", mp);
				}
			}
			
			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				if (conn != null) conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				if (conn != null) conn.rollback();
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

//원천세 옵션 저장 연도 목록 조회
public List selectEarnIncomeTaxOptionYeaList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEarnIncomeTaxOptionYeaList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//지정 연도의 원천세 옵션 조회
public List selectEarnIncomeTaxOptionPopupListByYea(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEarnIncomeTaxOptionPopupListByYea",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}
%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxOptionPopup.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectEarnIncomeTaxOptionPopupList".equals(cmd)) {
		//원천세 옵션 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectEarnIncomeTaxOptionPopupList(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxOptionPopup.xml", mp);
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
	} else if("saveEarnIncomeTaxOptionPopup".equals(cmd)) {
		//원천세 옵션 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveEarnIncomeTaxOptionPopup(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxOptionPopup.xml", mp);
			
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
	} else	if("selectEarnIncomeTaxOptionYeaList".equals(cmd)) {
		//원천세 옵션 저장 연도 목록 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectEarnIncomeTaxOptionYeaList(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxOptionPopup.xml", mp);
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
	} else	if("selectEarnIncomeTaxOptionPopupListByYea".equals(cmd)) {
		//지정 연도의 원천세 옵션 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map paramMap =  StringUtil.getParamMapData(mp);
		String sourceWorkYy = (String)paramMap.get("sourceWorkYy");
		String searchWorkYy = (String)paramMap.get("searchWorkYy");
		mp.put("sourceWorkYy", sourceWorkYy);
		mp.put("searchWorkYy", searchWorkYy);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectEarnIncomeTaxOptionPopupListByYea(xmlPath+"/earnIncomeTaxMgr/earnIncomeTaxOptionPopup.xml", mp);
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