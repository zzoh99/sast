<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//연말정산 대상자 조회
public List selectYeaCalcCrePopupList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	String searchBusinessCd	 = String.valueOf(pm.get("searchBizPlaceCd"));
	String searchNameSabun	 = String.valueOf(pm.get("findName"));

	StringBuffer query    = new StringBuffer();
	StringBuffer query2   = new StringBuffer();

	query.setLength(0);
	query2.setLength(0);

	if(searchBusinessCd.trim().length() > 0){
		query.append(" AND BUSINESS_PLACE_CD = #searchBizPlaceCd#");
		query2.append(" AND A.BUSINESS_PLACE_CD = #searchBizPlaceCd#");
	}

	if(searchNameSabun.trim().length() > 0 ){
		query2.append(" AND ( LOWER(A.SABUN) LIKE LOWER('%" +searchNameSabun+"%') OR LOWER(B.NAME) LIKE LOWER('%" +searchNameSabun+"%') )");
	}

	pm.put("query", query.toString());
	pm.put("query2", query2.toString());

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaCalcCrePopupList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//연말정산 대상자 저장.
public String[] saveYeaCalcCrePopup(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

    List listMap = StringUtil.getParamListData(paramMap);

    // IBsheet 트랜잭션 처리 리턴값.
    String[] rstStr    = new String[]{"1","","", "","",""}; // 리턴값. [0]=CODE(양수는 정상, 음수는 처리중오류), [1]=MESSAGE, [2]=RESULT(행별 트랜잭션 결과. 행단위는 |로 구분. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)
    
    int    IBS_code    = 1 ;  // [0]=CODE(양수는 정상, 음수는 처리중오류)
    String IBS_Message = "";  // [1]=MESSAGE (상황별 메시지)
    String IBS_msg2    = "";  //     MESSAGE (Row_code가 -2일 경우 대상자사번) // sabun(pay_action_nm),sabun(pay_action_nm) (중복) .. 대상자 중복
    String IBS_msg3    = "";  //     MESSAGE (Row_code가 -3일 경우 대상자사번) // sabun,sabun (미처리) .. TCPN201.PAY_ACITON_CD) 소실. 삭제기능만 있는 팝업 호출 필요.
    String IBS_result  = "";  // [2]=RESULT (행별 트랜잭션 결과. 행단위는 |로 구분. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)
    
    
    int Row_code       = 1 ;  // CODE(양수는 정상, 음수는 처리중오류)
    String Row_result  = "";  // RESULT(행별 트랜잭션 결과. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)

    String sStatus     = "";

	if(listMap != null && listMap.size() > 0 && conn != null) {

		conn.setAutoCommit(false);

		try{
            Map mp2 = (Map)listMap.get(0);
            String menuNm = (String)mp2.get("menuNm");
            
			for(int i = 0; i < listMap.size(); i++ ) {

                Map mp = (Map)listMap.get(i);                
                mp.put("menuNm", menuNm);
                
                sStatus = (String)mp.get("sStatus");

                Row_code    = 1 ;  // CODE(양수는 정상, 음수는 처리중오류)
                Row_result  = "";  // RESULT(행별 트랜잭션 결과. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)
                
                if("I".equals(sStatus)) {
                    String[] rstStrIns = new String[]{"1","",""}; // 리턴값(입력 처리 결과. 임시)
                    
                	//입력
                    Map mpData = new HashMap();
                    mpData.put("ssnEnterCd",        (String)mp.get("ssnEnterCd"));
                    mpData.put("ssnSabun",          (String)mp.get("ssnSabun"));
                    mpData.put("searchPayActionCd", (String)mp.get("pay_action_cd"));
                    mpData.put("searchWorkYy",      (String)mp.get("work_yy"));
                    mpData.put("searchAdjustType",  (String)mp.get("adjust_type"));                         
                    mpData.put("searchBizPlaceCd",  "");
                    mpData.put("searchSabun",       (String)mp.get("sabun"));
                    mpData.put("taxType",           "2");

                    rstStrIns = prcYearendEmp(mpData, locPath) ;
                    
                    if ( rstStrIns == null ) {
                    	throw new Exception("저장에 실패하였습니다.");
                    }
                    
                    String tmpStr = "";
                    
                    tmpStr   = String.valueOf(rstStrIns[0]) ;
                    Row_code = ("".equals(tmpStr)) ? 0 : Integer.valueOf(tmpStr) ;
                    //-2(사번중복) / -3(pay_action_cd소실)의 코드가 리턴되기도 함.
                    if (IBS_code < 0 || Row_code < 0) 
                    {
                        if (IBS_code > Row_code) 
                        {
                            //반복 회차 중 오류가 발생하였다면, 우선도가 더 높은 오류 코드를 최종 리턴
                            IBS_code = Row_code ;
                        }
                    }
                    
                    if (Row_code > -2) {
                        // [0] P_SQLCODE, [1] P_SQLERRM, [2] P_CNT
                        IBS_Message = rstStrIns[1]; // P_SQLERRM
                        
                        tmpStr   = String.valueOf(rstStrIns[2]) ;
                        rstCnt   = rstCnt + ( ("".equals(tmpStr)) ? 0 : Integer.valueOf(tmpStr) ) ; // P_CNT. 프로시저에서 대상자가 일괄 생성되는 경우가 있어서 리턴된 건수를 합산.
                    } else {
                        // [0] CODE, [1] RESULT(행별 트랜잭션 결과. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류), [2] 중복자사번, [3] tcpn201소실사번
                        Row_result = rstStrIns[1] ;
                           
                        if ( Row_code == -3 ) {
                            // 신규입력 유효성 검증값 체크) TCPN811 에만 등록된 중복 데이터 ==> /yeaCalcCrePeoplePopup.jsp에서 콜백처리 시, 삭제할 수 있는 팝업 오픈.
                            if ( "".equals(IBS_msg3) ) {
                                IBS_msg3 = rstStrIns[3];
                            }  else {
                                IBS_msg3 = IBS_msg3 + "," + rstStrIns[3];
                            }
                        } else if ( Row_code == -2 ) {
                            // 신규입력 유효성 검증값 체크) 중복 데이터
                            if ( "".equals(IBS_msg2) ) {
                                IBS_msg2 = rstStrIns[2];
                            }  else {
                                IBS_msg2 = IBS_msg2 + "," + rstStrIns[2];
                            }
                        } 
                    }    
                } else if ("U".equals(sStatus) || "D".equals(sStatus)) {
                	 if("U".equals(sStatus)) {
                		 //수정
                         DBConn.executeUpdate(conn, queryMap, "updateYeaCalcCrePopup", mp);                    
                         DBConn.executeUpdate(conn, queryMap, "updateYeaCalcCrePopupAdjYmd", mp); // 2018-08-08  연말정산계산결과 귀속시작일, 귀속종료일 수정
                     } else if("D".equals(sStatus)) {
						//삭제
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN811", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN823", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN841", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN843", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN813", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN815", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN817", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN818", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN851", mp);
						DBConn.executeUpdate(conn, queryMap, "deleteYeaCalcCrePopupTCPN855", mp);
					}
                    rstCnt++; // 처리건수
					saveLog(conn, mp, ssnYeaLogYn);
				}
                
                // RESULT(행별 트랜잭션 결과. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)
                if ( i > 0 ) { 
                	IBS_result = IBS_result + "|" + Row_result ;
                }  else {
                	IBS_result = Row_result ;
                }
                
			} // end of for loop

			if ( rstCnt > 0 ) {
	            DBConn.executeUpdate(conn, queryMap, "deleteFinalCloseTCPN981", mp2);
	            DBConn.executeUpdate(conn, queryMap, "insertFinalCloseTCPN981", mp2);
			}

			//커밋
			conn.commit();

		    rstStr[0] = String.valueOf(IBS_code) ;
		    rstStr[1] = IBS_Message ; // MESSAGE
		    rstStr[2] = IBS_result ;  // RESULT (행별 트랜잭션 결과. 행단위는 |로 구분. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)

		    rstStr[3] = IBS_msg2 ; // 추가 MESSAGE (오류코드 -2에 대한 메시지)
		    rstStr[4] = IBS_msg3 ; // 추가 MESSAGE (오류코드 -3에 대한 메시지)
            rstStr[5] = String.valueOf(rstCnt) ; // 처리건수

		} catch(UserException e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstStr = null;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
            rstStr = null;
			Log.Error("[Exception] " + e);
			throw new Exception("저장에 실패하였습니다.");
		} finally {
			DBConn.closeConnection(conn, null, null);
	        queryMap = null;
		}
	}
    
	return rstStr;
}

