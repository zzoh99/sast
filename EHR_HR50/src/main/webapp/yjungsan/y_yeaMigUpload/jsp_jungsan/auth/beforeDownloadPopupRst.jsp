<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//다운로드 사유 여부 조회
public List getDownReasonYn(String queryId,Map paramMap, String locPath) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    List list = null;

    try{
        //쿼리 실행및 결과 받기.
        list  = DBConn.executeQueryList(queryMap,queryId, pm);
    } catch (Exception e) {
        Log.Error("[Exception] \n" + e);
        throw new Exception();
    } finally {
		queryMap = null;
	}

    return list;
}

//다운로드 사유 저장
public int saveDownReasonCont(Map paramMap, String locPath) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map mp = null;

    int rstCnt = 0;

    try{
        //쿼리 실행및 결과 받기.
        rstCnt  = DBConn.executeUpdate(queryMap, "saveDownReasonCont", pm);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("저장에 실패하였습니다.");
    } finally {
		queryMap = null;
	}

    return rstCnt;
}
%>

<%
    String locPath = xmlPath+"/auth/beforeDownloadPopup.xml";

    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");
    String cmd = (String)request.getParameter("cmd");
    String queryId = (String)request.getParameter("queryId");

    if("getDownReasonYn".equals(cmd)) {
    	//다운로드 사유 여부 조회
         Map mp = StringUtil.getRequestMap(request);
         mp.put("ssnEnterCd", ssnEnterCd);
         mp.put("ssnSabun", ssnSabun);

         List listData  = new ArrayList();
         String message = "";
         String code = "1";
	     try {

	         listData = getDownReasonYn(queryId,mp, locPath);
	     } catch(Exception e) {
	         code = "-1";
	         message = "조회중 오류가 발생하였습니다.";
	     }
	     Map mapCode = new HashMap();
	     mapCode.put("Code", code);
	     mapCode.put("Message", message);

	     Map rstMap = new HashMap();
	     rstMap.put("Result", mapCode);
	     rstMap.put("codeList", listData == null ? null : (List)listData);

	     out.print((new org.json.JSONObject(rstMap)).toString());

     } else if("saveDownReasonCont".equals(cmd)) {
    	//다운로드 사유 저장
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        String message = "";
        String code = "1";

        try {
            int cnt = saveDownReasonCont(mp, locPath);

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