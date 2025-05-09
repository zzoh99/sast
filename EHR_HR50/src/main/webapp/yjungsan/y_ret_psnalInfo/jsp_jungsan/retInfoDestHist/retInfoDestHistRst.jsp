<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%!
//private Logger log = Logger.getLogger(this.getClass());

//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
    queryMap = XmlQueryParser.getQueryMap(path);
} */

//개인정보파기이력 조회
public List getRetInfoDestHistList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
    List list = null;
    
    try{
        //쿼리 실행및 결과 받기.
        list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getRetInfoDestHistList",pm);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    }
    
    return list;
}


//개인정보분리이력 상세
public List getRetInfoDestHistList2(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
  List list = null;
  
  try{
      //쿼리 실행및 결과 받기.
      list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getRetInfoDestHistList2",pm);
  } catch (Exception e) {
      Log.Error("[Exception] " + e);
      throw new Exception("조회에 실패하였습니다.");
  }
  
  return list;
}

//개인정보파기이력 상세
public List getRetInfoDestHistList3(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
//파라메터 복사.
Map pm =  StringUtil.getParamMapData(paramMap);
List list = null;

try{
    //쿼리 실행및 결과 받기.
    list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getRetInfoDestHistList3",pm);
} catch (Exception e) {
    Log.Error("[Exception] " + e);
    throw new Exception("조회에 실패하였습니다.");
}

return list;
}

%>

<%
    //쿼리 맵 셋팅
    //setQueryMap(xmlPath+"/retInfoDestHist/retInfoDestHist.xml");

    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");
    String cmd = (String)request.getParameter("cmd");

    if("getRetInfoDestHistList".equals(cmd)) {
        //인적사항관리 조회 
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = getRetInfoDestHistList(xmlPath+"/retInfoDestHist/retInfoDestHist.xml", mp);
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
        
    }else if("getRetInfoDestHistList2".equals(cmd)){
        //인적사항관리 조회 
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = getRetInfoDestHistList2(xmlPath+"/retInfoDestHist/retInfoDestHist.xml", mp);
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
        
    }else if("getRetInfoDestHistList3".equals(cmd)){
        //인적사항관리 조회 
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = getRetInfoDestHistList3(xmlPath+"/retInfoDestHist/retInfoDestHist.xml", mp);
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