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
<%@ include file="../auth/saveLog.jsp"%>
<%!

//이관내역 조회
public List selectMigMgrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectMigMgrList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
        Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//감면기간 저장
public int saveMigMgr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

  List list = StringUtil.getParamListData(paramMap);
  //xml 파서를 이용한 방법;
  Map queryMap = XmlQueryParser.getQueryMap(locPath);

  Connection conn = DBConn.getConnection();
  int rstCnt = 0;

  if(list != null && list.size() > 0 && conn != null) {

      conn.setAutoCommit(false);

      try{
          for(int i = 0; i < list.size(); i++ ) {
              String query = "";
              Map mp = (Map)list.get(i);
              String sStatus = (String)mp.get("sStatus");

              if("I".equals(sStatus) || "U".equals(sStatus)) {
                  //수정
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveMigMgr", mp);
              }
              if("D".equals(sStatus)) {
                  //삭제
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteMigMgr", mp);
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
%>
<%
	String locPath = xmlPath+"/yeaMig/yeaMigStdMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectMigMgrList".equals(cmd)){
		//이관내역 조회
		Map mp = StringUtil.getRequestMap(request);

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectMigMgrList(mp, locPath, ssnYeaLogYn);
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
	} else if("saveMigMgr".equals(cmd)) {
        //이관내역 저장
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = saveMigMgr(mp, locPath, ssnYeaLogYn);

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