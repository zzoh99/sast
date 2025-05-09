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

//원천징수세액조회 조회
public List selectTaxHisMgrList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectTaxHisMgrList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return listData;
}

//원천 징수 세액 조회 저장.
public int saveTaxHisMgrList(Map paramMap, String locPath) throws Exception {
    //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
    List list = StringUtil.getParamListData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    //System.out.println(paramMap);

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
                
                //System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());System.out.println(mp.toString());
                
                mp.put("searchYear",       mp.get("work_yy"));
                mp.put("searchAdjustType", mp.get("adjust_type"));
                
                String sStatus = (String)mp.get("sStatus");
                
                if("U".equals(sStatus)) {
                    //수정
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "updateTaxHisMgrList", mp);
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
		    queryMap = null;
        }
    }
    
    return rstCnt;
}
%>

<%
	String locPath = xmlPath+"/taxHisMgr/taxHisMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectTaxHisMgrList".equals(cmd)) {
		//원천징수세액조회 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectTaxHisMgrList(mp, locPath);
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
	}else if("saveTaxHisMgrList".equals(cmd)) {
      //원천징수세액조회 조회
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listData  = new ArrayList();
        String message = "";
        String code = "1";
    
        try {
            int cnt = saveTaxHisMgrList(mp, locPath);
            
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
        rstMap.put("Data", listData == null ? null : (List)listData);
        out.print((new org.json.JSONObject(rstMap)).toString());
	}
%>