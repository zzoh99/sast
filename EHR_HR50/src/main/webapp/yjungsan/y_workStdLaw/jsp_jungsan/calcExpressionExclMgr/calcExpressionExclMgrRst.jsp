<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
 
<%@ page import="org.json.*" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//private Logger log = Logger.getLogger(this.getClass());

//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//계산식예외관리 조회
public List selectCalcExpressionExclMgrList(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	Map pm =  StringUtil.getParamMapData(paramMap);
	String srchYmFrom	= String.valueOf(pm.get("srchYmFrom"));
	String srchYmTo		= String.valueOf(pm.get("srchYmTo"));
	StringBuffer query  = new StringBuffer();
	query.setLength(0);
	
// 	if(srchYmFrom.trim().length() != 0 || srchYmTo.trim().length() != 0){
// 		query.append(" AND (A.S_YM BETWEEN REPLACE('"+srchYmFrom+"', '-', '') AND REPLACE('"+srchYmFrom+"', '-', '') OR  A.E_YM BETWEEN REPLACE('"+srchYmTo+"', '-', '') AND REPLACE('"+srchYmTo+"', '-', ''))");
// 	}
	if (srchYmFrom.trim().length() != 0) {
		query.append(" AND (A.S_YM >= REPLACE('" + srchYmFrom + "', '-', '') OR REPLACE('" + srchYmFrom + "', '-', '') BETWEEN A.S_YM AND NVL(A.E_YM, '999912'))");
	}
	if (srchYmTo.trim().length() != 0) {
		query.append(" AND (NVL(A.E_YM, '999912') <= REPLACE('" + srchYmTo + "', '-', '') OR REPLACE('" + srchYmTo + "', '-', '') BETWEEN A.S_YM AND NVL(A.E_YM, '999912'))");
	}
		
	pm.put("query", query.toString());	
	
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCalcExpressionExclMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//계산식예외관리 저장
public int saveCalcExpressionExclMgr(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	
	if(conn != null && list != null && list.size() > 0) {
	
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				
				if("I".equals(sStatus) || "U".equals(sStatus)) {
					
					String sNo 	 = (String)mp.get("sNo");
					
					// 항목코드 유효성체크
					List listData1 = null;
					listData1  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCalcExpressionExclMgrByElementCdCheck",mp);
					Map mapData1 = (Map)listData1.get(0);
					
					if("0".equals(mapData1.get("cnt"))) {
						throw new UserException(sNo+"행의 항목코드가 유효하지 않습니다.");	
					}		
					
					// 사번 유효성체크
					List listData2 = null;
					listData2  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCalcExpressionExclMgrBySabunCheck",mp);
					Map mapData2 = (Map)listData2.get(0);
					
					if("0".equals(mapData2.get("cnt"))) {
						throw new UserException(sNo+"행의 사원번호가 유효하지 않습니다.");	
					}		
					
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveCalcExpressionExclMgr", mp);
				}else if ("D".equals(sStatus)){
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteCalcExpressionExclMgr", mp);
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
			
			if(e.getMessage()!=null){
				throw new Exception(e.getMessage());	
			}
			
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

%>

<%
	//쿼리 맵 셋팅
	//setQueryMap(xmlPath+"/calcExpressionExclMgr/calcExpressionExclMgr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectCalcExpressionExclMgrList".equals(cmd)) {
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
				
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectCalcExpressionExclMgrList(xmlPath+"/calcExpressionExclMgr/calcExpressionExclMgr.xml", mp);
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
		
	} else if("saveCalcExpressionExclMgr".equals(cmd)){
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveCalcExpressionExclMgr(xmlPath+"/calcExpressionExclMgr/calcExpressionExclMgr.xml", mp);
			
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