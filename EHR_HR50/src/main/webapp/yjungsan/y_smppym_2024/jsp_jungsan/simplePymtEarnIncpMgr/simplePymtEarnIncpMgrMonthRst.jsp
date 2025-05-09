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
//근로소득관리 다건 조회
public List getSimplePymtEarnIncpMgr(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;

	String searchYear	        = String.valueOf(pm.get("searchYear")          );//년도
	String searchWorkMm	            = String.valueOf(pm.get("searchWorkMm")            );//지급월
	String searchHalfType	    = String.valueOf(pm.get("searchHalfType")      );//반기구분
    String searchSendType       = String.valueOf(pm.get("searchSendType")      );//신고구분
	String searchBusinessPlace	= String.valueOf(pm.get("searchBusinessPlace") );//사업장
	String searchSabunNameAlias	= String.valueOf(pm.get("searchSabunNameAlias"));//사번/성명
	String searchCitizenType	= String.valueOf(pm.get("searchCitizenType")   );//내/외국인
	String searchResidencyType	= String.valueOf(pm.get("searchResidencyType") );//거주자구분
	String searchTaxMon	        = String.valueOf(pm.get("searchTaxMon")        );//금액발생

	//2021.07.21
	String searchFinalCloseYn   = String.valueOf(pm.get("searchFinalCloseYn" ) );//마감여부
	String searchEYmdYn         = String.valueOf(pm.get("searchEYmdYn")        );//퇴사여부

	StringBuffer query = new StringBuffer();
	query.setLength(0);


	if(searchYear.trim().length()           != 0){query.append(" AND WORK_YY = '"+searchYear+"'");                             }//년도
	if(searchWorkMm.trim().length()         != 0){query.append(" AND WORK_MM = '"+searchWorkMm+"'");                           }//지급월
    if(searchHalfType.trim().length()       != 0){query.append(" AND HALF_TYPE = '"+searchHalfType+"'");                       }//반기구분
    if(searchSendType.trim().length()       != 0){query.append(" AND SEND_TYPE = '"+searchSendType+"'");                       }//신고구분
	if(searchBusinessPlace.trim().length()  != 0){query.append(" AND BUSINESS_PLACE_CD = '"+searchBusinessPlace+"'");          }//사업장
	if(searchSabunNameAlias.trim().length() != 0){query.append(" AND (A.SABUN || A.NAME) LIKE '%" +searchSabunNameAlias+"%'"); }//사번/성명
	if(searchCitizenType.trim().length()    != 0){query.append(" AND A.CITIZEN_TYPE = '" +searchCitizenType+ "'");             }//내/외국인
	if(searchResidencyType.trim().length()  != 0){query.append(" AND A.RESIDENCY_TYPE = '" +searchResidencyType+ "'");         }//거주자구분
	if(searchFinalCloseYn.trim().length()   != 0){query.append(" AND A.FINAL_CLOSE_YN = '" +searchFinalCloseYn+ "'");          }//마감여부

	//금액발생
	if(searchTaxMon.trim().length() != 0){
		if(searchTaxMon.equals("Y")){
			query.append(" AND ( NVL(TAX_MON,0) != 0 OR NVL(ETC_BONUS_MON,0) != 0 )");
		}else{
			query.append(" AND ( NVL(TAX_MON,0) = 0 AND NVL(ETC_BONUS_MON,0) = 0 )");
		}
	}

    //퇴사여부
    if(searchEYmdYn.trim().length() != 0){
    	if(searchEYmdYn.equals("Y")){
    		query.append(" AND B.RET_YMD IS NOT NULL");
    	}else{
    		query.append(" AND B.RET_YMD IS NULL");
    	}

    }
	//2021.07.02 (반기구분)
    StringBuffer query2 = new StringBuffer();
    query2.setLength(0);

    query2.append(", NVL((SELECT TAX_MON FROM TYEA812 WHERE ENTER_CD = A.ENTER_CD AND SABUN = A.SABUN AND ADJ_S_YMD = A.ADJ_S_YMD  AND WORK_YY = #searchYear# AND WORK_YY = #searchWorkMm#),'0') AS TAX_MON");
    query2.append(", NVL((SELECT ETC_BONUS_MON FROM TYEA812 WHERE ENTER_CD = A.ENTER_CD AND SABUN = A.SABUN AND ADJ_S_YMD = A.ADJ_S_YMD AND WORK_YY = #searchYear# AND WORK_YY = #searchWorkMm#),'0') AS ETC_BONUS_MON");


    pm.put("query", query.toString());
    pm.put("query2", query2.toString());

	try{

		Map mapData = null;
		String hptbCnt = "0";

		if("GSS".equals(String.valueOf(pm.get("ssnEnterCd")))) {
			hptbCnt = "1";
		}
		else {
			//전화번호 관련 테이블 컬럼 갯수 확인
			mapData  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getHpTableCnt",pm);
			hptbCnt = (mapData==null||mapData.get("hptb_cnt")==null) ? "0" : (String)mapData.get("hptb_cnt");
		}

		StringBuffer isQuery = new StringBuffer();

		isQuery.setLength(0);

		//전화번호 테이블의 컬럼수가 7 이상일 경우
		if(Integer.parseInt(hptbCnt) > 0){
			isQuery.append("(SELECT CONT_ADDRESS FROM THRM124 WHERE CONT_TYPE = 'HP' AND ENTER_CD = A.ENTER_CD  AND SABUN = A.SABUN)");
		}else{
			isQuery.append("(SELECT HAND_PHONE FROM THRM124 WHERE ENTER_CD = A.ENTER_CD AND SABUN = A.SABUN)");
		}

		pm.put("isQuery", isQuery.toString());

		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getSimplePymtEarnIncpMgr",pm);
	} catch (Exception e) {
		log.error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return listData;
}



//중복 사번 체크
public List getSabunChk(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;


	String sabuns	           = String.valueOf(pm.get("sabuns")             );//사번
	String adjSYmds    	       = String.valueOf(pm.get("adjSYmds")           );//입사일
	String searchYear	       = String.valueOf(pm.get("searchYear")         );//대상년도
	String searchWorkMm	       = String.valueOf(pm.get("searchWorkMm")         );//지급월
	String searchHalfType	   = String.valueOf(pm.get("searchHalfType")     );//반기구분
	String searchBusinessPlace = String.valueOf(pm.get("searchBusinessPlace"));//사업장

	StringBuffer query = new StringBuffer();
	query.setLength(0);

	if(sabuns.trim().length()              != 0 ){query.append(" AND SABUN IN(" +sabuns+ ")");                         }//사번
	if(adjSYmds.trim().length()            != 0 ){query.append(" AND ADJ_S_YMD IN(" +adjSYmds+ ")");                   }//입사일
	if(searchYear.trim().length()          != 0 ){query.append(" AND WORK_YY = '"+searchYear+"'");                     }//대상년도
	if(searchWorkMm.trim().length()        != 0 ){query.append(" AND WORK_MM = '"+searchWorkMm+"'");                   }//지급월
	if(searchHalfType.trim().length()      != 0 ){query.append(" AND HALF_TYPE = '"+searchHalfType+"'");               }//반기구분
	if(searchBusinessPlace.trim().length() != 0 ){query.append(" AND BUSINESS_PLACE_CD = '"+searchBusinessPlace+"'");  }//사업장

	pm.put("query", query.toString());

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getSabunChk",pm);
	} catch (Exception e) {
		log.error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	return listData;
}

//근로소득관리 저장
public int saveSimplePymtEarnIncpMgr(Map paramMap, Map queryMap) throws Exception {

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
    	  String monthSeq = "";
          for(int i = 0; i < list.size(); i++ ) {

              Map mp = (Map)list.get(i);
              String sStatus     = (String)mp.get("sStatus");

              if("0".equals((String)mp.get("final_close_yn"))){
            	  mp.put("final_close_yn", "N");
              }else{
            	  mp.put("final_close_yn", "Y");
              }

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

              mp.put("searchYear", searchYear);
              mp.put("searchWorkMm", searchWorkMm);
              mp.put("searchHalfType", searchHalfType);
              mp.put("halfDivFlag", halfDivFlag);

              if("D".equals(sStatus)) {
                  //삭제
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteSimplePymtEarnIncpMgr", mp);
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteSimplePymtEarnIncpMgr812", mp);
              } else if("I".equals(sStatus) || "U".equals(sStatus) ) {
                  //수정
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveSimplePymtEarnIncpMgr", mp);

                  mp.put("tax_mon"      , (String)mp.get("tax_mon")      );
                  mp.put("etc_bonus_mon", (String)mp.get("etc_bonus_mon"));
                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveSimplePymtEarnIncpMgr812", mp);
              }
          }

          //커밋
          conn.commit();
      } catch(UserException e) {
          try {
              //롤백
              conn.rollback();
          } catch (Exception e1) {
              log.error("[rollback Exception] " + e);
          }
          rstCnt = 0;
          log.error("[Exception] " + e);
          throw new Exception(e.getMessage());
      } catch(Exception e) {
          try {
              //롤백
              conn.rollback();
          } catch (Exception e1) {
              log.error("[rollback Exception] " + e);
          }
          rstCnt = 0;
          log.error("[Exception] " + e);
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
		log.error("[Exception] " + e);
		throw new Exception("저장에 실패하였습니다.");
	}

	return rstCnt;
}

