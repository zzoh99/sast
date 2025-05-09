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

//소득공제자료등록 마감 정보 조회
public Map selectYeaDataDefaultInfo(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	String searchAdjustType	= (String)pm.get("searchAdjustType");

	StringBuffer query = new StringBuffer();
	query.setLength(0);

    //년도
	if(searchAdjustType.trim().length() != 0 ){
		query.append(" AND ADJUST_TYPE = '"+searchAdjustType+"'");
	}
	pm.put("query", query.toString());

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectYeaDataDefaultInfo",pm);

	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return pm;
}

//특이사항 표시
public Map selectCheckClearYn(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectCheckClearYn",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return pm;
}

//특이사항 팝업 조회
public List selectUnusualPopupList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectUnusualPopupList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//특이사항 팝업 저장
public int saveUnusualPopup(Map paramMap, String locPath) throws Exception {
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

				if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateUnusualPopup", mp);
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertUnusualPopup", mp);
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
		    queryMap = null;
		}
	}

	return rstCnt;
}

//소득공제자료등록 팝업 자료 조회
public List selectRes3List(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRes3List",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//소득공제자료등록 팝업 자료 조회
public List selectRes2List871(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{

		String gubun = (String)pm.get("searchGubun");
		pm.put("searchTable","");
		//pm.put("searchAnd","");

		/* TCPN871(사용안함) - 주석 처리
		if("1".equals(gubun)) {
			pm.put("searchTable","TCPN871");
		} else */
		if("1".equals(gubun) || "2".equals(gubun)) {
			pm.put("searchTable","TCPN841");
		} else {
			pm.put("searchTable","TCPN841_BK");
			// dynamic query 보안 이슈 때문에 수정
// 			pm.put("searchAnd","AND ORI_PAY_ACTION_CD = '"+(String)pm.get("searchPayActionCd")+"'"
// 					+" AND RE_CALC_SEQ = '"+(String)pm.get("searchReCalcSeq")+"'" );
		}

		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRes2List871",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//소득공제자료등록 팝업 자료 조회
public List selectRes5List873(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{

		String gubun = (String)pm.get("searchGubun");
		pm.put("searchTable","");
		//pm.put("searchAnd","");

		/* TCPN873(사용안함) - 주석 처리
		if("1".equals(gubun)) {
			pm.put("searchTable","TCPN873");
		} else */
		if("1".equals(gubun) || "2".equals(gubun)) {
			pm.put("searchTable","TCPN843");
		} else {
			pm.put("searchTable","TCPN843_BK");
			// dynamic query 보안 이슈 때문에 수정
// 			pm.put("searchAnd","AND ORI_PAY_ACTION_CD = '"+(String)pm.get("searchPayActionCd")+"'"
// 					+" AND RE_CALC_SEQ = '"+(String)pm.get("searchReCalcSeq")+"'" );
		}

		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectRes5List873",pm);
// 		saveLog(null, pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//소득공제자료등록 기본자료 조회
public List selectCommonSheetList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectCommonSheetList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

//소득공제자료등록 기본자료 저장
public int saveCommonSheet(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
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
				String AdjElCd = (String)mp.get("adj_element_cd");
				if("U".equals(sStatus)) {
					//수정
					rstCnt += DBConn.executeUpdate(conn, queryMap, "updateCommonSheet", mp);
					/* 소득구분 T01, T02 외국인기술자 감면세액에 관한 로직 임시 주석 (2020-11-18)
					if(AdjElCd.equals("B010_15")){
						mp.put("adj_element_cd", "C010_79");
					}else if(AdjElCd.equals("B010_18")){
						mp.put("adj_element_cd", "C010_80");
					}
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteAdjElCdTCPN815", mp);
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertAdjElCdTCPN815", mp);
					*/
				} else if("I".equals(sStatus)) {
					//입력
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertCommonSheet", mp);
					/* 소득구분 T01, T02 외국인기술자 감면세액에 관한 로직 임시 주석 (2020-11-18)
					if(AdjElCd.equals("B010_15")){
						mp.put("adj_element_cd", "C010_79");
					}else if(AdjElCd.equals("B010_18")){
						mp.put("adj_element_cd", "C010_80");
					}
					rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteAdjElCdTCPN815", mp);
					rstCnt += DBConn.executeUpdate(conn, queryMap, "insertAdjElCdTCPN815", mp);
					*/
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


//Tab카운트 표시
public Map selectTabCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectTabCnt",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return pm;
}

//담당자피드백 표시
public Map selectFeedbackYn(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;

	try{
		//쿼리 실행및 결과 받기.
		pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectFeedbackYn",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return pm;
}

//기부금 상세내역
public List selectDonDetailList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception{

	Map pm = StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectDonDetailList", pm);
		saveLog(null, pm, ssnYeaLogYn);
	}catch(Exception e){
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}
//외국납부 상세내역
public List selectForeignPayDetailList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception{

	Map pm = StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectForeignPayDetailList", pm);
		saveLog(null, pm, ssnYeaLogYn);
	}catch(Exception e){
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}
public Map getPayTotal(Map paramMap, String locPath) throws Exception {

	  //파라메터 복사.
	  Map pm =  StringUtil.getParamMapData(paramMap);
	  //xml 파서를 이용한 방법;
	  Map queryMap = XmlQueryParser.getQueryMap(locPath);
	  Map map = null;

	  try{
	      //쿼리 실행및 결과 받기.
	      pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getPayTotal",pm);

	  } catch (Exception e) {
	      Log.Error("[Exception] " + e);
	      throw new Exception("조회에 실패하였습니다.");
	  } finally {
		queryMap = null;
	  }

	  return pm;
}
//감면기간 조회
public Map getReduceYmd(Map paramMap, String locPath) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map map = null;

    try{
        //쿼리 실행및 결과 받기.
        pm  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"getReduceYmd",pm);

    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    } finally {
		queryMap = null;
	}

    return pm;
}
//감면기간 저장
public int saveReduceYmd(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

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
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "saveReduceYmd", mp);
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
//출력탭(기부금명세서)
public Map selecPayPeopleStsCnt(Map paramMap, String locPath) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map map = null;

    try{
        //쿼리 실행및 결과 받기.
        map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selecPayPeopleStsCnt",pm);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    } finally {
        queryMap = null;
    }
    return map;
}

//소득공제서 전자서명 사용여부
public Map selectSignEnableYn(Map paramMap, String locPath) throws Exception {

  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
  //xml 파서를 이용한 방법;
  Map queryMap = XmlQueryParser.getQueryMap(locPath);
  Map map = null;

  try{
      //쿼리 실행및 결과 받기.
      map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectSignEnableYn",pm);
  } catch (Exception e) {
      Log.Error("[Exception] " + e);
      throw new Exception("조회에 실패하였습니다.");
  } finally {
      queryMap = null;
  }
  return map;
}

//소득공제서 출력가능여부
public Map selectDedPrintEnableYn(Map paramMap, String locPath) throws Exception {

    //파라메터 복사.
    Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map map = null;

    try{
        //쿼리 실행및 결과 받기.
        map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectDedPrintEnableYn",pm);
    } catch (Exception e) {
        Log.Error("[Exception] " + e);
        throw new Exception("조회에 실패하였습니다.");
    } finally {
        queryMap = null;
    }
    return map;
}

//소득공제서 전자서명 존재여부
public Map selectIncomeElcSignCnt(Map paramMap, String locPath) throws Exception {

  //파라메터 복사.
  Map pm =  StringUtil.getParamMapData(paramMap);
  //xml 파서를 이용한 방법;
  Map queryMap = XmlQueryParser.getQueryMap(locPath);
  Map map = null;

  try{
      //쿼리 실행및 결과 받기.
      map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectIncomeElcSignCnt",pm);
  } catch (Exception e) {
      Log.Error("[Exception] " + e);
      throw new Exception("조회에 실패하였습니다.");
  } finally {
      queryMap = null;
  }
  return map;
}


//추가 서류 제출 여부 조회
public Map selectIncomeElcSignMgr(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;
	
	try{
	    //쿼리 실행및 결과 받기.
	    map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectIncomeElcSignMgr",pm);
	} catch (Exception e) {
	    Log.Error("[Exception] " + e);
	    throw new Exception("조회에 실패하였습니다.");
	} finally {
        queryMap = null;
    }
	return map;
}


//IE 전자서명 저장
public int saveIncomeElcSign_IE(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

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
                
				if("U".equals(sStatus)) {
					rstCnt += DBConn.executeUpdate(conn, queryMap, "saveIncomeElcSign_IE", mp);
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

// 개인별 오류검증내역 조회
public List selectErrChkPerMgr(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception{

	Map pm = StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;

	try{
		listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectErrChkPerMgr", pm);
		saveLog(null, pm, ssnYeaLogYn);
	}catch(Exception e){
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

// 개인별 오류검증내역 갯수
public Map selectErrChkPerCnt(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	Map map = null;
	
	try{
	    //쿼리 실행및 결과 받기.
	    map  = (queryMap==null) ? null : DBConn.executeQueryMap(queryMap,"selectErrChkPerCnt",pm);
	} catch (Exception e) {
	    Log.Error("[Exception] " + e);
	    throw new Exception("조회에 실패하였습니다.");
	} finally {
      queryMap = null;
  }
	return map;
}


%>
<%
	String locPath = xmlPath+"/yeaData/yeaData.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectYeaDataDefaultInfo".equals(cmd)) {
		//소득공제자료등록 마감 정보 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectYeaDataDefaultInfo(mp, locPath);
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

	} else 	if("selectCheckClearYn".equals(cmd)) {
		//특이사항 표시

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectCheckClearYn(mp, locPath);
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

	} else 	if("selectUnusualPopupList".equals(cmd)) {
		//특이사항 팝업 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectUnusualPopupList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveUnusualPopup".equals(cmd)) {
		//특이사항 팝업 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";
		try {

			int cnt = saveUnusualPopup(mp, locPath);

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
	} else if("prcYeaClose".equals(cmd)) {
		//일반사용자 마감처리

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};

		String message = "";
		String code = "1";

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_CLOSE",type,param);

			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else if("ERR_CHK".equals(rstStr[0])) {
				message = "공제 자료 중 확인이 필요한 내용이 있습니다. 내용 확인 및 조치 후 마감 진행 부탁드립니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n"+rstStr[1];
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

	} else if("prcYeaCloseCancel".equals(cmd)) {
		//일반사용자 마감처리 취소

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};

		String message = "";
		String code = "1";

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_CLOSE_CANCEL",type,param);

			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n"+rstStr[1];
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
	} else if("prcYeaCalc".equals(cmd)) {
		//일반사용자 세액계산

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun}; 

		String message = "";
		String code = "1";

		try {

			String[] rstStr = DBConn.executeProcedure("PKG_CPN_YEA_"+yeaYear+"_EMP.P_MAIN",type,param);

			if( "".equals(rstStr[0]) ) {
				message = "모의세액 계산이 완료되었습니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n" + rstStr[1];
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
	} else if("prcYeaMgrClose".equals(cmd)) {
		//관리자 마감처리

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};

		String message = "";
		String code = "1";

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_MGR_CLOSE",type,param);

			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else if("ERR_CHK".equals(rstStr[0])) {
				message = "공제 자료 중 확인이 필요한 내용이 있습니다. 내용 확인 및 조치 후 마감 진행 부탁드립니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n"+rstStr[1];
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
	} else if("prcYeaMgrCloseCancel".equals(cmd)) {
		//관리자 마감처리 취소

		Map paramMap = StringUtil.getRequestMap(request);
		Map mp =  StringUtil.getParamMapData(paramMap);
		String payActionCd = (String)mp.get("searchPayActionCd");
		String workYy = (String)mp.get("searchWorkYy");
		String adjustType = (String)mp.get("searchAdjustType");
		String sabun = (String)mp.get("searchSabun");

		String[] type =  new String[]{"OUT","OUT","STR","STR","STR","STR","STR","STR"};
		String[] param = new String[]{"","",ssnEnterCd,payActionCd,workYy,adjustType,sabun,ssnSabun};

		String message = "";
		String code = "1";

		try {

			String[] rstStr = DBConn.executeProcedure("P_CPN_YEA_MGR_CLOSE_CANCEL",type,param);

			if( "".equals(rstStr[0]) ) {
				message = "처리되었습니다.";
			} else {
				code = "-1";
				message = "프로시저 실행에 실패하였습니다.\n"+rstStr[1];
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
	} else 	if("selectRes3List".equals(cmd)) {
		//소득공제자료등록 팝업 자료 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRes3List(mp, locPath, ssnYeaLogYn);
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

	} else 	if("selectRes2List871".equals(cmd)) {
		//소득공제자료등록 팝업 자료 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRes2List871(mp, locPath);
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

	} else 	if("selectRes5List873".equals(cmd)) {
		//소득공제자료등록 팝업 자료 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectRes5List873(mp, locPath);
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

	} else 	if("selectCommonSheetList".equals(cmd)) {
		//소득공제자료등록 기본 자료 조회

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectCommonSheetList(mp, locPath, ssnYeaLogYn);
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

	} else if("saveCommonSheet".equals(cmd)) {
		//소득공제자료등록 기본 자료 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {

			int cnt = saveCommonSheet(mp, locPath, ssnYeaLogYn);

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
	} else 	if("selectTabCnt".equals(cmd)) {
		//특이사항 표시

		Map mp = StringUtil.getRequestMap(request);

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);

		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectTabCnt(mp, locPath);
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

	} else 	if("selectFeedbackYn".equals(cmd)) {
		//담당자피드백 표시

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		Map mapData  = new HashMap();
		String message = "";
		String code = "1";

		try {
			mapData = selectFeedbackYn(mp, locPath);
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
	else if("selectDonDetailList".equals(cmd)){
		//FAQ 조회

		Map mp = StringUtil.getRequestMap(request);

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectDonDetailList(mp, locPath, ssnYeaLogYn);
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
	else if("selectForeignPayDetailList".equals(cmd)){
		//FAQ 조회

		Map mp = StringUtil.getRequestMap(request);

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectForeignPayDetailList(mp, locPath, ssnYeaLogYn);
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
	}else if("getPayTotal".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = getPayTotal(mp, locPath);
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

    } else if("saveReduceYmd".equals(cmd)) {
        //감면기간 저장
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = saveReduceYmd(mp, locPath, ssnYeaLogYn);

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

    } else if("getReduceYmd".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";

        try {
            mapData = getReduceYmd(mp, locPath);
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

    }else if("selecPayPeopleStsCnt".equals(cmd)) {
        //출력탭(기부금명세서)
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";
        try {
            mapData = selecPayPeopleStsCnt(mp, locPath);
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

    }else if("selectDedPrintEnableYn".equals(cmd)) {
        //소득공제서 출력가능여부
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";
        try {
            mapData = selectDedPrintEnableYn(mp, locPath);
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

    } else if("selectSignEnableYn".equals(cmd)) {
        //소득공제서 출력가능여부
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";
        try {
            mapData = selectSignEnableYn(mp, locPath);
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

    } else if("selectIncomeElcSignCnt".equals(cmd)){
    	//소득공제서 전자서명 존재여부
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";
        try {
            mapData = selectIncomeElcSignCnt(mp, locPath);
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
    } else if("selectIncomeElcSignMgr".equals(cmd)){
    	//추가 서류 제출 여부 조회
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";
        try {
            mapData = selectIncomeElcSignMgr(mp, locPath);
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
    } else if("saveIncomeElcSign_IE".equals(cmd)) {

    	Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = saveIncomeElcSign_IE(mp, locPath, ssnYeaLogYn);

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
	} else if("selectErrChkPerMgr".equals(cmd)){
    	// 개인별 오류검증내역 조회
		Map mp = StringUtil.getRequestMap(request);

		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectErrChkPerMgr(mp, locPath, ssnYeaLogYn);
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
    } else if("selectErrChkPerCnt".equals(cmd)){
    	//추가 서류 제출 여부 조회
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        Map mapData  = new HashMap();
        String message = "";
        String code = "1";
        try {
            mapData = selectErrChkPerCnt(mp, locPath);
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