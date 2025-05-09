<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%!
//프로그램관리 검색
public List selectPrgMgr(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	try{
		//쿼리 실행및 결과 받기.
		list = DBConn.executeQueryList(queryMap,"selectPrgMgr",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return list;
}

//프로그램관리 저장.
public int savePrgMgr(Map paramMap, String locPath) throws Exception {

	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
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

				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deletePrgMgr", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updatePrgMgr", mp);
				} else if("I".equals(sStatus)) {
					//입력 중복체크
					Map dupMap = DBConn.executeQueryMap(conn, queryMap,"selectPrgMgrCnt",mp);

					if(dupMap != null && Integer.parseInt((String)dupMap.get("cnt")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다.");
					}
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertPrgMgr", mp);
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

%>

<%
	String locPath = xmlPath+"/auth/prgMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectPrgMgr".equals(cmd)) {
		//프로그램관리 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectPrgMgr(mp, locPath);
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

	} else if("savePrgMgr".equals(cmd)) {
		//프로그램관리 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = savePrgMgr(mp, locPath);

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