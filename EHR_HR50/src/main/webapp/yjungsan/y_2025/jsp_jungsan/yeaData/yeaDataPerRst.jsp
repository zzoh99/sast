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
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//private Logger log = Logger.getLogger(this.getClass());

//인적공제 자료 조회
public List selectYeaDataPerList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataPerList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//과거인적공제 현황 자료 조회
public List selectPastYeaDataPerList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectPastYeaDataPerList",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//장애인등록증 현황 자료 조회
public List selectYeaDataHndcpRegInfoList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectYeaDataHndcpRegInfoList",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//장애인등록증 현황 자료 저장
public int saveYeaDataHndcpRegInfo(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
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
				String workYy = (String)mp.get("work_yy");
				String adjustType = (String)mp.get("adjust_type");
				String sabun = (String)mp.get("sabun");
				String famres = (String)mp.get("famres");
				String hndcpYn = (String)mp.get("hndcp_yn");
				String hndcpType = (String)mp.get("hndcp_type");

				if("I".equals(sStatus) || "U".equals(sStatus)) {
					//입력

					Map sp = new HashMap();
					sp.put("ssnEnterCd",mp.get("ssnEnterCd"));
					sp.put("ssnSabun",mp.get("ssnSabun"));
					sp.put("searchWorkYy",workYy);
					sp.put("searchAdjustType",adjustType);
					sp.put("searchSabun",sabun);
					sp.put("searchFamres",famres);

					Map sm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap, "selectYeaDataHndcpRegInfo", sp);

					if("Y".equals(hndcpYn)) {
						if(sm == null || sm.size() == 0) {
							rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYeaDataHndcpRegInfo", mp);
						} else {
							/*
							 * 기준년이 같고 장애구분이 같으면 skip
							 * 기준년이 같고 장애구분이 다르면 update
							 * 기준년이 다르고 장애구분이 같으면 skip
							 * 기준년이 다르고 장애구분이 다르면 insert
							*/
							if(!hndcpType.equals((String)sm.get("hndcp_type"))) {
								if(sm.containsKey("work_yy") && workYy.equals((String)sm.get("work_yy"))) {
									rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataHndcpRegInfo", mp);
								} else {
									rstCnt += DBConn.executeUpdate(conn, queryMap, "insertYeaDataHndcpRegInfo", mp);
								}
							}
						}
					} else {
						if(sm != null && sm.size() != 0) {
							//자동삭제도 추가 - 기준년도가 같은 경우에만 삭제하기로 함
							if(sm.containsKey("work_yy") && workYy.equals((String)sm.get("work_yy"))) {
								rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaDataHndcpRegDetail", mp);
							}
						}
					}
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
		    queryMap = null;
		}
	}

	return rstCnt;
}

