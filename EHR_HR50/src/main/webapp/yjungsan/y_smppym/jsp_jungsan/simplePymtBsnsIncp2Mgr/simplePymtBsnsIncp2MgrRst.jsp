<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.io.Serializable"%>

<%@ include file="../common/include/session.jsp"%>

<%!
//private Logger log = Logger.getLogger(this.getClass());
//public Map queryMap = null;

//xml 파서를 이용한 방법;
/* public void setQueryMap(String path) {
	queryMap = XmlQueryParser.getQueryMap(path);
} */

//사업소득관리 다건 조회
public List getSimplePymtBsnsIncp2Mgr(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	//년도
	String searchYear	= String.valueOf(pm.get("searchYear"));
	//반기구분
	String searchHalfType	= String.valueOf(pm.get("searchHalfType"));
	//사업장
	String searchBusinessPlace	= String.valueOf(pm.get("searchBusinessPlace"));
	//사번/성명
	String searchSabunNameAlias	= String.valueOf(pm.get("searchSabunNameAlias"));

	StringBuffer query = new StringBuffer();

	query.setLength(0);

    //년도
	if(searchYear.trim().length() != 0 ){

		query.append(" AND WORK_YY = '"+searchYear+"'");
	}
    //반기구분
    if(searchHalfType.trim().length() != 0 ){

		query.append(" AND HALF_TYPE = '"+searchHalfType+"'");
	}
    //사업장
	if(searchBusinessPlace.trim().length() != 0 ){

		query.append(" AND BUSINESS_PLACE_CD = '"+searchBusinessPlace+"'");
	}
	//사번/성명
	if(searchSabunNameAlias.trim().length() != 0 ){

		query.append(" AND (A.SABUN || A.NAME) LIKE '%" +searchSabunNameAlias+"%'");
	}
	
	pm.put("query", query.toString());
	
	
	try{
		
		Map mapData = null;
		String hptbCnt = "0";

		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getSimplePymtBsnsIncp2Mgr",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}


//중복 사번 체크
public List getSabunChk(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	//사번
	String sabuns	= String.valueOf(pm.get("sabuns"));
	//대상년도
	String searchYear	= String.valueOf(pm.get("searchYear"));
	//반기구분
	String searchHalfType	= String.valueOf(pm.get("searchHalfType"));
	//사업장
	String searchBusinessPlace	= String.valueOf(pm.get("searchBusinessPlace"));
	

	StringBuffer query = new StringBuffer();

	query.setLength(0);

	//사번
	if(sabuns.trim().length() != 0 ){

		query.append(" AND SABUN IN(" +sabuns+ ")");
	}
	//대상년도
	if(searchYear.trim().length() != 0 ){

		query.append(" AND WORK_YY = '"+searchYear+"'");
	}
	//반기구분
	if(searchHalfType.trim().length() != 0 ){

		query.append(" AND HALF_TYPE = '"+searchHalfType+"'");
	}
	//사업장
	if(searchBusinessPlace.trim().length() != 0 ){

		query.append(" AND BUSINESS_PLACE_CD = '"+searchBusinessPlace+"'");
	}

	pm.put("query", query.toString());
	
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getSabunChk",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}


//사업소득관리 저장
public int saveSimplePymtBsnsIncp2Mgr(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
  //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
  List list = StringUtil.getParamListData(paramMap);
  //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
  Connection conn = DBConn.getConnection();
  int rstCnt = 0;
  
  if(conn != null && list != null && list.size() > 0) {
  
      //사용자가 직접 트랜젝션 관리
      conn.setAutoCommit(false);
      
      try{
    	  String searchYear = "";
    	  String searchHalfType = "";
    	  
          for(int i = 0; i < list.size(); i++ ) {
        	  
              Map mp = (Map)list.get(i);
              String sStatus = (String)mp.get("sStatus");
              
              if((String)mp.get("searchYear") != null){
            	  searchYear = (String)mp.get("searchYear"); 
              }
              
              if((String)mp.get("searchHalfType") != null){
            	  searchHalfType = (String)mp.get("searchHalfType"); 
              }
              
              
              
              if("0".equals((String)mp.get("final_close_yn"))){
            	  mp.put("final_close_yn", "N");
              }else{
            	  mp.put("final_close_yn", "Y");
              }
              
              mp.put("searchYear", searchYear);
              mp.put("searchHalfType", searchHalfType);
              
              if("D".equals(sStatus)) {
                  //삭제
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteSimplePymtBsnsIncp2Mgr", mp);
              } else if("I".equals(sStatus) || "U".equals(sStatus) ) {
                //수정
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveSimplePymtBsnsIncp2Mgr", mp);
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
	//setQueryMap(xmlPath+"/simplePymtBsnsIncp2Mgr/simplePymtBsnsIncp2Mgr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	//사업소득관리 다건 조회
	if("getSimplePymtBsnsIncp2Mgr".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = getSimplePymtBsnsIncp2Mgr(xmlPath+"/simplePymtBsnsIncp2Mgr/simplePymtBsnsIncp2Mgr.xml", mp);
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
	
	//중복 사번 체크
	else if("getSabunChk".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = getSabunChk(xmlPath+"/simplePymtBsnsIncp2Mgr/simplePymtBsnsIncp2Mgr.xml", mp);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData == null ? null : listData.get(0));
		out.print((new org.json.JSONObject(rstMap)).toString());
			
	}

	//사업소득관리 저장
	else if("saveSimplePymtBsnsIncp2Mgr".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        String message = "";
        String code = "1";
        
        try {
            int cnt = saveSimplePymtBsnsIncp2Mgr(xmlPath+"/simplePymtBsnsIncp2Mgr/simplePymtBsnsIncp2Mgr.xml", mp);
            
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
	//연말_사업소득관리 프로시저 호출
	else if("P_CPN_SMPPYM_EMP".equals(cmd)) {
		//연말정산 대상자 작업
		
		Map paramMap = StringUtil.getRequestMap(request);
		
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		
		Map mp =  StringUtil.getParamMapData(paramMap);

		String halfType = (String)mp.get("halfType");
		String incomeType = (String)mp.get("incomeType");
		String workYy = (String)mp.get("workYy");
		String creWorkYy = (String)mp.get("creWorkYy");
		String sabun = (String)mp.get("sabun");
		String delYn = (String)mp.get("delYn");
		String calcType = (String)mp.get("calcType");

		String[] type =  new String[]{"OUT","OUT","OUT"
				,"STR","STR","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",""
				,ssnEnterCd,halfType,incomeType,workYy,creWorkYy,sabun,delYn,calcType,ssnSabun};
		
		String message = "";
		String code = "1";
		int cnt = 0;
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_SMPPYM_EMP",type,param);
			
			if(rstStr[1] == null || rstStr[1].length() == 0) {
				message = "작업 완료되었습니다.";
			} else {
				code = "-1";
				message = "처리도중 문제발생 : "+rstStr[1];
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