<%@page import="java.io.Console"%>
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

//파일목록 검색
public List getTextFileMgrListFirst(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List list = null;

	String searchFileNm	  = String.valueOf(pm.get("searchFileNm"));//
	String searchFileDesc = String.valueOf(pm.get("searchFileDesc"));//
	String searchWorkYy = String.valueOf(pm.get("searchWorkYy"));//
	
	StringBuffer query = new StringBuffer();
	query.setLength(0);
	
	if(searchFileNm.trim().length()   != 0){query.append(" AND A.FILE_NM LIKE ('%'||TRIM('"+searchFileNm+"')||'%')");}//
	if(searchFileDesc.trim().length() != 0){query.append(" AND A.FILE_DESC LIKE ('%'||TRIM('"+searchFileDesc+"')||'%')");}//
	if(searchWorkYy.trim().length() != 0){query.append(" AND A.WORK_YY = TRIM('"+searchWorkYy+"')");}//
	
	pm.put("query", query.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getTextFileMgrListFirst",pm);
		
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return list;
}

//세부항목 검색
public List getTextFileMgrListSecond(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List list = null;
	
	String searchFileSeq = String.valueOf(pm.get("searchFileSeq"));//
	String searchWorkYy2 = String.valueOf(pm.get("searchWorkYy2"));//
	
	StringBuffer query2 = new StringBuffer();
	query2.setLength(0);
	
	if(searchFileSeq.trim().length()   != 0) {
		query2.append("  AND FILE_SEQ = TRIM('"+searchFileSeq+"')  AND WORK_YY = TRIM('"+searchWorkYy2+"')");
	} else {
		query2.append("  AND FILE_SEQ IS NULL AND WORK_YY IS NULL ");
	}
	
	pm.put("query2", query2.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getTextFileMgrListSecond",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return list;
}

//파일목록 저장.
public int saveTextFileMgrFirst(Map paramMap, Map queryMap) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	
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
				String fileSeq = (String)mp.get("file_seq");
				String workYy = (String)mp.get("work_yy");
				String ssnEnterCd = (String)mp.get("ssnEnterCd");
				
				
				StringBuffer query3 = new StringBuffer();
				query3.setLength(0);
				
				if (!fileSeq.equals("")) {
					query3.append("TRIM('"+fileSeq+"')	AS FILE_SEQ, TRIM('"+workYy+"')	AS WORK_YY");
				} else if (fileSeq.equals("")) {
					query3.append("TO_CHAR( (SELECT (NVL(MAX(TO_NUMBER(FILE_SEQ)),0) + 1) FROM TYEA965 WHERE ENTER_CD = '"+ssnEnterCd+"' AND WORK_YY = TRIM('"+workYy+"')) )	AS FILE_SEQ , TRIM('"+workYy+"')	AS WORK_YY");
				}
				
				mp.put("query3", query3.toString());
				
				
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteTextFileMgrFirst", mp);
					DBConn.executeUpdate(conn, queryMap, "deleteTextFileMgrSecondAll", mp);
				} else if("U".equals(sStatus)) {
					
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveTextFileMgrFirst", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveTextFileMgrFirst", mp);
				}
				//saveLog(conn, mp);
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

//세부항목 저장.
public int saveTextFileMgrSecond(Map paramMap, Map queryMap) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	
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
				String fileElementSeq = (String)mp.get("file_element_seq");
				String fileSeq = (String)mp.get("file_seq");
				String workYy = (String)mp.get("work_yy");
				String ssnEnterCd = (String)mp.get("ssnEnterCd");
				
				
				StringBuffer query4 = new StringBuffer();
				query4.setLength(0);
				
				if (!fileElementSeq.equals("")) {
					query4.append("TRIM('"+fileElementSeq+"')	AS FILE_ELEMENT_SEQ");
				} else if (fileElementSeq.equals("")) {
					query4.append("TO_CHAR( (SELECT (NVL(MAX(TO_NUMBER(FILE_ELEMENT_SEQ)),0) + 1) FROM TYEA966 WHERE ENTER_CD = '"+ssnEnterCd+"' AND FILE_SEQ = '"+fileSeq+"' AND WORK_YY = '"+workYy+"') )	AS FILE_SEQ");
				}
				
				mp.put("query4", query4.toString());
				
				
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteTextFileMgrSecond", mp);
				} else if("U".equals(sStatus)) {
					
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveTextFileMgrSecond", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveTextFileMgrSecond", mp);
				}
				//saveLog(conn, mp);
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


%>

<%
	Map queryMap = XmlQueryParser.getQueryMap(xmlPath+"/textFileMgr/textFileMgrMonth.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	

	if("getTextFileMgrListFirst".equals(cmd)) {
		//파일목록조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getTextFileMgrListFirst(mp, queryMap);
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

	} else if("getTextFileMgrListSecond".equals(cmd)) {
		//세부항목조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getTextFileMgrListSecond(mp, queryMap);
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

	}  else if("saveTextFileMgrFirst".equals(cmd)) {
		//연말정산 항목 프로세스 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		
		String message = "";
		String code = "1";

		try {
			int cnt = saveTextFileMgrFirst(mp, queryMap);

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

	} else if("saveTextFileMgrSecond".equals(cmd)) {
		//연말정산 항목 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {

			int cnt = saveTextFileMgrSecond(mp, queryMap);

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

	} else if("copyTextFileMgr".equals(cmd)) {
		//오류검증

		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);

		Map mp = StringUtil.getParamMapData(paramMap);

		String message = "";
		String code = "1";
		int cnt = 0;

		try {
			String sStatus = (String)mp.get("sStatus");
			String workYy = (String)mp.get("searchWorkYy");

			String[] type =  new String[]{"OUT","OUT","STR","STR","STR"};
			String[] param = new String[]{"","",ssnEnterCd,workYy,ssnSabun};

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_ELE_CRE",type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "전년도복사 작업이 완료되었습니다.";
			} else {
				code = "-1";
				message = rstStr[1];
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