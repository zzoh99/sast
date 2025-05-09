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
//관리자 신용카드 자료 조회
public List selectYeaDataCardsList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataCardsList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//추가공제율 조회
public List selectYeaDataAddCardsList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataAddCardsList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}
//관리자 신용카드 자료 조회
public List selectYeaDataCardsInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataCardsInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//전년도 정보 조회
public Map selectPreYeaDataInfo_2014(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;
	
	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectPreYeaDataInfo_2014",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return mp;
}

//전년도 정보 조회
public Map selectPreYeaDataInfo_2013(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;
	
	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectPreYeaDataInfo_2013",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return mp;
}

//본인 정보 조회
public Map selectOwnDataInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map mp = null;
	
	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap == null) ? null : DBConn.executeQueryMap(queryMap,"selectOwnDataInfo",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return mp;
}

//공통코드(반기구분)
public List selectYeaDataCardsHalfGubun(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataCardsHalfGubun",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//공통코드(신용카드구분)
public List selectYeaDataCardCardType(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataCardCardType",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//pdf 파일 상세 저장.
public int saveYeaDataPdf(Map paramMap, String orgAuthPg, String locPath) throws Exception {

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	
	//권한에 따른 반영제외자 체크 ( 10(본인반영제외) / 20(담당자반영제외))
	String exceptCheck = "";
	if( "A".equals(orgAuthPg) ) {
		exceptCheck = "20";
	} else {
		exceptCheck = "10";
	}		

	if (conn != null) {
		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		try{
			Map mp = paramMap ;
			mp.put("exceptCheck", exceptCheck);
			System.out.println( paramMap ) ;
			rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataPdf", paramMap);
	
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

//추가공제율사용분 저장
public int saveYeaDataAddCards(Map paramMap, String locPath) throws Exception {
	
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
			for(int i = 0; i < list.size(); i++ ) {
				String query = "";
				Map mp = (Map)list.get(i);
				String sStatus = (String)mp.get("sStatus");
				
				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaDataAddCards", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateDeleteYeaDataAddCards", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertDeleteYeaDataAddCards", mp);
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

//카드 사용 합계 금액 조회 
public List selectYeaDataCard(Map paramMap, String locPath) throws Exception {

  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
  List listData = null;
  
  try{
      //쿼리 실행및 결과 받기.
      listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataCard",pm);
  } catch (Exception e) {
      Log.Error("[Exception] " + e);
      throw new Exception("조회에 실패하였습니다.");
  }
  
  return listData;
}
%>

<%
	String locPath = xmlPath+"/yeaData/yeaDataCards.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataCardsList".equals(cmd)) {
		//관리자 신용카드 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaDataCardsList(mp, locPath);
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
		
	} else if("selectYeaDataAddCardsList".equals(cmd)) {
		//관리자 신용카드 자료 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaDataAddCardsList(mp, locPath);
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
		
	} else if("selectYeaDataCardsInfo".equals(cmd)) {
			//관리자 신용카드 자료 조회
			
			Map mp = StringUtil.getRequestMap(request);
			mp.put("ssnEnterCd", ssnEnterCd);
			mp.put("ssnSabun", ssnSabun);
			
			List listData  = new ArrayList();
			String message = "";
			String code = "1";
		
			try {
				listData = selectYeaDataCardsInfo(mp, locPath);
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
			
	} else if("selectPreYeaDataInfo_2014".equals(cmd)) {
		//전년도 정보 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
	
		try {
			mapData = selectPreYeaDataInfo_2014(mp, locPath);
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
		
	} else if("selectPreYeaDataInfo_2013".equals(cmd)) {
		//전년도 정보 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
	
		try {
			mapData = selectPreYeaDataInfo_2013(mp, locPath);
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
		
	} else if("selectOwnDataInfo".equals(cmd)) {
		//본인 정보 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";
	
		try {
			mapData = selectOwnDataInfo(mp, locPath);
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

	} else if("selectYeaDataCardsHalfGubun".equals(cmd)) {
		//공통코드(반기구분)
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaDataCardsHalfGubun(mp, locPath);
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
		
	} else if("selectYeaDataCardCardType".equals(cmd)) {
		//공통코드(신용카드구분)
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectYeaDataCardCardType(mp, locPath);
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
		
	} else if("saveYeaDataCards".equals(cmd)) {
		//신용카드 저장.
		
		Map paramMap = StringUtil.getRequestMap(request);
		List saveList = StringUtil.getParamListData(paramMap);
		
		String[] type = null ;
		String[] param = null ;
		String[] rstStr = null ;
		
		int cnt = 0;
		boolean pdfDelete = false ;
		
		String message = "";
		String code = "1";
		
		try {
			
			if(saveList != null && saveList.size() > 0) {
				for(int i = 0; i < saveList.size(); i++) {
					Map mp = (Map)saveList.get(i);
					String sStatus = (String)mp.get("sStatus");
					String workYy = (String)mp.get("work_yy");
					String adjustType = (String)mp.get("adjust_type");
					String sabun = (String)mp.get("sabun");
					String seq = (String)mp.get("seq");
					String famres = (String)mp.get("famres");
					String cardType = (String)mp.get("card_type");
					String applMon = (String)mp.get("appl_mon");
					String adjInputType = (String)mp.get("adj_input_type");
					String ntsYn = (String)mp.get("nts_yn");
					String feedbackType = (String)mp.get("feedback_type");
					String halfGubun = (String)mp.get("half_gubun");
					String docSeq = (String)mp.get("doc_seq");
					String docSeqDetail = (String)mp.get("doc_seq_detail");
					
					String cardEnterNm = (String) mp.get("card_enter_nm");

					//삭제 시 PDF업로드 데이터 미반영 처리 Logic add by JSG 20161208..
					if( "07".equals(adjInputType) && "D".equals(sStatus) ) {
						
						String orgAuthPg = (String)request.getParameter("orgAuthPg"); 
						mp.put("ssnEnterCd", ssnEnterCd);
						mp.put("ssnSabun", ssnSabun);
						int tempCnt = saveYeaDataPdf(mp, orgAuthPg);
						cnt += tempCnt ; 
						
						if(tempCnt > 0) pdfDelete = true ;
						
					} else {
						type =  new String[]{"OUT","OUT","STR","STR","STR"
								,"STR","STR","STR","STR","STR"
								,"STR","STR","STR","STR","STR"
								,"STR","STR","STR","STR"};
						param = new String[]{"","",sStatus,ssnEnterCd,workYy
								,adjustType,sabun,seq,famres,cardType
								,applMon,adjInputType,ntsYn,feedbackType,ssnSabun
								,halfGubun,cardEnterNm,docSeq,docSeqDetail};
						
						rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.CARDS_INS",type,param);
						
						if(rstStr[1] == null || rstStr[1].length() == 0) {
							cnt++;
						} else {
							message = message + "\n\n" + rstStr[1];
						}
					}
				}
				/*PDF 삭제 데이터가 존재하는 경우 작동*/
				if(pdfDelete) {
					//Map mp = StringUtil.getParamMapData(paramMap);
					Map pdfMp = StringUtil.getParamMapData(paramMap);

					String paramYear = (String)pdfMp.get("work_yy");
					String paramAdjustType = (String)pdfMp.get("adjust_type");
					String paramSabun = (String)pdfMp.get("sabun");
					String docSeq = (String)pdfMp.get("doc_seq");

					
					/////////////////////// DB저장 및 파일업로드가 완료되었다면 프로시저 호출 //////////////////////////
					type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
					param = new String[]{"","",ssnEnterCd,paramYear,paramAdjustType,paramSabun,ssnSabun,docSeq};

					rstStr = DBConn.executeProcedure("P_CPN_YEA_PDF_ERRCHK_"+paramYear,type,param);
					
					if(rstStr[0] != null && "1".equals(rstStr[0])) {
						message = rstStr[1];

						try {
							message = "" ;
						} catch(Exception e) {
							Log.Error("[Exception] " + e.getMessage());
						}
						
					} else {
						message = "프로시저 실행중 오류가 발생하였습니다.\\n"+rstStr[1];
					}
				}
			}
			
			if(cnt > 0) {
				message = cnt+"건이 처리되었습니다." + message;
			} else {
				code = "-1";
				message = "처리된 내용이 없습니다." + message;
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
		
	} else if("saveYeaDataAddCards".equals(cmd)) {
		//추가공제율사용분 저장
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		String message = "";
		String code = "1";
		
		try {
			int cnt = saveYeaDataAddCards(mp, locPath);
			
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
		
	} else if("selectYeaDataCard".equals(cmd)) {
		// 카드 사용 합계 금액 조회
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        
        List listData  = new ArrayList();
        String message = "";
        String code = "1";
    
        try {
            listData = selectYeaDataCard(mp, locPath);
        } catch(Exception e) {
            code = "-1";
            message = e.getMessage();
        }
        /*
        Log.Debug(listData.size());
        Log.Debug(listData.size());
        Log.Debug(listData.size());
        Log.Debug(listData.size());
        Log.Debug(listData.size());
        Log.Debug(listData.size());
        Log.Debug(listData.size());
        Log.Debug(listData.size());
        */
        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);
        
        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        rstMap.put("sumList", (List)listData);
        out.print((new org.json.JSONObject(rstMap)).toString());	
	}
%>
