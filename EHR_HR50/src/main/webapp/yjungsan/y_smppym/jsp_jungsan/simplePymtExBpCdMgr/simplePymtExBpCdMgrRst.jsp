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

//사업장예외관리 다건 조회
public List getSimplePymtExBpCdMgr(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	//년도
	String searchWorkYy	= String.valueOf(pm.get("searchWorkYy"));
	
	//반기구분
	String searchHalfType	= String.valueOf(pm.get("searchHalfType"));

	//신고구분
	String searchSendType	= String.valueOf(pm.get("searchSendType"));
	
	//소득구분
	String searchIncomeType	= String.valueOf(pm.get("searchIncomeType"));
	
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
    //반기구분
    if(searchHalfType.trim().length() != 0 ){

		query.append(" AND HALF_TYPE = '"+searchHalfType+"'");
	}
    //신고구분
    if(searchSendType.trim().length() != 0 ){

		query.append(" AND SEND_TYPE = '"+searchSendType+"'");
	}    
    //소득구분
    if(searchIncomeType.trim().length() != 0 ){

		query.append(" AND INCOME_TYPE = '"+searchIncomeType+"'");
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
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getSimplePymtExBpCdMgr",pm);
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
	//입사일
	String adjSYmds	= String.valueOf(pm.get("adjSYmds"));
	//대상년도
	String searchWorkYy	= String.valueOf(pm.get("searchWorkYy"));
	//반기구분
	String searchHalfType	= String.valueOf(pm.get("searchHalfType"));
	//신고구분
	String searchSendType	= String.valueOf(pm.get("searchSendType"));
	//소득구분
	String searchIncomeType	= String.valueOf(pm.get("searchIncomeType"));	
	//기존사업장
	String searchStdBpCd	= String.valueOf(pm.get("searchStdBpCd"));
	//변경사업장
	String searchChgBpCd	= String.valueOf(pm.get("searchChgBpCd"));
	

	StringBuffer query = new StringBuffer();

	query.setLength(0);

  	//사번
	if(sabuns.trim().length() != 0 ){

		query.append(" AND SABUN IN(" +sabuns+ ")");
	}
	//입사일
	if(adjSYmds.trim().length() != 0 ){

		query.append(" AND ADJ_S_YMD IN(" +adjSYmds+ ")");
	}
  	//대상년도
	if(searchWorkYy.trim().length() != 0 ){

		query.append(" AND WORK_YY = '"+searchWorkYy+"'");
	}
  	//반기구분
	if(searchHalfType.trim().length() != 0 ){

		query.append(" AND HALF_TYPE = '"+searchHalfType+"'");
	}
  	//신고구분
	if(searchSendType.trim().length() != 0 ){

		query.append(" AND SEND_TYPE = '"+searchSendType+"'");
	}  	  	
  	//소득구분
	if(searchIncomeType.trim().length() != 0 ){

		query.append(" AND INCOME_TYPE = '"+searchIncomeType+"'");
	}  	
  	//기존사업장
	if(searchStdBpCd.trim().length() != 0 ){

		query.append(" AND STD_BP_CD = '"+searchStdBpCd+"'");
	}
  	//변경사업장
	if(searchChgBpCd.trim().length() != 0 ){

		query.append(" AND CHG_BP_CD = '"+searchChgBpCd+"'");
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


//사업장예외관리 저장
public int saveSimplePymtExBpCdMgr(String path, Map paramMap) throws Exception {
	Map queryMap = XmlQueryParser.getQueryMap(path);
  //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
  List list = StringUtil.getParamListData(paramMap);
  //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
  Connection conn = DBConn.getConnection();
  int rstCnt = 0;
  
  if(list != null && list.size() > 0 && conn != null) {
  
      //사용자가 직접 트랜젝션 관리
      conn.setAutoCommit(false);
      
      try{
    	  String searchWorkYy = "";
    	  String searchHalfType = "";
    	  String searchSendType = "";
    	  String searchIncomeType = "";
    	  
          for(int i = 0; i < list.size(); i++ ) {
        	  
              Map mp = (Map)list.get(i);
              String sStatus = (String)mp.get("sStatus");

              if((String)mp.get("searchWorkYy") != null){
            	  searchWorkYy = (String)mp.get("searchWorkYy"); 
              }
              
              if((String)mp.get("searchHalfType") != null){
            	  searchHalfType = (String)mp.get("searchHalfType"); 
              }
              
              if((String)mp.get("searchSendType") != null){
            	  searchSendType = (String)mp.get("searchSendType"); 
              }
              
              if((String)mp.get("searchIncomeType") != null){
            	  searchIncomeType = (String)mp.get("searchIncomeType"); 
              }
              
              mp.put("searchWorkYy", searchWorkYy);
              mp.put("searchHalfType", searchHalfType);
              mp.put("searchSendType", searchSendType);
              mp.put("searchIncomeType", searchIncomeType);
              
              if("D".equals(sStatus)) {
                  //삭제
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteSimplePymtExBpCdMgr", mp);
              } else if("I".equals(sStatus) || "U".equals(sStatus) ) {
                //수정
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveSimplePymtExBpCdMgr", mp);
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
	//setQueryMap(xmlPath+"/simplePymtExBpCdMgr/simplePymtExBpCdMgr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	//사업장예외관리 다건 조회
	if("getSimplePymtExBpCdMgr".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = getSimplePymtExBpCdMgr(xmlPath+"/simplePymtExBpCdMgr/simplePymtExBpCdMgr.xml", mp);
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
			listData = getSabunChk(xmlPath+"/simplePymtExBpCdMgr/simplePymtExBpCdMgr.xml", mp);
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
	
	//사업장예외관리 저장
	else if("savesimplePymtExBpCdMgr".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        String message = "";
        String code = "1";
        
        try {
            int cnt = saveSimplePymtExBpCdMgr(xmlPath+"/simplePymtExBpCdMgr/simplePymtExBpCdMgr.xml", mp);
            
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
	
	//사업장예외관리 전반기 복사 프로시저 호출
	else if("P_CPN_SMPPYM_EX_BP_COPY".equals(cmd)) {
		//연말정산 대상자 작업
		
		Map paramMap = StringUtil.getRequestMap(request);
		
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		
		Map mp =  StringUtil.getParamMapData(paramMap);

		String fromWorkYy = (String)mp.get("searchFromWorkYy");
		String toWorkYy = (String)mp.get("searchToWorkYy");
		String fromSendType = (String)mp.get("searchFromSendType");
		String toSendType = (String)mp.get("searchToSendType");
		String fromHalfType = (String)mp.get("searchFromHalfType");
		String toHalfType = (String)mp.get("searchToHalfType");
		String toIncomeType = (String)mp.get("searchToIncomeType");
		String delYn = (String)mp.get("delYn");

		String[] type =  new String[]{"OUT","OUT","OUT"
				,"STR","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",""
				,ssnEnterCd,fromWorkYy,toWorkYy,fromSendType,toSendType,fromHalfType,toHalfType,toIncomeType,delYn,ssnSabun};
		
		String message = "";
		String code = "1";
		int cnt = 0;
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_SMPPYM_EX_BP_COPY",type,param);
			
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

	//사업장예외관리 복사 프로시저 호출
	else if("P_CPN_SMPPYM_EX_BP_CHG".equals(cmd)) {
		//연말정산 대상자 작업
		
		Map paramMap = StringUtil.getRequestMap(request);
		
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		
		Map mp =  StringUtil.getParamMapData(paramMap);

		String workYy = (String)mp.get("searchWorkYy");
		String sendType = (String)mp.get("searchSendType");
		String halfType = (String)mp.get("searchHalfType");
		String incomeType = (String)mp.get("searchIncomeType");
		String pgubun = (String)mp.get("searchPGubun");
		String businessCd = (String)mp.get("businessCd");
		
		String[] type =  new String[]{"OUT","OUT","OUT"
				,"STR","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",""
				,ssnEnterCd,workYy,sendType,halfType,incomeType,pgubun,businessCd,ssnSabun};
		
		String message = "";
		String code = "1";
		int cnt = 0;
		
		try {
			
			String[] rstStr = DBConn.executeProcedure("P_CPN_SMPPYM_EX_BP_CHG",type,param);
			
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