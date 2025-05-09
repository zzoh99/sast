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

//xml 파서를 이용한 방법;
public Map setQueryMap(String path) {
	return XmlQueryParser.getQueryMap(path);
}

//정산계산내역조회 검색
public List selectYeaCalcSearch(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List list = null;
	
	String searchDeductYn	= pm.get("searchDeductYn") == null ? "" : String.valueOf(pm.get("searchDeductYn"));
	
	StringBuffer query = new StringBuffer();
	query.setLength(0);
	
	if("Y".equals(searchDeductYn)){
		query.append(" AND NVL(Y.A050_01, 0) > 0");
	}
	
	if("N".equals(searchDeductYn)){
		query.append(" AND NVL(Y.A050_01, 0) = 0");
	}
	
	pm.put("query", query.toString());
	
	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCalcMedical",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return list;
}

public List selectYeaCalcRetSearch(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List list = null;

    String searchPenAcctYn  = String.valueOf(pm.get("searchPenAcctYn"));
    String searchPenAcctChk = String.valueOf(pm.get("searchPenAcctChk"));
    String searchBizPlaceCd = String.valueOf(pm.get("searchBizPlaceCd"));

    StringBuffer query = new StringBuffer();
    query.setLength(0);

    StringBuffer query2 = new StringBuffer();
    query2.setLength(0);

    if(searchPenAcctYn.trim().length() != 0){
        if(searchPenAcctYn.equals("Y")){
            query.append(" AND ACCOUNT_CNT > 0");
        }else if(searchPenAcctYn.equals("N")){
            query.append(" AND ACCOUNT_CNT = 0");
        }
    }

    if(searchPenAcctChk.trim().length() != 0){
        if(searchPenAcctChk.equals("1")){
            query.append(" AND CONFIRM_TEXT = '정상' ");
        }else if(searchPenAcctChk.equals("2")){
            query.append(" AND CONFIRM_TEXT = '사업자명누락' ");
        }else if(searchPenAcctChk.equals("3")){
            query.append(" AND CONFIRM_TEXT = '계좌번호누락' ");
        }
    }
    if(searchBizPlaceCd.trim().length() != 0 && searchBizPlaceCd != "null"){
    	query2.append(" AND A.BUSINESS_PLACE_CD = " +searchBizPlaceCd);
    } 

    pm.put("query", query.toString());
    pm.put("query2", query2.toString());

	try{
		//쿼리 실행및 결과 받기.
		list = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCalcRetiree",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return list;
}

%>

<%
	//쿼리 맵 셋팅
	Map queryMap = setQueryMap(xmlPath+"/yeaNtsTax/yeaCalc.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectCalcMedical".equals(cmd)) {
		//의료비정산계산내역조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcSearch(mp, queryMap);
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
		
	} else if("selectCalcRetiree".equals(cmd)) {
		//퇴직소득 대상자 현황
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcRetSearch(mp, queryMap);
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