//장애인등록증 현황 자료 저장
public int saveYeaDataHndcpRegDetail(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
	List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
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
				String workYy = (String)mp.get("work_yy");
				String adjustType = (String)mp.get("adjust_type");
				String sabun = (String)mp.get("sabun");
				String famres = (String)mp.get("famres");
				String hndcpYn = (String)mp.get("hndcp_yn");
				String hndcpType = (String)mp.get("hndcp_type");
                Map mp2 = (Map)list.get(0);
                String menuNm = (String)mp2.get("menuNm");
                mp.put("menuNm", menuNm);
				if("U".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataHndcpRegDetail", mp);
				} else if("D".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteYeaDataHndcpRegDetail", mp);
				} else {}
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
		    queryMap = null;
		}
	}

	return rstCnt;
}
public Map selectAuthChk(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map mp = null;

    try{
        //쿼리 실행및 결과 받기.
        mp  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectAuthChk",pm);
        saveLog(null, pm, ssnYeaLogYn);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    } finally {
		queryMap = null;
	}

    return mp;
}
// 인적공제 본인정보 조회
public List selectSelfInfo(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    List listData = null;
    
    try{
        //쿼리 실행및 결과 받기.
        listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectSelfInfo",pm);
        saveLog(null, pm, ssnYeaLogYn);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    } finally {
		queryMap = null;
	}
    
    return listData;
}
public int saveSelfInfo(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
    
    List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

    Connection conn = DBConn.getConnection();
    int rstCnt = 0;
    
    if(list != null && list.size() > 0 && conn != null) {
    
        conn.setAutoCommit(false);
        
        try{
            for(int i = 0; i < list.size(); i++ ) {
                String query = "";
                Map mp = (Map)list.get(i);
                String sStatus = (String)mp.get("sStatus");
                
                if("U".equals(sStatus)) {
                    //수정
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "saveSelfInfo", mp);
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
		    queryMap = null;
        }
    }
    
    return rstCnt;
}

// 자녀세액공제 해제 - 직계비속(자녀,입양자)
public int updateChildYn(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

    List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

    Connection conn = DBConn.getConnection();
    int rstCnt = 0;

	String[] type = null ;
	String[] param = null ;
	String[] rstStr = null ;

	String workYy = ""; // 귀속년도
	String adjustType = ""; // 정산구분
	// SYNC 패키지를 호출할 대상자를 저장할 Set
	// 대상자 및 작업 구분별 SYNC 패키지는 한 번만 호출되면 입력된 금액이 모두 반영되므로 Set으로 대상자 및 작업 구분 정리
	Set<String> sabunSet = new HashSet<String>();

	int cnt = 0;
	String message = "";

    if(list != null && list.size() > 0 && conn != null) {

        conn.setAutoCommit(false);

        try{
			workYy = (String)((Map)list.get(0)).get("searchWorkYy");
			adjustType = (String)((Map)list.get(0)).get("searchAdjustType");

            for(int i = 0; i < list.size(); i++ ) {
                String query = "";
                Map mp = (Map)list.get(i);
                String sStatus = (String)mp.get("sStatus");

                if("U".equals(sStatus)) {
                    //수정
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "updateChildYn", mp);

					// SYNC 패키지 실행 대상 사번 Set에 추가
					sabunSet.add((String)mp.get("sabun"));
                }
                saveLog(conn, mp, ssnYeaLogYn);
            }

            //커밋
            conn.commit();

			// 대상자별 SYNC 패키지 호출하여 데이터 보정
			for(String sabun: sabunSet) {
				/*
				 PKG_CPN_YEA_2024_SYNC.DATA_SYNC_JOB 파라미터

				 P_SQLCODE               OUT  VARCHAR2,  -- Error Code
		         P_SQLERRM               OUT  VARCHAR2,  -- Error Messages
		         P_GUBUN            	 IN  VARCHAR2, -- 작업구분(A:정산항목생성, F:인적공제,P:연금보험료,I:보험료,M:의료비,E:교육비,D:기부금,H:주택마련저축,C:신용카드등,MR:주택자금(임차차입금 및 월세액),B:비과세(출산지원금))
				 P_ENTER_CD         	 IN  VARCHAR2, -- 회사코드
				 P_PAY_ACTION_CD    	 IN  VARCHAR2,  -- 급여계산코드
				 P_WORK_YY          	 IN  VARCHAR2, -- 대상년도
				 P_ADJUST_TYPE      	 IN  VARCHAR2, -- 정산구분(C00303)
				 P_SABUN            	 IN  VARCHAR2, -- 사원번호
				 P_CHKID            	 IN  VARCHAR2  -- 수정자
				*/

				// 데이터 수정/입력 후 SYNC 호출하여 차감 금액 반영
				type =  new String[]{"OUT", "OUT", "STR", "STR", "STR", "STR", "STR", "STR", "STR"};

				param = new String[]{"", "", "F", (String)paramMap.get("ssnEnterCd"), "", workYy, adjustType, sabun, (String)paramMap.get("ssnSabun")};

				rstStr = DBConn.executeProcedure("PKG_CPN_YEA_" + workYy + "_SYNC.DATA_SYNC_JOB", type, param);

				if(rstStr[1] == null || rstStr[1].length() == 0) {
					cnt++;
				} else {
					message = message + "\n\n" + rstStr[1];
				}
			}
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
		    queryMap = null;
        }
    }

    return rstCnt;
}
%>

