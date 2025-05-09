<%@page import="aab.fo"%>
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
	//기타소득관리 다건 조회
	public List getsimplePymtEtcIncpMgr(Map paramMap, Map queryMap) throws Exception {

		//파라메터 복사.
		Map pm =  StringUtil.getParamMapData(paramMap);
		List listData = null;

		String searchBusinessPlace  = String.valueOf(pm.get("searchBusinessPlace") );//사업장
	    String searchSabunNameAlias = String.valueOf(pm.get("searchSabunNameAlias"));//사번/성명

	    StringBuffer query = new StringBuffer();
	    query.setLength(0);
	    if(searchSabunNameAlias.trim().length() != 0){query.append(" AND (A.SABUN || B.NAME) LIKE '%" +searchSabunNameAlias+"%'"); }//사번/성명

	    pm.put("query", query.toString());
		try{
			//쿼리 실행및 결과 받기.
			listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getsimplePymtEtcIncpMgr",pm);
	        //saveLog(null, pm);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		}

		return listData;
	}

	//근로소득관리 저장
	public int saveSimplePymtEtcIncpMgr(Map paramMap, Map queryMap) throws Exception {

	  //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	  List list = StringUtil.getParamListData(paramMap);

	  //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	  Connection conn = DBConn.getConnection();
	  int rstCnt = 0;

	  if(list != null && list.size() > 0 && conn != null) {

	      //사용자가 직접 트랜젝션 관리
	      conn.setAutoCommit(false);

	      try{
	    	  String searchYear = "";
	    	  String searchWorkMm = "";
	    	  String searchHalfType = "";
	    	  String halfDivFlag = "";
	
	          for(int i = 0; i < list.size(); i++ ) {
	
	              Map mp = (Map)list.get(i);
	              String sStatus     = (String)mp.get("sStatus");
	
	              if((String)mp.get("searchYear") != null){
	            	  searchYear = (String)mp.get("searchYear");
	              }
	              if((String)mp.get("searchWorkMm") != null){
	            	  searchWorkMm = (String)mp.get("searchWorkMm");
	              }
	              if((String)mp.get("searchHalfType") != null){
	            	  searchHalfType = (String)mp.get("searchHalfType");
	              }
	              if((String)mp.get("halfDivFlag") != null){
	            	  halfDivFlag = (String)mp.get("halfDivFlag");
	              }
	              if(!halfDivFlag.equals("true")){
	            	  mp.put("month_seq", "0");  
	              }
	              mp.put("searchYear", searchYear);
	              mp.put("searchWorkMm", searchWorkMm);
	              mp.put("searchHalfType", searchHalfType);
	
	              if("D".equals(sStatus)) {
	                  //삭제
	                  rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteSimplePymtEtcIncpMgr", mp);
	              } else if("I".equals(sStatus) || "U".equals(sStatus) ) {
	                  //수정
	                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveSimplePymtEtcIncpMgr", mp);
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
	//쿼리 맵 셋팅 (xml 파서를 이용한 방법)
	Map queryMap = XmlQueryParser.getQueryMap(xmlPath+"/simplePymtEtcIncpMgr/simplePymtEtcIncpMgrMonth.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	//근로소득관리 다건 조회
	if("getsimplePymtEtcIncpMgr".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getsimplePymtEtcIncpMgr(mp, queryMap);
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
	} else if("saveSimplePymtEtcIncpMgr".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        String message = "";
        String code = "1";

        try {
            int cnt = saveSimplePymtEtcIncpMgr(mp, queryMap);

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