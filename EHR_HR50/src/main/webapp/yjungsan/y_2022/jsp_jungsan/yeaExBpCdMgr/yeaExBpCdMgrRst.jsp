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
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.io.Serializable"%>

<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//사업장예외관리 다건 조회
public List getYeaExBpCdMgr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	//년도
	String searchWorkYy	= String.valueOf(pm.get("searchWorkYy"));

	//작업구분
	String searchAdjustType	= String.valueOf(pm.get("searchAdjustType"));

	//기존사업장
	String searchStdBpCd	= String.valueOf(pm.get("searchStdBpCd"));

	//변경사업장
	String searchChgBpCd	= String.valueOf(pm.get("searchChgBpCd"));

	//사번/성명
	String searchSabunNameAlias	= String.valueOf(pm.get("searchSabunNameAlias"));

	//변경대상
	String searchChgType	= String.valueOf(pm.get("searchChgType"));

	//취소대상
	String searchCancleType	= String.valueOf(pm.get("searchCancleType"));

	//상태
	String searchStatusCd	= String.valueOf(pm.get("searchStatusCd"));

	StringBuffer query = new StringBuffer();

	query.setLength(0);

    //년도
	if(searchWorkYy.trim().length() != 0 ){
		query.append(" AND WORK_YY = '"+searchWorkYy+"'");
	}
    //작업구분
	if(searchAdjustType.trim().length() != 0 ){
		query.append(" AND ADJUST_TYPE = '"+searchAdjustType+"'");
	}
    //기존사업장
	if(searchStdBpCd.trim().length() != 0 ){
		query.append(" AND STD_BP_CD = '"+searchStdBpCd+"'");
	}
    //변경사업장
	if(searchChgBpCd.trim().length() != 0 ){
		query.append(" AND CHG_BP_CD = '"+searchChgBpCd+"'");
	}
	//사번/성명
	if(searchSabunNameAlias.trim().length() != 0 ){
		query.append(" AND (A.SABUN || B.NAME) LIKE '%" +searchSabunNameAlias+"%'");
	}
	//변경대상
	if(searchChgType.trim().length() != 0 ){
		query.append(" AND A.CHG_CHK = '"+searchChgType+"'");
	}
	//사번/성명
	if(searchCancleType.trim().length() != 0 ){
		query.append(" AND A.CANCEL_CHK = '"+searchCancleType+"'");
	}
	//사번/성명
	if(searchStatusCd.trim().length() != 0 ){
		query.append(" AND A.STATUS_CD = '"+searchStatusCd+"'");
	}

	pm.put("query", query.toString());

	try{

		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getYeaExBpCdMgr",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}

//사업장예외관리 저장
public int saveYeaExBpCdMgr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

  //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
  List list = StringUtil.getParamListData(paramMap);
  Map queryMap = XmlQueryParser.getQueryMap(locPath);
  //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
  Connection conn = DBConn.getConnection();
  int rstCnt = 0;

  if(list != null && list.size() > 0 && conn != null) {

      //사용자가 직접 트랜젝션 관리
      conn.setAutoCommit(false);

      try{
    	  String searchWorkYy = "";
    	  String searchAdjustType = "";

          for(int i = 0; i < list.size(); i++ ) {

              Map mp = (Map)list.get(i);
              String sStatus = (String)mp.get("sStatus");
              Map mp2 = (Map)list.get(0);
              String menuNm = (String)mp2.get("menuNm");
              mp.put("menuNm", menuNm);
              if((String)mp.get("searchWorkYy") != null){
            	  searchWorkYy = (String)mp.get("searchWorkYy");
              }
              if((String)mp.get("searchAdjustType") != null){
            	  searchAdjustType = (String)mp.get("searchAdjustType");
              }

              mp.put("searchWorkYy", searchWorkYy);
              mp.put("searchAdjustType", searchAdjustType);

              if("D".equals(sStatus)) {
                  //삭제
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaExBpCdMgr", mp);
              } else if("I".equals(sStatus) || "U".equals(sStatus) ) {
                //수정
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveYeaExBpCdMgr", mp);
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
      }
  }

  return rstCnt;
}


%>

<%
	String locPath = xmlPath+"/yeaExBpCdMgr/yeaExBpCdMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	//사업장예외관리 다건 조회
	if("getYeaExBpCdMgr".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getYeaExBpCdMgr(mp, locPath, ssnYeaLogYn);
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
	//사업장예외관리 저장
	else if("saveYeaExBpCdMgr".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        String message = "";
        String code = "1";

        try {
            int cnt = saveYeaExBpCdMgr(mp, locPath, ssnYeaLogYn);

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
	//사업장예외관리 복사 프로시저 호출
	else if("P_CPN_YEA_EX_BP_CHG".equals(cmd)) {
		//연말정산 대상자 작업

		Map paramMap = StringUtil.getRequestMap(request);

		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);

		Map mp =  StringUtil.getParamMapData(paramMap);

		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String pgubun = (String)mp.get("searchPGubun");
		String businessCd = (String)mp.get("businessCd");

		String[] type =  new String[]{"OUT","OUT","OUT"
				,"STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",""
				,ssnEnterCd,workYy,adjustType,pgubun,businessCd,ssnSabun};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_EX_BP_CHG",type,param);

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