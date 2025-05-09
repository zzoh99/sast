<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="org.json.JSONObject"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%!

public List selectSavLogList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	int cnt = 0;
	String searchMenuNm        = String.valueOf(pm.get("searchMenuNm")     );
	String searchServiceNm     = String.valueOf(pm.get("searchServiceNm")  );
	String searchLogTypeCd     = String.valueOf(pm.get("searchLogTypeCd")  );
    String searchFromYmd       = String.valueOf(pm.get("searchFromYmd")    );
    String searchToYmd         = String.valueOf(pm.get("searchToYmd")      );
    String searchAdjustType    = String.valueOf(pm.get("searchAdjustType") );
    String searchYear          = String.valueOf(pm.get("searchYear")       );
    String searchLogMemo       = String.valueOf(pm.get("searchLogMemo")    );
    String searchSbNm          = String.valueOf(pm.get("searchSbNm")       );
    String searchChkNm          = String.valueOf(pm.get("searchChkNm")       );

    if(searchFromYmd.trim().length() > 0 || searchToYmd.trim().length() > 0){
        cnt++;
    }

	StringBuffer query   = new StringBuffer();
    query.setLength(0);

    if(searchYear.trim().length() != 0){
        //년도
        query.append("AND A.WORK_YY = #searchYear#");
    }
    if(cnt != 0){
        //작업일자
        query.append(" AND TO_CHAR(A.CHKDATE,'YYYYMMDD') BETWEEN NVL(REPLACE(#searchFromYmd#, '-', ''), '11110101') AND NVL(REPLACE(#searchToYmd#, '-', ''), '99991231')");
    }
    if(searchLogTypeCd.trim().length() != 0){
    	//로그타입
        query.append("AND A.LOG_TYPE = #searchLogTypeCd#");
    }
    if(searchMenuNm.trim().length() != 0){
    	//메뉴명
        query.append("AND LOWER(A.MENU_NM) LIKE LOWER('%" +searchMenuNm+"%') ");
    }
    if(searchServiceNm.trim().length() != 0){
    	//서비스명
        query.append("AND LOWER(A.CMD) LIKE LOWER('%" +searchServiceNm+"%') ");
    }
    if(searchLogMemo.trim().length() != 0){
        //로그내용
        query.append("AND LOWER(A.LOG_MEMO) LIKE LOWER('%" +searchLogMemo+"%') ");
    }
    if(searchSbNm.trim().length() != 0){
        //성명사번
        query.append("AND ( LOWER(A.SABUN) LIKE LOWER('%" +searchSbNm+"%') OR LOWER(F_COM_GET_NAMES(A.ENTER_CD,A.SABUN)) LIKE LOWER('%" +searchSbNm+"%') )");
    }
    if(searchChkNm.trim().length() != 0){
        //작업자성명사번
        query.append("AND ( LOWER(A.CHKID) LIKE LOWER('%" +searchChkNm+"%') OR LOWER(F_COM_GET_NAMES(A.ENTER_CD,A.CHKID)) LIKE LOWER('%" +searchChkNm+"%') )");
    }

    pm.put("query", query.toString());
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectSavLogList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

%>

<%
	String locPath = xmlPath+"/logHisMgr/logHisMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectSavLogList".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectSavLogList(mp, locPath);
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