/*
//거주지국 일괄 대한민국으로 변경 (해외일경우)
public int etcSaveAllSimplePymtEarnIncpMgr(Map paramMap) throws Exception {

//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
List list = StringUtil.getParamListData(paramMap);
//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
Connection conn = DBConn.getConnection();
int rstCnt = 0;

if(list != null && list.size() > 0) {

    //사용자가 직접 트랜젝션 관리
    conn.setAutoCommit(false);

    try{
  	  String searchYear = "";
  	  String searchHalfType = "";

        for(int i = 0; i < list.size(); i++ ) {

            Map mp = (Map)list.get(i);

            //삭제
            rstCnt += DBConn.executeUpdate(conn, queryMap, "etcSaveAllSimplePymtEarnIncpMgr", mp);

        }

        //커밋
        conn.commit();
    } catch(UserException e) {
        try {
            //롤백
            conn.rollback();
        } catch (Exception e1) {
            log.error("[rollback Exception] " + e);
        }
        rstCnt = 0;
        log.error("[Exception] " + e);
        throw new Exception(e.getMessage());
    } catch(Exception e) {
        try {
            //롤백
            conn.rollback();
        } catch (Exception e1) {
            log.error("[rollback Exception] " + e);
        }
        rstCnt = 0;
        log.error("[Exception] " + e);
        throw new Exception("거주지국 일괄 변경에 실패하였습니다.");
    } finally {
        DBConn.closeConnection(conn, null, null);
    }
}

return rstCnt;
}
 */
 //2021.07.05(반기구분별 SHEET)
 public List selectTitleList(Map paramMap, Map queryMap) throws Exception {

        //파라메터 복사.
        Map pm =  StringUtil.getParamMapData(paramMap);
        List listData = null;

        try{
            //쿼리 실행및 결과 받기.
            listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectTitleList",pm);
        } catch (Exception e) {
            log.error("[Exception] " + e);
            throw new Exception("조회에 실패하였습니다.");
        }

        return listData;
    }
 //작업일자 조회
 public List selectPayAction(Map paramMap, Map queryMap) throws Exception {

	    //파라메터 복사.
	    Map pm =  StringUtil.getParamMapData(paramMap);
	    List listData = null;

	    String searchChkYn  = String.valueOf(pm.get("searchChkYn"));
	    String searchPayCd  = String.valueOf(pm.get("searchPayCd"));
	    StringBuffer query = new StringBuffer();
	    query.setLength(0);

	    if("Y".equals(searchChkYn) || "N".equals(searchChkYn)){
	        query.append(" AND CHK_YN = '"+searchChkYn+"'");
	    }
	    if(searchPayCd.trim().length() != 0){
	    	query.append(" AND F_CPN_YEA_PAY_CD(#ssnEnterCd#,PAY_CD) = '"+searchPayCd+"'");
	    }
	    pm.put("query", query.toString());
	    try{
	        //쿼리 실행및 결과 받기.
	        listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectPayAction",pm);

	    } catch (Exception e) {
	        log.error("[Exception] " + e);
	        throw new Exception("조회에 실패하였습니다.");
	    }

	    return listData;
	}