//TCPN811 생성용 P_CPN_YEAREND_EMP 실행
public String[] prcYearendEmp(Map mpData, String locPath) throws Exception {

    //xml 파서를 이용한 방법;
    Map queryMap = XmlQueryParser.getQueryMap(locPath);

    String ssnEnterCd  = (String)mpData.get("ssnEnterCd");
    String ssnSabun    = (String)mpData.get("ssnSabun");  
    String payActionCd = (String)mpData.get("searchPayActionCd");
    String workYy      = (String)mpData.get("searchWorkYy");
    String adjustType  = (String)mpData.get("searchAdjustType");
    String bpCd        = (String)mpData.get("searchBizPlaceCd");
    String sabun       = (String)mpData.get("searchSabun");
    String taxType     = (String)mpData.get("taxType");

    if (ssnEnterCd  == null || "".equals(ssnEnterCd))  { return new String[]{"-1","회사코드(ssnEnterCd) 파라미터 누락", ""} ; }
    if (ssnSabun    == null || "".equals(ssnSabun))    { return new String[]{"-1","작업자사번(ssnSabun) 파라미터 누락",   ""} ; }
    if (payActionCd == null || "".equals(payActionCd)) { return new String[]{"-1","정산코드(payActionCd) 파라미터 누락",""} ; }
    if (workYy      == null || "".equals(workYy))      { return new String[]{"-1","귀속년도(workYy) 파라미터 누락",     ""} ; }
    if (adjustType  == null || "".equals(adjustType))  { return new String[]{"-1","정산구분(adjustType) 파라미터 누락", ""} ; }
  //if (sabun       == null || "".equals(sabun))       { return new String[]{"-1","대상자사번(sabun) 파라미터 누락",      ""} ; } //대상자생성 프로시저일 경우, 사번 파라미터 없음.
    if (taxType     == null || "".equals(taxType))     { return new String[]{"-1","작업구분(taxType) 파라미터 누락",    ""} ; }
    
    //대상자일괄이 아닌, 사번 파라미터가 지정되어 insert 되는 경우는 유효성 체크
    if ( sabun != null && !"".equals(sabun) ) {
        Log.Debug("[prcYearendEmp] checkYeaCalcCrePopup 로직 이관) 사번체크");

        String[] chkStr = new String[]{"1","","",""};
        		
        Map retMap = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaCalcCrePopupChkSabun",mpData);
        if(retMap != null) {
            if (retMap.get("cnt") != null && Integer.valueOf(retMap.get("cnt").toString()) > 0) {
                if (retMap.get("pay_action_nm") == null || "".equals(String.valueOf(retMap.get("pay_action_nm")))) {
                    //TCPN811 에만 등록된 중복 데이터 ==> /yeaCalcCrePeoplePopup.jsp에서 콜백처리 시, 삭제할 수 있는 팝업 오픈. 
                    chkStr[0] = "-3"; 
                    chkStr[1] = "MISS"; // RESULT (미처리)
                    chkStr[2] = "";
                    chkStr[3] = sabun ;  //PK(TCPN201.PAY_ACITON_CD) 소실. 삭제기능만 있는 팝업 호출 필요. (미처리)
                } else {
                    //중복 데이터
                    chkStr[0] = "-2"; // code
                    chkStr[1] = "DUP"; // RESULT (중복)
                    chkStr[2] = sabun + "(" + retMap.get("pay_action_nm") + ")" ; // retMap.get("pay_action_nm").toString()+"에 사번("+sabun+")이 이미 있습니다. 확인해 주십시요. (중복)"; // message
                    chkStr[3] = "";
                }
                return chkStr ;
            }
        }
    }
    
    String[] type   = new String[]{"OUT","OUT","OUT","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
    String[] param  = new String[]{"","","",ssnEnterCd,payActionCd,workYy,adjustType,bpCd,"0",sabun,taxType,ssnSabun};
    String[] rstStr = new String[]{"1","",""}; // 리턴값. [0]=CODE(양수는 정상, 음수는 처리중오류), [1]=MESSAGE, [2]=RESULT(행별 트랜잭션 결과. 행단위는 |로 구분. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)
    
	try {
		rstStr = DBConn.executeProcedure("P_CPN_YEAREND_EMP",type,param);      
	} catch(Exception e) {
	   Log.Error("[Exception] " + e);
	   throw new Exception("조회에 실패하였습니다.");
	}
	
    // P_SQLCODE, P_SQLERRM, P_CNT
	return rstStr;
}
%>

<%
	String locPath = xmlPath+"/yeaCalcCre/yeaCalcCrePeoplePopup.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaCalcCrePopupList".equals(cmd)) {
		//연말정산 대상자 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);

		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaCalcCrePopupList(mp, locPath, ssnYeaLogYn);
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
	} else if("saveYeaCalcCrePopup".equals(cmd)) {
		//연말정산 대상자 저장
		//20250423. 본 로직은 공통이므로 수정 시 다음 소스를 모두 고려해야 합니다. yeaCalcCrePeoplePopup.jsp / yeaCalcCreDeletePopup.jsp
		
		Map paramMap = StringUtil.getRequestMap(request);

		// IBsheet 트랜잭션 처리 리턴값.
        String IBS_code    = "1"; // [0]=CODE(양수는 정상, 음수는 처리중오류)
		String IBS_message = "";  // [1]=MESSAGE
		String IBS_result  = "";  // [2]=RESULT(행별 트랜잭션 결과. 행단위는 |로 구분. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)
		
        String IBS_msg_2   = "";  // [3]=추가 MESSAGE (오류코드 -2에 대한 메시지)
        String IBS_msg_3   = "";  // [4]=추가 MESSAGE (오류코드 -2에 대한 메시지)
        String IBS_rst_Cnt = "";  // [5]=처리건수

		try {
			String[] rstStr = saveYeaCalcCrePopup(paramMap, locPath, ssnYeaLogYn);
			  
			if(rstStr != null) {
		        IBS_code    = rstStr[0];  // [0]=CODE(양수는 정상, 음수는 처리중오류)
		        IBS_message = rstStr[1];  // [1]=MESSAGE
		        IBS_result  = rstStr[2];  // [2]=RESULT(행별 트랜잭션 결과. 행단위는 |로 구분. OK=완료 / DUP=중복 / MISS=미처리 / NO=저장오류)

		        IBS_msg_2   = rstStr[3];  // [3]=추가 MESSAGE (오류코드 -2에 대한 메시지)
		        IBS_msg_3   = rstStr[4];  // [4]=추가 MESSAGE (오류코드 -3에 대한 메시지)
		        IBS_rst_Cnt = rstStr[5];  // [5]=처리건수
			} else {
				IBS_code = "-1";
				IBS_message = "저장된 내용이 없습니다.";
			}
		} catch(Exception e) {
			IBS_code = "-1";
			IBS_message = e.getMessage();
		}

        // IBsheet 트랜잭션 처리 리턴값.
		Map mapCode = new HashMap();
		mapCode.put("Code",    IBS_code);
		mapCode.put("Message", IBS_message);
        mapCode.put("Result",  IBS_result);        
        mapCode.put("Msg2",    IBS_msg_2);   // 추가 MESSAGE (오류코드 -2에 대한 메시지)
        mapCode.put("Msg3",    IBS_msg_3);   // 추가 MESSAGE (오류코드 -3에 대한 메시지)
        mapCode.put("RstCnt",  IBS_rst_Cnt); // 처리건수
        
		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("prcCpnYearEndEmp".equals(cmd)) {
		//연말정산 대상자 작업
		
		Map paramMap = StringUtil.getRequestMap(request);
		Map mpData =  StringUtil.getParamMapData(paramMap);

		String message = "";
		String code = "1";
		int cnt = 0;

		try {
	        mpData.put("ssnEnterCd", ssnEnterCd);
	        mpData.put("ssnSabun", ssnSabun);
	        mpData.put("searchSabun", ""); //20250418. 일괄생성일 때는 사번 파라미터 전달 없음.
	        mpData.put("taxType", "2");
	        
            String[] rstStr = prcYearendEmp(mpData, locPath) ;

            // [0] P_SQLCODE, [1] P_SQLERRM, [2] P_CNT
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