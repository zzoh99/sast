<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%!
//private Logger log = Logger.getLogger(this.getClass());

//public Map queryMap = null;

//xml 파서를 이용한 방법;
public Map setQueryMap(String path) {
	return XmlQueryParser.getQueryMap(path);
}

//퇴직세액 재계산 퇴직일자 코드 조회
public List selectRetTaxReCreCodeList(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRetTaxReCreCodeList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return list;
}

//퇴직세액 재계산 검색
public List selectRetTaxReCreList(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List list = null;
	
	try{
		//쿼리 실행및 결과 받기.
		list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRetTaxReCreList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return list;
}

//퇴직세액 재계산 저장.
public int saveRetTaxReCre(Map paramMap, Map queryMap) throws Exception {

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
				Map rstMap1 = null;
				Map rstMap2 = null;
				Map rstMap3 = null;
				
				if("U".equals(sStatus)) {
					rstMap1 = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectRetTaxReCreCnt768",mp);
					rstMap2 = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectRetTaxReCreCnt771",mp);
					rstMap3 = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectRetTaxReCreCnt777",mp);
					
					if(rstMap1 == null || rstMap1.get("cnt") == null || "0".equals(rstMap1.get("cnt"))) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "insertRetTaxReCre768", mp);
					} else {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateRetTaxReCre768", mp);
					}
					
					if(rstMap2 == null || rstMap2.get("cnt") == null || "0".equals(rstMap2.get("cnt"))) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "insertRetTaxReCre771", mp);
						rstCnt += DBConn.executeUpdate(conn, queryMap, "insertRetTaxReCre771_re", mp);
					} else {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateRetTaxReCre771", mp);
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateRetTaxReCre771_re", mp);
					}

					/* 2017-04-05 YHCHOI COMMENT OUT START */
					/*
					if("Y".equals((String)mp.get("save777"))) {
						if(rstMap3 == null || rstMap3.get("cnt") == null || "0".equals(rstMap3.get("cnt"))) {
							rstCnt += DBConn.executeUpdate(conn, queryMap, "insertRetTaxReCre777", mp);
						} else {
							rstCnt += DBConn.executeUpdate(conn, queryMap, "updateRetTaxReCre777", mp);
						}
					}
					*/
					/* 2017-04-05 YHCHOI COMMENT OUT END */
					
					/* 2017-04-05 YHCHOI ADD START */
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteRetTaxReCre777", mp);
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertRetTaxReCre777", mp);
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteRetTaxReCre777c", mp);
					/* 2017-04-05 YHCHOI ADD END */
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
		}
	}
	
	return rstCnt;
}

//퇴직자정산 급여코드 조회
public Map selectRetTaxReCreCntS2(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;
	
	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectRetTaxReCreCntS2",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return mp;
}

%>

<%
	//쿼리 맵 셋팅
	Map queryMap = setQueryMap(xmlPath+"/retTaxReCre/retTaxReCre.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectRetTaxReCreCodeList".equals(cmd)) {
		//퇴직세액 재계산 퇴직일자 코드 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRetTaxReCreCodeList(mp, queryMap);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("codeList", (List)listData);
		
		out.print(JSONObject.fromObject(rstMap).toString());
		
	} else if("selectRetTaxReCreList".equals(cmd)) {
		//퇴직세액 재계산 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRetTaxReCreList(mp, queryMap);
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
		
		out.print(JSONObject.fromObject(rstMap).toString());
		
	} else if("saveRetTaxReCre".equals(cmd)) {
		//퇴직세액 재계산 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveRetTaxReCre(mp, queryMap);
			
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
		
		out.print(JSONObject.fromObject(rstMap).toString());
		
	} else if("prcRetTaxReCre".equals(cmd)) {
		//퇴직세액 재계산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String sabun = (String)mp.get("searchSabun");
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,null,sabun,"5",ssnSabun};
		
		String message = "";
		String code = "1";
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_SEP_PAY_MAIN",type,param);
			
			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n" + rstStr[1];
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
		
		out.print(JSONObject.fromObject(rstMap).toString());
	}
	else if("selectRetTaxReCreCntS2".equals(cmd)) {
		//중간정산 불러오기
		//퇴직자정산 급여코드 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
	
		try {
			mapData = selectRetTaxReCreCntS2(mp, queryMap);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", (Map)mapData);
		out.print(JSONObject.fromObject(rstMap).toString());
	}
	else if("getMiJungsan".equals(cmd)) {
		//퇴직세액 재계산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String sabun = (String)mp.get("searchSabun");
		
		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,sabun,ssnSabun};
		                
		String message = "";
		String code = "1";
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_SEP_RMID_LOAD",type,param);
			
			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n" + rstStr[1];
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
		
		out.print(JSONObject.fromObject(rstMap).toString());
	}	
%>