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

//개인정보파기기준설정 조회
public List getRetInfoDestStdList1(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
    List list = null;
    
    try{
        //쿼리 실행및 결과 받기.
        list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getRetInfoDestStdList1",pm);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    }
    
    return list;
}

//개인정보파기기준설정 조회
public List getRetInfoDestStdList2(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
  List list = null;
  
  try{
      //쿼리 실행및 결과 받기.
      list  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getRetInfoDestStdList2",pm);
  } catch (Exception e) {
      Log.Error("[Exception] " + e);
      throw new Exception("조회에 실패하였습니다.");
  }
  
  return list;
}


//개인정보파기기준설정 저장.
public int saveRetInfoDestStd1(String path, Map paramMap) throws Exception {
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
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveRetInfoDestStd1", mp);
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

//개인정보파기기준설정 저장.
public int saveRetInfoDestStd2(String path, Map paramMap) throws Exception {
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
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveRetInfoDestStd2", mp);
				}else if ("D".equals(sStatus)){
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteRetInfoDestStd2", mp);
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

%>

<%
    //쿼리 맵 셋팅
    //setQueryMap(xmlPath+"/retInfoDestStd/retInfoDestStd.xml");

    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");
    String cmd = (String)request.getParameter("cmd");

    if("getRetInfoDestStdList1".equals(cmd)) {
        //인적사항관리 조회 
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = getRetInfoDestStdList1(xmlPath+"/retInfoDestStd/retInfoDestStd.xml", mp);
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
        
    }  else if("getRetInfoDestStdList2".equals(cmd)) {
        //인적사항관리 저장
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listData  = new ArrayList();
        String message = "";
        String code = "1";
        
        try {
            listData = getRetInfoDestStdList2(xmlPath+"/retInfoDestStd/retInfoDestStd.xml", mp);
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
        
    } else if("saveRetInfoDestStd1".equals(cmd)){
    	Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveRetInfoDestStd1(xmlPath+"/retInfoDestStd/retInfoDestStd.xml", mp);
			
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
		
    } else if("saveRetInfoDestStd2".equals(cmd)){
    	Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveRetInfoDestStd2(xmlPath+"/retInfoDestStd/retInfoDestStd.xml", mp);
			
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