//
public List selectElementCd(Map paramMap, Map queryMap) throws Exception {

   //파라메터 복사.
   Map pm =  StringUtil.getParamMapData(paramMap);
   List listData = null;

   try{
       //쿼리 실행및 결과 받기.
       listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectElementCd",pm);
   } catch (Exception e) {
       log.error("[Exception] " + e);
       throw new Exception("조회에 실패하였습니다.");
   }

   return listData;
}

public List selectEtcBouns(Map paramMap, Map queryMap) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
    List listData = null;

    //년도
    String searchYear   = String.valueOf(pm.get("searchYear"));
    String searchWorkMm     = String.valueOf(pm.get("searchWorkMm"));

    try{
        //쿼리 실행및 결과 받기.
        listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEtcBouns",pm);

    } catch (Exception e) {
        log.error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    }

    return listData;
}
public int saveEtcBouns(Map paramMap, Map queryMap) throws Exception {

	  //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	  List list = StringUtil.getParamListData(paramMap);

	  //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	  Connection conn = DBConn.getConnection();
	  int rstCnt = 0;

	  if(list != null && list.size() > 0 && conn != null) {

	      //사용자가 직접 트랜젝션 관리
	      conn.setAutoCommit(false);

	      try{
	    	  String workYy = "";
	    	  String workMm = "";
	          String halfType = "";
	          String sendType = "";

	          for(int i = 0; i < list.size(); i++ ) {

	              Map mp = (Map)list.get(i);
	              String sStatus     = (String)mp.get("sStatus");
	              String chk_yn      = (String)mp.get("chk_yn");

	              if((String)mp.get("workYy")    != null){workYy   = (String)mp.get("workYy"); }//귀속년도
	              if((String)mp.get("workMm")    != null){workMm   = (String)mp.get("workMm"); }//지급월
	              if((String)mp.get("halfType")  != null){halfType = (String)mp.get("halfType"); }//반기구분
	              if((String)mp.get("sendType")  != null){sendType = (String)mp.get("sendType"); }//신고구분

	              mp.put("workYy"  , workYy);
	              mp.put("workMm"  , workMm);
	              mp.put("halfType", halfType);
	              mp.put("sendType", sendType);

	              if("I".equals(sStatus) || "U".equals(sStatus)) {
	                  //수정
	                  rstCnt += DBConn.executeUpdate(conn, queryMap, "saveEtcBouns", mp);
	              }
	          }
	          //커밋
	          conn.commit();
	      } catch(UserException e) {
	          try {
	              //롤백
	              conn.rollback();
	          } catch (Exception e1) {
	              log.error("[rollback Exception] " + e);
	          }
	          rstCnt = 0;
	          log.error("[Exception] " + e);
	          throw new Exception(e.getMessage());
	      } catch(Exception e) {
	          try {
	              //롤백
	              conn.rollback();
	          } catch (Exception e1) {
	              log.error("[rollback Exception] " + e);
	          }
	          rstCnt = 0;
	          log.error("[Exception] " + e);
	          throw new Exception("저장에 실패하였습니다.");
	      } finally {
	          DBConn.closeConnection(conn, null, null);
	      }
	  }
	  return rstCnt;
}

