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

<%!

//신용카드 내역 조회
public List selectCardHisMgrList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCardHisMgrList",pm);
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
	String locPath = xmlPath+"/cardHisMgr/cardHisMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectCardHisMgrList".equals(cmd)) {
		//신용카드 내역 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectCardHisMgrList(mp, locPath);
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
		
	} else if("saveCardHisMgr".equals(cmd)) {
		//신용카드 내역 저장
		
		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		
		List listMap = StringUtil.getParamListData(paramMap);
		
		String message = "";
		String code = "1";
		int cnt = 0;
		
		try {
			
			for(int i = 0; i < listMap.size(); i++) {
				Map data = (Map)listMap.get(i);
				
				String sStatus = (String)data.get("sStatus");

				String workYy = (String)data.get("work_yy");
				String adjustType = (String)data.get("adjust_type");
				String sabun = (String)data.get("sabun");
				String seq = (String)data.get("seq");
				String famres = (String)data.get("famres");
				String cardType = (String)data.get("card_type");
				String applMon = (String)data.get("appl_mon");
				String adjInputType = (String)data.get("adj_input_type");
				String ntsYn = (String)data.get("nts_yn");
				String feedbackType = (String)data.get("feedback_type");
				
				String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
						,"STR","STR","STR","STR","STR"
						,"STR","STR","STR","STR","STR"};
				String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
						,adjustType,sabun,seq,famres,cardType
						,applMon,adjInputType,ntsYn,feedbackType,ssnSabun};
				
				String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+workYy+"_SYNC.CARDS_INS",type,param);
				
				if(rstStr[1] != null && rstStr[1].length() > 0) {
					message = rstStr[1]+"\n";
				}
				cnt++;
			}
			
			if(cnt > 0) {
				if(message.length() == 0) {
					message = "저장되었습니다.";
				}
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