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

//담당자-임직원 FeedBack 검색
public List selectYeaFeedbackPopupList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaFeedbackPopupList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return list;
}

//담당자-임직원 FeedBack 담당자 저장.
public int saveYeaFeedbackPopup(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	String searchAuthPg = "";

	if(list != null && list.size() > 0 && conn != null) {

		conn.setAutoCommit(false);

		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				String replyYn = (String)mp.get("reply_yn");

				if(i == 0) {
					searchAuthPg = (String)mp.get("searchAuthPg");
				}

				if("U".equals(sStatus)) {
					//수정
					Map cntMap = DBConn.executeQueryMap(conn, queryMap,"selectYeaFeedbackPopupCnt",mp);
					//Log.Debug("cntMap >>>>>>>>>>>>>>>                  "+cntMap);
					if(cntMap != null && Integer.parseInt((String)cntMap.get("cnt")) > 0 ) {
						if("A".equals(searchAuthPg)) {
							rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaFeedbackPopupA", mp);
						} else {

							//피드백 이력 등록
							if("Y".equals(replyYn)) {
								DBConn.executeUpdate(conn, queryMap, "insertYeaFeedbackPopupHist", mp);
							}

							rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaFeedbackPopupR", mp);
						}
					} else {
						if("A".equals(searchAuthPg)) {
							rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYeaFeedbackPopupA", mp);
						} else {
							rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYeaFeedbackPopupR", mp);
						}
					}
				}
				saveLog(conn, mp, ssnYeaLogYn);
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


//FeedBack 이력 조회
public List selectYeaFeedbackPopupHisList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List list = null;

	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaFeedbackPopupHisList",pm);
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
	String locPath = xmlPath+"/yeaData/yeaFeedbackPopup.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaFeedbackPopupList".equals(cmd)) {
		//담당자-임직원 FeedBack 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaFeedbackPopupList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveYeaFeedbackPopup".equals(cmd)) {
		//담당자-임직원 FeedBack 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = saveYeaFeedbackPopup(mp, locPath, ssnYeaLogYn);

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

	} else if("selectYeaFeedbackPopupHisList".equals(cmd)) {
		//담당자-임직원 FeedBack 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaFeedbackPopupHisList(mp, locPath);
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

	}
%>