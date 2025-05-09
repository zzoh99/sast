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
<%@ include file="../auth/saveLog.jsp"%>
<%!

//외납세대상자 조회
public List selectAbroadTaxPeopleList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);	
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectAbroadTaxPeopleList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//외납세 대상자 저장.
public int saveAbroadTaxPeople(List paramList, String locPath, String ssnYeaLogYn) throws Exception {

	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	
	String menuNm  = "";
	String errMsg  = "";
	String sStatus = "";
	Map mp, mp2, chkMap ;

	if(paramList != null && paramList.size() > 0 && conn != null) {

		conn.setAutoCommit(false);

		try{
			for(int i = 0; i < paramList.size(); i++ ) {
				errMsg = "";
				mp     = (Map)paramList.get(i);
                mp2    = (Map)paramList.get(0);
                mp.put("menuNm",  String.valueOf(mp2.get("menuNm")));

				chkMap = DBConn.executeQueryMap(conn, queryMap, "chkValid", mp);
				
				if(chkMap != null) {
					errMsg = "\n - 성명(사번) : " + String.valueOf(mp.get("name")) + " (" + String.valueOf(mp.get("sabun")) + ") " 
				           + "\n - 납부년도 : " + String.valueOf(mp.get("pay_yy"))
					       + "\n - 국가코드 : " + String.valueOf(mp.get("national_cd"))
					       + "\n - 외납금액 : " + StringUtil.formatMoney(String.valueOf(mp.get("pay_tax_mon"))) + "원"
					       ;
					
					if (Integer.parseInt((String)chkMap.get("is_dup")) > 0 ) {
						throw new UserException("중복되어 저장할 수 없습니다." + errMsg);
					} else if (Integer.parseInt((String)chkMap.get("is_exist_child")) > 0 ) {
						throw new UserException("관련 자료가 존재합니다. 삭제할 수 없습니다." + errMsg);
					} else if (Integer.parseInt((String)chkMap.get("is_exist_rel")) > 0 ) {
						throw new UserException("관련 자료가 존재합니다.\n수정할 수 없습니다. ( 국외원천소득, 감면액, 외납세액, 이월배제액 )" + errMsg);
					}
				}

				sStatus = String.valueOf(mp.get("sStatus"));                
                if("I".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertAbroadTaxPeople", mp);
				}else if("U".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateAbroadTaxPeople", mp);
				}else if("D".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteAbroadTaxPeople", mp);
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
	String locPath = xmlPath+"/abroadTax/abroadTaxPeople.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectAbroadTaxPeopleList".equals(cmd)) {
		//외납세대상자조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectAbroadTaxPeopleList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveAbroadTaxPeople".equals(cmd)) {
		//저장

		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		paramMap.put("srchYear", String.valueOf(request.getParameter("srchYear")));

		List listMap = StringUtil.getParamListData(paramMap);

		String message = "";
		String code = "1";

		try {

			int cnt = 0;

			cnt += saveAbroadTaxPeople(listMap, locPath, ssnYeaLogYn);

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