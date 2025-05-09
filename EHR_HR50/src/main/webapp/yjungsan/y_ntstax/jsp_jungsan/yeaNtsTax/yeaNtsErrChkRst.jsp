<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!

//공제자료오류검증 조회
public List selectInputErrChkMgrList(Map paramMap, String locPath) throws Exception {
	
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectInputErrChkMgrList",pm);
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
	String locPath = xmlPath+"/yeaNtsTax/yeaNtsErrChk.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	
	String searchYear = (String)request.getParameter("tgtYear");
	String searchAdjustType = (String)request.getParameter("includeYn");
	String searchBizPlaceCd = (String)request.getParameter("bizLoc");
	
	String cmd = (String)request.getParameter("cmd");

	if("selectInputErrChkMgrList".equals(cmd)) {
		//공제자료오류검증 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("searchYear", searchYear);
		mp.put("searchAdjustType", searchAdjustType);
		mp.put("searchBizPlaceCd", searchBizPlaceCd);
		
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectInputErrChkMgrList(mp, locPath);
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
		
	}  else if("prcInputErrChkMgr".equals(cmd)) {
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
			String workYy = searchYear;
			String adjustType = searchAdjustType;
			String sabun = (String)mp.get("searchSabun");

			String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR"};
			String[] param = new String[]{"","",ssnEnterCd,workYy,adjustType,sabun,ssnSabun};

			String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+workYy+"_ERRCHK.ERROR_CHK",type,param);

			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "공제자료 오류검증 작업이 완료되었습니다.";
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