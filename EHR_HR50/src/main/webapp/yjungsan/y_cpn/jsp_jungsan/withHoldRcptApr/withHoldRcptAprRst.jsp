<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>
 
<%@ page import="org.json.*" %>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!
//private Logger log = Logger.getLogger(this.getClass());

//public Map queryMap = null;

//xml 파서를 이용한 방법;
public Map setQueryMap(String path) {
	return XmlQueryParser.getQueryMap(path);
}

//원천징수부 대상자 조회
public List selectWithHoldRcptAprList(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectWithHoldRcptAprList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}
	
	return listData;
}

//원천징수영수증/징수부 신청 저장
public int saveWithHoldRcptApr(Map paramMap, Map queryMap) throws Exception {

	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;

	if(conn != null && list != null && list.size() > 0) {

		//사용자가 직접 트랜젝션 관리
		conn.setAutoCommit(false);
		
		String ssnEnterCd = (String)paramMap.get("ssnEnterCd");
		String ssnSabun = (String)paramMap.get("ssnSabun");

		try{

			// 0. 급여계산코드 생성 ( 원천징수부 : PAY_CD = Y9 )
			for(int i = 0; i < list.size(); i++ ) {
				Map mp = (Map)list.get(i);
				mp.put("ssnEnterCd", ssnEnterCd);
				mp.put("ssnSabun", ssnSabun);
				
				String sStatus = (String)mp.get("sStatus");
				
				if("I".equals(sStatus)) {
					String workYy = mp.get("work_yy").toString();
					String print_type = mp.get("print_type").toString();
					
					// 원천징수부일 경우에만 Y9에 해당하는 급여계산코드 생성
					if( "2".equals(print_type) ){
						
						// 급여계산코드확인
						mp.put("searchPayCd", "Y9");
						Map rstMap1 = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectPayActionCd", mp);
						
						// 존재하지않을 경우 생성
						if(!(rstMap1 != null && rstMap1.size() > 0)){
							String payActionNm = workYy + ".12.31 " + "정산데이터" ;
							mp.put("pay_action_nm", payActionNm);
							DBConn.executeUpdate(conn, queryMap, "insertPayActionCd", mp);
							
							//커밋
							conn.commit();
						}
					}
				}
			}
			
			for(int i = 0; i < list.size(); i++ ) {
				//String query = "";
				Map mp = (Map)list.get(i);
				mp.put("ssnEnterCd", ssnEnterCd);
				mp.put("ssnSabun", ssnSabun);
				
				String sStatus = (String)mp.get("sStatus");

				if("D".equals(sStatus)) {
					//삭제
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteWithHoldRcptApr", mp);
				} else if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateWithHoldRcptApr", mp);
				} else if("I".equals(sStatus)) {
					//입력
					
					Map rstMap1 = null;
					Map rstMap2 = null;
					Map rstMap3 = null;
					Map rstMap4 = null;
					Map chkMap = new HashMap();
					
					String workYy = mp.get("work_yy").toString();
					String sabun = mp.get("sabun").toString();
					String print_type = mp.get("print_type").toString();
					String taxType = "2"; 		/* 2: 자동세액계산 (C00450) */
					
					String adjustType = "";
					String searchPayCd = "";
					
					// 원천징수부일 경우 adjustType : 9
					if( "2".equals(print_type) ){
						adjustType = "9";	/* 9: 정산데이터 */
						searchPayCd = "Y9";
						
						chkMap.put("work_yy", workYy);
						chkMap.put("sabun", sabun);
						chkMap.put("adjust_type", "1");
						chkMap.put("ssnEnterCd", ssnEnterCd);
						chkMap.put("ssnSabun", ssnSabun);
					
					// 원천징수영수증일 경우 입력받은 adjust_type
					}else if( "1".equals(print_type) ){
						adjustType = mp.get("adjust_type").toString();
						
						if("1".equals(adjustType) || "3".equals(adjustType)){
							searchPayCd = "Y" + adjustType;
						}else{
							throw new UserException("정산구분을 확인해주세요.");
						}
						
					}else{
						throw new UserException("출력구분을 확인해주세요.");
					}
					
					mp.put("adjust_type", adjustType);
					mp.put("searchPayCd", searchPayCd);
					
					//1 .급여계산코드확인
					rstMap1 = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectPayActionCd",mp);
					
					if(rstMap1 != null && rstMap1.size() > 0){
						
						String payActionCd = rstMap1.get("pay_action_cd").toString();
						mp.put("pay_action_cd", payActionCd);

						// 2.기 등록 대상자 확인
						rstMap2 = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYearCalcCrePeopleCnt",mp);
						if(rstMap2 != null && rstMap2.get("cnt").equals("0")){
							
							String[] type =  new String[]{"OUT","OUT","OUT","STR","STR","STR","STR","STR","STR","STR","STR","STR"};
							String[] param = new String[]{"","","",ssnEnterCd,payActionCd,workYy,adjustType,"","0",sabun,taxType,ssnSabun};
							
							String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_EMP",type,param);
							
							// rstStr 값 판단하여 프로시저 성공시에만 동작
							if(rstStr[1] == null || rstStr[1].length() == 0) {
								// 3. INSERT TCPN981
								DBConn.executeUpdate(conn, queryMap, "deleteWithHoldRcptAprTCPN981", mp );
								DBConn.executeUpdate(conn, queryMap, "insertWithHoldRcptAprTCPN981", mp );
							}else{
								throw new UserException("대상자 생성 처리도중 : "+rstStr[1]);
							}
						}
						
						// 연급여생성
						String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR","STR"};
						String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,"",sabun,ssnSabun};
						
						
						if("2".equals(print_type)){
							//원천징수 부 일경우
							rstMap3 = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectAdjustTypeCnt",chkMap);
							//연말정산 데이터 존재 유무 검사
							
							if(rstMap3 != null && !rstMap3.get("cnt").equals("0")){
								
								//'9'(정산데이터)로 존재시 삭제
								rstMap4 = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectAdjustTypeCnt",mp);
								
								if(rstMap4 != null && !rstMap4.get("cnt").equals("0")){
									rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteAdjustdata", mp);
									rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYearResultData", mp);	
								}
								
								//내역이 존재하면 데이터에 adjusttype = '9'(정산데이터) 로 입력하여 복사
								rstCnt += DBConn.executeUpdate(conn, queryMap, "insertMonpayCopy", chkMap);
								rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYeaResultDataCopy", chkMap);
								rstCnt += DBConn.executeUpdate(conn, queryMap, "insertWithHoldRcptApp", mp);
								
							}else{
								
								String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_MONPAY_"+workYy,type,param);
								
								// rstStr 값 판단하여 프로시저 성공시에만 동작
								if(rstStr[1] == null || rstStr[1].length() == 0) {
									// 원천징수영수증/징수부 신청 정보 저장
									rstCnt += DBConn.executeUpdate(conn, queryMap, "insertWithHoldRcptApr", mp);
								}else{
									throw new UserException("연급여 생성 처리도중 : "+rstStr[1]);
								}
							
							}
						}else{
								/* String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_MONPAY_"+workYy,type,param);
								
								// rstStr 값 판단하여 프로시저 성공시에만 동작
								if(rstStr[1] == null || rstStr[1].length() == 0) { */
									// 원천징수영수증/징수부 신청 정보 저장
								rstCnt += DBConn.executeUpdate(conn, queryMap, "insertWithHoldRcptApr", mp);
								/* }else{
									throw new UserException("연급여 생성 처리도중 : "+rstStr[1]);
								} */
							
						}
						
						/**************************이전로직 백업 *************************************************************/
						/* String[] rstStr = DBConn.executeProcedure("P_CPN_YEAREND_MONPAY_"+workYy,type,param);
						
						// rstStr 값 판단하여 프로시저 성공시에만 동작
						if(rstStr[1] == null || rstStr[1].length() == 0) {
							// 원천징수영수증/징수부 신청 정보 저장
							rstCnt += DBConn.executeUpdate(conn, queryMap, "insertWithHoldRcptApr", mp);
						}else{
							throw new UserException("연급여 생성 처리도중 : "+rstStr[1]);
						} */
						/************************************************************************************************/
					}else{
						throw new UserException("해당년도 연말정산일자가 등록되지 않았습니다.");
					}
				}
			}

			//커밋
			conn.commit();
		} catch(UserException e) {
			try {
				//롤백
				if (conn != null) conn.rollback();
			} catch (Exception e1) {
				Log.Error("[rollback Exception] " + e);
			}
			rstCnt = 0;
			Log.Error("[Exception] " + e);
			throw new Exception(e.getMessage());
		} catch(Exception e) {
			try {
				//롤백
				if (conn != null) conn.rollback();
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
//이관업로드 대상자 카운트
public Map selectMigExistAprCnt(Map paramMap, Map queryMap) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	String queryId = (String)pm.get("queryId");
	Map mp = null;

	pm.put("sabuns", pm.get("sabuns"));
	try{
		//쿼리 실행및 결과 받기.
		mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap, queryId, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	}

	return mp;
}
%>

<%
	//쿼리 맵 셋팅
	Map queryMap = setQueryMap(xmlPath+"/withHoldRcptApr/withHoldRcptApr.xml");

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectWithHoldRcptAprList".equals(cmd)) {
		//원천징수부승인 대상자 조회
		
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectWithHoldRcptAprList(mp, queryMap);
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
		
	} else if("saveWithHoldRcptApr".equals(cmd)) {
		//원천징수영수증/징수부 신청 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		String message = "";
		String code = "1";

		try {
			int cnt = saveWithHoldRcptApr(mp, queryMap);

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

	} else if("selectMigExistAprCnt".equals(cmd)) {
		//이관업로드 대상자 카운트
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectMigExistAprCnt(mp, queryMap);
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
%>