<%
	String locPath = xmlPath+"/yeaData/yeaDataPer.xml";
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataPerList".equals(cmd)) {
		//인적공제 자료 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataPerList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveYeaDataPer".equals(cmd)) {
		//인적공제 저장.

		Map paramMap = StringUtil.getRequestMap(request);
		List saveList = StringUtil.getParamListData(paramMap);

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR"
				,"STR","STR","STR","STR","STR"
				,"STR","STR","STR","STR","STR"
				,"STR","STR","STR","STR","STR","STR","STR"};

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			if(saveList != null && saveList.size() > 0) {
				for(int i = 0; i < saveList.size(); i++) {
					Map mp = (Map)saveList.get(i);
					String sStatus = (String)mp.get("sStatus");
					String workYy = (String)mp.get("work_yy");
					String adjustType = (String)mp.get("adjust_type");
					String sabun = (String)mp.get("sabun");
					String famres = (String)mp.get("famres");
					String famCd = (String)mp.get("fam_cd");
					String famNm = (String)mp.get("fam_nm");
					String dpndntYn = (String)mp.get("dpndnt_yn");
					String spouseYn = (String)mp.get("spouse_yn");
					String seniorYn = (String)mp.get("senior_yn");
					String hndcpYn = (String)mp.get("hndcp_yn");
					String hndcpType = (String)mp.get("hndcp_type");
					String womanYn = (String)mp.get("woman_yn");
					String oneParentYn = (String)mp.get("one_parent_yn");
					/* 20181101 6세이하 자녀양육 제거 및 관련 로직 제거 */
					//String child_yn = (String)mp.get("child_yn");
                    String adopt_born_yn = (String)mp.get("adopt_born_yn");
                    String child_order = (String)mp.get("child_order");
                    String add_child_yn = (String)mp.get("add_child_yn"); //2019-11-11. 자녀세액공제 추가
                    String exceed_income_yn = (String)mp.get("exceed_income_yn");
                    // String hndcpTypeNts = (String)mp.get("hndcp_type_nts");
                    //주민등록번호 공백 및 '-' 제거 - 2020.01.30
                    if(famres != null) {
                    	famres = famres.replace("-", "").trim();
                    }

					String[] param = new String[]{"","",sStatus,ssnEnterCd,workYy
							,adjustType,sabun,famres,famCd,famNm
							,child_order,dpndntYn,spouseYn,seniorYn,hndcpYn
							,hndcpType,womanYn,oneParentYn,/* child_yn, */add_child_yn,adopt_born_yn,exceed_income_yn,ssnSabun};

					String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_SYNC.FAMILY_INS",type,param);

					if(rstStr[1] == null || rstStr[1].length() == 0) {
						cnt++;
					} else {
						message = message + "\n\n" + rstStr[1];
					}


				}
			}

			if(cnt > 0) {

				try{
					//장애인등록증 처리
					paramMap.put("ssnEnterCd", ssnEnterCd);
					paramMap.put("ssnSabun", ssnSabun);
					saveYeaDataHndcpRegInfo(paramMap, locPath, ssnYeaLogYn);
				} catch(Exception e) {
					Log.Error("[yeaDataPerRst]:" + e.getMessage());
				}

				message = cnt+"건이 처리되었습니다." + message;
			} else {
				code = "-1";
				message = "처리된 내용이 없습니다." + message;
			}
		} catch(Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Log.Debug("ttttttttttt"+message);
		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString());

	} else if("saveYeaDataPerConfirm".equals(cmd)){

		String inputStatus = request.getParameter("input_status");

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("sabun", request.getParameter("sabun"));
        mp.put("adjust_type", request.getParameter("adjust_type"));
        mp.put("work_yy", request.getParameter("work_yy"));
        mp.put("input_status", inputStatus);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

		//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	    Connection conn = DBConn.getConnection();
	    int rstCnt = 0;

	    if (conn != null) {
		    try{
			    //사용자가 직접 트랜젝션 관리
		        conn.setAutoCommit(false);
	
		        rstCnt = DBConn.executeUpdate(conn, queryMap, "updateYeaDataPerConfirm", mp);
	
		        if(rstCnt > 0) {
	                message = "1".equals(inputStatus) ? "확정되었습니다." : "확정 취소 되었습니다.";
	            } else {
	                code = "-1";
	                message = "1".equals(inputStatus) ? "확정 된 내역이 없습니다." : "확정 취소 된 내역이 없습니다.";
	            }
	
		        //커밋
		        conn.commit();
		    } catch(Exception e) {
	            try {
	                //롤백
	                conn.rollback();
	            } catch (Exception e1) {
	                Log.Error("[rollback Exception] " + e);
	            }
	            rstCnt = 0;
	            Log.Error("[Exception] " + e);
	
	            Log.Error("[yeaDataPerRst]:" + e.getMessage());
	
	            code = "-1";
	            message = "2".equals(inputStatus) ? "확정에 실패하였습니다." : "확정 취소에 실패하였습니다.";
		    } finally {
	            DBConn.closeConnection(conn, null, null);
	        }
	    }

	    Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);

        out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("selectPastYeaDataPerList".equals(cmd)){

		//인적공제 자료 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectPastYeaDataPerList(mp, locPath);
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


	}  else if("selectYeaDataHndcpRegInfoList".equals(cmd)){

		//장애인등록증 현황 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectYeaDataHndcpRegInfoList(mp, locPath);
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


	} else if("saveYeaDataHndcpRegDetail".equals(cmd)) {
		//기부금 내역 저장

		Map paramMap = StringUtil.getRequestMap(request);
		paramMap.put("ssnEnterCd", ssnEnterCd);
		paramMap.put("ssnSabun", ssnSabun);
		paramMap.put("cmd", cmd);
		List listMap = StringUtil.getParamListData(paramMap);

		String message = "";
		String code = "1";
		int cnt = 0;

		try {

			cnt = saveYeaDataHndcpRegDetail(paramMap, locPath, ssnYeaLogYn);

			if(cnt > 0) {
				if(message.length() == 0) {
					message = "저장되었습니다.";
				}
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
	}else if("selectAuthChk".equals(cmd)) {


        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = selectAuthChk(mp, locPath, ssnYeaLogYn);
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

    } else if("selectSelfInfo".equals(cmd)) {
        //인적공제 자료 조회
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        List listData  = new ArrayList();
        String message = "";
        String code = "1";
    
        try {
            listData = selectSelfInfo(mp, locPath, ssnYeaLogYn);
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
        
    } else if("saveSelfInfo".equals(cmd)) {
        //연말정산 옵션 저장
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";
        
        try {
            int cnt = saveSelfInfo(mp, locPath, ssnYeaLogYn);
            
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
        
    } else if("updateChildYn".equals(cmd)) {
        //자녀세액공제 해제
        
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";
        
        try {
            int cnt = updateChildYn(mp, locPath, ssnYeaLogYn);
            
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