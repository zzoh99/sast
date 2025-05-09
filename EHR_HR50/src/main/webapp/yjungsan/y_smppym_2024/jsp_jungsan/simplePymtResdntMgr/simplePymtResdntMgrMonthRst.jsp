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
//비거주자 사업기타소득관리 다건 조회
public List getsimplePymtResdntMgr(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	//년도
	String searchYear	= String.valueOf(pm.get("searchYear"));
	//월
	String searchWorkMm	= String.valueOf(pm.get("searchWorkMm"));
	//반기구분
	String searchHalfType	= String.valueOf(pm.get("searchHalfType"));
	//사업장
	String searchBusinessPlace	= String.valueOf(pm.get("searchBusinessPlace"));
	//사번/성명
	String searchSabunNameAlias	= String.valueOf(pm.get("searchSabunNameAlias"));
	
	String searchCitizenType	= String.valueOf(pm.get("searchCitizenType")  );// 내/외국인
	String searchResidencyType	= String.valueOf(pm.get("searchResidencyType"));// 거주자구분
	String searchTaxMon	        = String.valueOf(pm.get("searchTaxMon")       );// 금액발생	

	StringBuffer query = new StringBuffer();

	query.setLength(0);

    //년도
	if(searchYear.trim().length() != 0 ){

		query.append(" AND WORK_YY = '"+searchYear+"'");
	}
    //월
	if(searchWorkMm.trim().length() != 0 ){

		query.append(" AND WORK_MM = '"+searchWorkMm+"'");
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
	//내/외국인
	if(searchCitizenType.trim().length() != 0){
		query.append(" AND A.CITIZEN_TYPE = '" +searchCitizenType+ "'");
	}
	/* //거주자구분
	if(searchResidencyType.trim().length() != 0){
		query.append(" AND A.RESIDENCY_TYPE = '" +searchResidencyType+ "'");
	} */
	//금액발생 
	if(searchTaxMon.trim().length() != 0){
		if(searchTaxMon.equals("Y")){
			query.append(" AND ( NVL(TAX_MON,0) != 0 OR NVL(ETC_BONUS_MON,0) != 0 )");	
		}else{
			query.append(" AND ( NVL(TAX_MON,0) = 0 AND NVL(ETC_BONUS_MON,0) = 0 )");
		}
	}		
	pm.put("query", query.toString());
	
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getsimplePymtResdntMgr",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}


//중복 사번 체크
public List getSabunChk(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	//사번
	String sabuns	= String.valueOf(pm.get("sabuns"));
	//대상년도
	String searchYear	= String.valueOf(pm.get("searchYear"));
	//월
	String searchWorkMm	= String.valueOf(pm.get("searchWorkMm"));
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
	//월
	if(searchWorkMm.trim().length() != 0 ){

		query.append(" AND WORK_MM = '"+searchWorkMm+"'");
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

//비거주자 사업기타소득관리 저장
public int savesimplePymtResdntMgr(Map paramMap, Map queryMap) throws Exception {
  
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
    	  
          for(int i = 0; i < list.size(); i++ ) {
        	  
              Map mp = (Map)list.get(i);
              String sStatus = (String)mp.get("sStatus");
              
              if((String)mp.get("searchYear") != null){
            	  searchYear = (String)mp.get("searchYear"); 
              }

              if((String)mp.get("searchWorkMm") != null){
            	  searchWorkMm = (String)mp.get("searchWorkMm"); 
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
              mp.put("searchWorkMm", searchWorkMm);
              mp.put("searchHalfType", searchHalfType);
              
              if("D".equals(sStatus)) {
                  //삭제
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "deletesimplePymtResdntMgr", mp);
              } else if("I".equals(sStatus) || "U".equals(sStatus) ) {
                //수정
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "savesimplePymtResdntMgr", mp);
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

//전체마감/전체마감취소
public int updateSimplePymtEarnIncpMgr(Map paramMap, Map queryMap) throws Exception {
	
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map mp = null;

	String searchBusinessPlace = String.valueOf(pm.get("searchBusinessPlace"));// 사업장
	
	StringBuffer query = new StringBuffer();
	query.setLength(0);

	if(searchBusinessPlace.trim().length() != 0){
		query.append(" AND BUSINESS_PLACE_CD = '"+searchBusinessPlace+"'");
	}
	pm.put("query", query.toString());
	
	
	int rstCnt = 0;
	
	try{
		//쿼리 실행및 결과 받기.
		rstCnt  = DBConn.executeUpdate(queryMap, "updateSimplePymtEarnIncpMgr", pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}
	
	return rstCnt;
}

%>

<%
	Map queryMap = XmlQueryParser.getQueryMap(xmlPath+"/simplePymtResdntMgr/simplePymtResdntMgrMonth.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	//비거주자 사업기타소득관리 다건 조회
	if("getsimplePymtResdntMgr".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = getsimplePymtResdntMgr(mp, queryMap);
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
	
	//중복 사번 체크
	else if("getSabunChk".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = getSabunChk(mp, queryMap);
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}
		
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);
		
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData.get(0));
		out.print((new org.json.JSONObject(rstMap)).toString());
			
	}

	//비거주자 사업기타소득관리 저장
	else if("savesimplePymtResdntMgr".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        String message = "";
        String code = "1";
        
        try {
            int cnt = savesimplePymtResdntMgr(mp, queryMap);
            
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
	//비거주자 사업기타소득관리 프로시저 호출
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
    //비거주자 사업기타소득관리 프로시저 호출
    else if("P_CPN_SMPPYM_EMP_2021".equals(cmd)) {
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
            
            String[] rstStr = DBConn.executeProcedure("P_CPN_SMPPYM_EMP_2021",type,param);
            
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
	// 전체마감/전체마감취소 
			else if("updateSimplePymtEarnIncpMgr".equals(cmd)) {
				
				Map mp = StringUtil.getRequestMap(request);
				mp.put("ssnEnterCd", ssnEnterCd);
				mp.put("ssnSabun", ssnSabun);
				
				String message = "";
				String code = "1";
				
				try {
					int cnt = updateSimplePymtEarnIncpMgr(mp, queryMap);

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
			
			} else if("P_CPN_SMPPYM_EMP_2024".equals(cmd)) {
		        //연말정산 대상자 작업
		        
		        Map paramMap = StringUtil.getRequestMap(request);
		        
		        paramMap.put("ssnEnterCd", ssnEnterCd);
		        paramMap.put("ssnSabun", ssnSabun);
		        
		        Map mp =  StringUtil.getParamMapData(paramMap);

		        String halfType = (String)mp.get("halfType");
		        String incomeType = (String)mp.get("incomeType");
		        String workYy = (String)mp.get("workYy");
		        String workMm = (String)mp.get("workMm");
		        String creWorkYy = (String)mp.get("creWorkYy");
		        String sabun = (String)mp.get("sabun");
		        String delYn = (String)mp.get("delYn");
		        String calcType = (String)mp.get("calcType");
                String businessPlace = (String)mp.get("businessPlace");

		        String[] type =  new String[]{"OUT","OUT","OUT"
		                ,"STR","STR","STR","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
		        String[] param = new String[]{"","",""
		                ,ssnEnterCd,"",halfType,incomeType,workYy,workMm,creWorkYy,sabun,businessPlace,delYn,calcType,ssnSabun};
		        
		        String message = "";
		        String code = "1";
		        int cnt = 0;
		        
		        try {
		            
		            String[] rstStr = DBConn.executeProcedure("P_CPN_SMPPYM_EMP_2024",type,param);
		            
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