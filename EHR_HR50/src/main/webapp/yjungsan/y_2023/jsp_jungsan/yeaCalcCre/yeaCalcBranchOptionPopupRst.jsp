<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="org.json.JSONObject"%>
<%@ page import="org.apache.log4j.Logger"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!

	//연말정산 사업자 단위과세자 조회
	public List selectBranchOptionList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

		//파라메터 복사.
		Map pm = StringUtil.getParamMapData(paramMap);
	    //xml 파서를 이용한 방법;
	    Map queryMap = XmlQueryParser.getQueryMap(locPath);
		List listData = null;

		try {
			//쿼리 실행및 결과 받기.
			listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectBranchOptionList", pm);
			saveLog(null, pm, ssnYeaLogYn);
		} catch (Exception e) {
			Log.Error("[Exception] " + e);
			throw new Exception("조회에 실패하였습니다.");
		} finally {
		    queryMap = null;
	    }

		return listData;
	}

	//연말정산 사업자 단위과세자 조회
    public List selectBranchOptionList_SH(Map paramMap, String locPath) throws Exception {

        //파라메터 복사.
        Map pm = StringUtil.getParamMapData(paramMap);
	    //xml 파서를 이용한 방법;
	    Map queryMap = XmlQueryParser.getQueryMap(locPath);
        List listData = null;

        try {
            //쿼리 실행및 결과 받기.
            listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectBranchOptionList_SH", pm);
        } catch (Exception e) {
            Log.Error("[Exception] " + e);
            throw new Exception("조회에 실패하였습니다.");
        } finally {
		    queryMap = null;
	    }

        return listData;
    }

	//연말정산 사업자 단위과세자 저장.
	public int saveBranchOption(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

		List list = StringUtil.getParamListData(paramMap);
	    //xml 파서를 이용한 방법;
	    Map queryMap = XmlQueryParser.getQueryMap(locPath);

		Connection conn = DBConn.getConnection();
		int rstCnt = 0;

		if (list != null && list.size() > 0 && conn != null) {

			conn.setAutoCommit(false);

			try {
				for (int i = 0; i < list.size(); i++) {
					String query = "";
					Map mp = (Map) list.get(i);
					String sStatus = (String) mp.get("sStatus");
	                Map mp2 = (Map)list.get(0);
	                String menuNm = (String)mp2.get("menuNm");
	                mp.put("menuNm", menuNm);
					if ("I".equals(sStatus) || "U".equals(sStatus)) {
						//수정
						rstCnt += DBConn.executeUpdate(conn, queryMap, "updateBranchOption", mp);
					} else if ("D".equals(sStatus)) {
						rstCnt += DBConn.executeUpdate(conn, queryMap, "deleteBranchOption", mp);
					} else {
						throw new UserException("저장에 실패하였습니다.");
					}
					saveLog(conn, mp, ssnYeaLogYn);
				}

				//커밋
				conn.commit();
			} catch (UserException e) {
				try {
					//롤백
					conn.rollback();
				} catch (Exception e1) {
					Log.Error("[rollback Exception] " + e);
				}
				rstCnt = 0;
				Log.Error("[Exception] " + e);
				throw new Exception(e.getMessage());
			} catch (Exception e) {
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

	//연말정산 사업자 단위과세자 조회
    public List selectBranchPlaceCdList(Map paramMap, String locPath) throws Exception {

        //파라메터 복사.
        Map pm = StringUtil.getParamMapData(paramMap);
	    //xml 파서를 이용한 방법;
	    Map queryMap = XmlQueryParser.getQueryMap(locPath);
        List listData = null;

        try {
            //쿼리 실행및 결과 받기.
            listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectBranchPlaceCdList", pm);
        } catch (Exception e) {
            Log.Error("[Exception] " + e);
            throw new Exception("조회에 실패하였습니다.");
        } finally {
		    queryMap = null;
	    }

        return listData;
    }

  //연말정산 사업자 단위과세자 조회 - 서흥용
    public List selectBranchPlaceCdList_SH(Map paramMap, String locPath) throws Exception {

        //파라메터 복사.
        Map pm = StringUtil.getParamMapData(paramMap);
	    //xml 파서를 이용한 방법;
	    Map queryMap = XmlQueryParser.getQueryMap(locPath);
        List listData = null;

        try {
            //쿼리 실행및 결과 받기.
            listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectBranchPlaceCdList_SH", pm);
        } catch (Exception e) {
            Log.Error("[Exception] " + e);
            throw new Exception("조회에 실패하였습니다.");
        } finally {
		    queryMap = null;
	    }

        return listData;
    }

	//연말정산 사업자 단위과세자 날자 조회
    public List selectBranchDt(Map paramMap, String locPath) throws Exception {

        //파라메터 복사.
        Map pm = StringUtil.getParamMapData(paramMap);
	    //xml 파서를 이용한 방법;
	    Map queryMap = XmlQueryParser.getQueryMap(locPath);
        List listData = null;

        try {
            //쿼리 실행및 결과 받기.
            listData = (queryMap == null) ? null : DBConn.executeQueryList(queryMap, "selectBranchDt", pm);
        } catch (Exception e) {
            Log.Error("[Exception] " + e);
            throw new Exception("조회에 실패하였습니다.");
        } finally {
		    queryMap = null;
	    }

        return listData;
    }
%>

<%
	String locPath = xmlPath + "/yeaCalcCre/yeaCalcBranchOptionPopup.xml";

	String ssnEnterCd = (String) session.getAttribute("ssnEnterCd");
	String ssnSabun = (String) session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String) session.getAttribute("ssnYeaLogYn");
	String cmd = (String) request.getParameter("cmd");

	if ("selectBranchOptionList".equals(cmd)) {
		//연말정산 사업자 단위과세자 조회

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
		List listData = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectBranchOptionList(mp, locPath, ssnYeaLogYn);
		} catch (Exception e) {
			code = "-1";
			message = e.getMessage();
        }

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);
		rstMap.put("Data", listData == null ? null : (List) listData);
		out.print((new org.json.JSONObject(rstMap)).toString());
	} else if ("selectBranchOptionList_SH".equals(cmd)) {
        //연말정산 사업자 단위과세자 조회

        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);

        List listData = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectBranchOptionList_SH(mp, locPath);
        } catch (Exception e) {
            code = "-1";
            message = e.getMessage();
        }

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        rstMap.put("Data", listData == null ? null : (List) listData);
        out.print((new org.json.JSONObject(rstMap)).toString());
    } else if ("saveBranchOption".equals(cmd)) {
		//연말정산 사업자 단위과세자 저장

		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		String message = "";
		String code = "1";

		try {
			int cnt = saveBranchOption(mp, locPath, ssnYeaLogYn);

			if (cnt > 0) {
				message = "저장되었습니다.";
			} else {
				code = "-1";
				message = "저장된 내용이 없습니다.";
			}

		} catch (Exception e) {
			code = "-1";
			message = e.getMessage();
		}

		Map mapCode = new HashMap();
		mapCode.put("Code", code);
		mapCode.put("Message", message);

		Map rstMap = new HashMap();
		rstMap.put("Result", mapCode);

		out.print((new org.json.JSONObject(rstMap)).toString());

	} else if ("selectBranchPlaceCdList".equals(cmd)) {
		Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);

        List listData = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectBranchPlaceCdList(mp, locPath);
        } catch (Exception e) {
            code = "-1";
            message = e.getMessage();
        }

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        rstMap.put("codeList", listData == null ? null : (List) listData);
        out.print((new org.json.JSONObject(rstMap)).toString());
	} else if ("selectBranchPlaceCdList_SH".equals(cmd)) {
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);

        List listData = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectBranchPlaceCdList_SH(mp, locPath);
        } catch (Exception e) {
            code = "-1";
            message = e.getMessage();
        }

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        rstMap.put("codeList", listData == null ? null : (List) listData);
        out.print((new org.json.JSONObject(rstMap)).toString());
    } else if ("selectBranchPlaceCd".equals(cmd)) {
        Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);

        List listData = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectBranchPlaceCdList(mp, locPath);
        } catch (Exception e) {
            code = "-1";
            message = e.getMessage();
        }

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        rstMap.put("codeList", listData == null ? null : (List) listData);
        out.print((new org.json.JSONObject(rstMap)).toString());
    } else if ("selectBranchDt".equals(cmd)) {
    	Map mp = StringUtil.getRequestMap(request);
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("searchWorkYy", request.getParameter("searchWorkYy"));

        List listData = new ArrayList();
        String message = "";
        String code = "1";

        try {
            listData = selectBranchDt(mp, locPath);
        } catch (Exception e) {
            code = "-1";
            message = e.getMessage();
        }

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        rstMap.put("dtList", listData == null ? null : (List) listData);
        out.print((new org.json.JSONObject(rstMap)).toString());
    }
%>