//급여코드조회
public List getPayCdList(Map paramMap, Map queryMap) throws Exception {

  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
  List listData = null;

  try{
      //쿼리 실행및 결과 받기.
      listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"getPayCdList",pm);
  } catch (Exception e) {
      log.error("[Exception] " + e);
      throw new Exception("조회에 실패하였습니다.");
  }

  return listData;
}
//인정상여설정
public int updateEtcBouns(Map paramMap, Map queryMap) throws Exception {
    //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
    List list = StringUtil.getParamListData(paramMap);

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);

    String searchBusinessPlace = String.valueOf(pm.get("searchBusinessPlace"));//사업장
    String searchYMD           = String.valueOf(pm.get("searchYMD"));          //수당기준일자

    StringBuffer query = new StringBuffer();
    query.setLength(0);

    if(searchBusinessPlace.trim().length() != 0){
        query.append(" AND BUSINESS_PLACE_CD = '"+searchBusinessPlace+"'");
    }
    pm.put("query", query.toString());

    //사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
    Connection conn = DBConn.getConnection();
    int rstCnt = 0;

    if(list != null && list.size() > 0 && conn != null) {

        //사용자가 직접 트랜젝션 관리
        conn.setAutoCommit(false);

        try{
            for(int i = 0; i < list.size(); i++ ) {
                Map mp = (Map)list.get(i);

                mp.put("searchYMD", searchYMD);

                String sStatus      = (String)mp.get("sStatus");
                if("I".equals(sStatus) || "U".equals(sStatus) || "D".equals(sStatus)) {
                    //수정
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "updateEtcBouns", mp);
                }
            }
            //커밋
            conn.commit();
        } catch(UserException e) {
            try {
                //롤백
                conn.rollback();
            } catch (Exception e1) {
                log.error("[rollback Exception] " + e);
            }
            rstCnt = 0;
            log.error("[Exception] " + e);
            throw new Exception(e.getMessage());
        } catch(Exception e) {
            try {
                //롤백
                conn.rollback();
            } catch (Exception e1) {
                log.error("[rollback Exception] " + e);
            }
            rstCnt = 0;
            log.error("[Exception] " + e);
            throw new Exception("저장에 실패하였습니다.");
        } finally {
            DBConn.closeConnection(conn, null, null);
        }
    }

    return rstCnt;
}
//작업선택건수
public Map getPayCdChkCnt(Map paramMap, Map queryMap) throws Exception {

 //파라메터 복사.
 Map pm =  StringUtil.getParamMapData(paramMap);
 Map mp = null;

 try{
     //쿼리 실행및 결과 받기.
     mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getPayCdChkCnt",pm);
 } catch (Exception e) {
     log.error("[Exception] " + e);
     throw new Exception("조회에 실패하였습니다.");
 }

 return mp;
}
%>

<%
	Map queryMap = XmlQueryParser.getQueryMap(xmlPath+"/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonth.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	//근로소득관리 다건 조회
	if("getSimplePymtEarnIncpMgr".equals(cmd)) {

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = getSimplePymtEarnIncpMgr(mp, queryMap);
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

	}else if("saveSimplePymtEarnIncpMgr".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        String message = "";
        String code = "1";

        try {
            int cnt = saveSimplePymtEarnIncpMgr(mp, queryMap);

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

	//근로소득관리 프로시저 호출
	else if("P_CPN_SMPPYM_EMP".equals(cmd)) {
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

		String[] type =  new String[]{"OUT","OUT","OUT"
				,"STR","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",""
				,ssnEnterCd,halfType,incomeType,workYy,workMm,creWorkYy,sabun,delYn,calcType,ssnSabun};

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
	//근로소득관리 프로시저 호출
    else if("P_CPN_SMPPYM_EMP_2021".equals(cmd)) {
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

        String[] type =  new String[]{"OUT","OUT","OUT"
                ,"STR","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
        String[] param = new String[]{"","",""
                ,ssnEnterCd,halfType,incomeType,workYy,workMm,creWorkYy,sabun,delYn,calcType,ssnSabun};

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

	}else if("selectTitleList".equals(cmd)) {
		//2021.07.05(반기구분별 SHEET)
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectTitleList(mp, queryMap);
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

    } else if("selectPayAction".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectPayAction(mp, queryMap);
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

    }  else if("selectElementCd".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectElementCd(mp, queryMap);
        } catch(Exception e) {
            code = "-1";
            message = e.getMessage();
        }

        Map mapCode = new HashMap();
        mapCode.put("Code", code); //ajax 성공코드 1번, 그외 오류
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        rstMap.put("codeList", (List)listData);
        out.print((new org.json.JSONObject(rstMap)).toString());

    } else if("selectEtcBouns".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectEtcBouns(mp, queryMap);
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

    } else if("saveEtcBouns".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        String message = "";
        String code = "1";

        try {
            int cnt = saveEtcBouns(mp, queryMap);

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

    } else if("getPayCdList".equals(cmd)) {
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);

        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = getPayCdList(mp, queryMap);
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

        out.print((new org.json.JSONObject(rstMap)).toString());

    } else if("updateEtcBouns".equals(cmd)) {
        //인정상여설정
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        List listData  = new ArrayList();
        String message = "";
        String code = "1";

        try {
            int cnt = updateEtcBouns(mp, queryMap);

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
        rstMap.put("Data", (List)listData);
        out.print((new org.json.JSONObject(rstMap)).toString());

    } else if("getPayCdChkCnt".equals(cmd)) {
        //작업선택건수 조회

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = getPayCdChkCnt(mp, queryMap);
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
        out.print((new org.json.JSONObject(rstMap)).toString());

    }
    else if("P_CPN_SMPPYM_EMP_2022".equals(cmd)) {
        //근로소득 금액생성
        Map paramMap = StringUtil.getRequestMap(request);

        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", ssnSabun);

        Map mp =  StringUtil.getParamMapData(paramMap);

        String halfType   = (String)mp.get("halfType");
        String sendType   = (String)mp.get("sendType");
        String incomeType = (String)mp.get("incomeType");
        String workYy     = (String)mp.get("workYy");
        String creWorkYy  = (String)mp.get("creWorkYy");
        String sabun      = (String)mp.get("sabun");
        String delYn      = (String)mp.get("delYn");
        String calcType   = (String)mp.get("calcType");
        String businessPlace = (String)mp.get("businessPlace");

        String[] type =  new String[]{"OUT","OUT","OUT"
                ,"STR","STR","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
        String[] param = new String[]{"","",""
                ,ssnEnterCd,sendType,halfType,incomeType,workYy,creWorkYy,sabun,businessPlace,delYn,calcType,ssnSabun};

        String message = "";
        String code = "1";
        int cnt = 0;

        try {

            String[] rstStr = DBConn.executeProcedure("P_CPN_SMPPYM_EMP_2022",type,param);

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
    else if("P_CPN_SMPPYM_EMP_2024".equals(cmd)) {
        //근로소득 금액생성
        Map paramMap = StringUtil.getRequestMap(request);

        paramMap.put("ssnEnterCd", ssnEnterCd);
        paramMap.put("ssnSabun", ssnSabun);

        Map mp =  StringUtil.getParamMapData(paramMap);

        String halfType   = (String)mp.get("halfType");
        String sendType   = (String)mp.get("sendType");
        String incomeType = (String)mp.get("incomeType");
        String workYy     = (String)mp.get("workYy");
        String workMm     = (String)mp.get("workMm");
        String creWorkYy  = (String)mp.get("creWorkYy");
        String sabun      = (String)mp.get("sabun");
        String delYn      = (String)mp.get("delYn");
        String calcType   = (String)mp.get("calcType");
        String businessPlace = (String)mp.get("businessPlace");

        String[] type =  new String[]{"OUT","OUT","OUT"
                ,"STR","STR","STR","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
        String[] param = new String[]{"","",""
                ,ssnEnterCd,sendType,halfType,incomeType,workYy,workMm,creWorkYy,sabun,businessPlace,delYn,calcType,ssnSabun};

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