<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../auth/saveLog.jsp"%>
<%!
//증빙자료 목록 조회
public List selectEvidenceDocMgrList(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
    String ssnSearchType = String.valueOf(pm.get("ssnSearchType"));
    String ssnSabun = String.valueOf(pm.get("ssnSabun"));

    StringBuffer query   = new StringBuffer();
    query.setLength(0);

    if(ssnSearchType.trim().length() != 0 && "P".equals(ssnSearchType)){
        query.append(" AND A.SABUN = '"+ssnSabun+"'");
    }else{
    	query.append(" AND (DECODE(#searchSbNm#,'','A',A.SABUN) LIKE '%'||DECODE(#searchSbNm#,'','A',#searchSbNm#)||'%' OR DECODE(#searchSbNm#,'','A',B.NAME) LIKE '%'||DECODE(#searchSbNm#,'','A',#searchSbNm#)||'%')");
    }

    pm.put("query", query.toString());
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectEvidenceDocMgrList",pm);
		saveLog(null, pm, ssnYeaLogYn);
	} catch (Exception e) {
        Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}

	return listData;
}

public int deleteEvidenceDocData(Map paramMap, String locPath) throws Exception {

	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	// 사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
    Connection conn = DBConn.getConnection();
    int rstCnt = 0;

    if (conn != null) {
        try {
            conn.setAutoCommit(false);

            rstCnt = DBConn.executeUpdate(conn, queryMap, "deleteEvidenceDocData", paramMap);
            conn.commit();
        } catch( Exception e ) {
            try {
                //롤백
                conn.rollback();
            } catch (Exception e1) {
                Log.Error("[rollback Exception] " + e);
            }
            rstCnt = 0;
            Log.Error("[Exception] " + e);
            throw new Exception("삭제에 실패하였습니다.");
        } finally {
            DBConn.closeConnection(conn, null, null);
            queryMap = null;
        }
    }
	return rstCnt;
}
public int saveYeaDataFileList2(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
    //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
    List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map pm =  StringUtil.getParamMapData(paramMap);
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
                String sStatus      = (String)mp.get("sStatus");
                String fileType     = (String)mp.get("file_type");
                String fileSeq      = (String)mp.get("file_seq");
                String sabun        = (String)mp.get("sabun");
                String work_yy      = (String)mp.get("work_yy");
                String adjust_type  = (String)mp.get("adjust_type");
                
                mp.put("fileType"   , fileType   );
                mp.put("fileSeq"    , fileSeq    );
                mp.put("sabun"      , sabun      );
                mp.put("work_yy"    , work_yy    );
                mp.put("adjust_type", adjust_type);

                if("U".equals(sStatus)) {
                    //수정
                    rstCnt += DBConn.executeUpdate(conn, queryMap, "updateYeaDataFileList2", mp);
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
public int updateStatusCd(Map paramMap, String locPath, String ssnYeaLogYn) throws Exception {
    //파라메터 맵안에는 배열형태로 저장되어 있으니 다시 리스트형태로 뽑아서 루프를 돈다.
    List list = StringUtil.getParamListData(paramMap);
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    Map pm =  StringUtil.getParamMapData(paramMap);
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
                String sStatus      = (String)mp.get("sStatus");
                String fileType     = (String)mp.get("file_type");
                String fileSeq      = (String)mp.get("file_seq");
                String sabun        = (String)mp.get("sabun");
                String work_yy      = (String)mp.get("work_yy");
                String adjust_type  = (String)mp.get("adjust_type");
                
                mp.put("fileType"   , fileType   );
                mp.put("fileSeq"    , fileSeq    );
                mp.put("sabun"      , sabun      );
                mp.put("work_yy"    , work_yy    );
                mp.put("adjust_type", adjust_type);
                
                if("U".equals(sStatus)) {
                    //수정
                	rstCnt += DBConn.executeUpdate(conn, queryMap, "updateStatusCd", mp);
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
%>

<%
	String locPath = xmlPath+"/evidenceDocMgr/evidenceDocMgr.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String ssnYeaLogYn = (String)session.getAttribute("ssnYeaLogYn");
	String cmd = (String)request.getParameter("cmd");

	if("selectEvidenceDocMgrList".equals(cmd)) {
		//증빙자료 목록 조회
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		mp.put("cmd", cmd);
		List listData  = new ArrayList();
		String message = "";
		String code = "1";

		try {
			listData = selectEvidenceDocMgrList(mp, locPath, ssnYeaLogYn);
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

	} else if("deleteEvidenceDocMgrList".equals(cmd)) {
		//증빙자료 삭제
		Map mp = StringUtil.getRequestMap(request);

        String paramYear       = request.getParameter("searchWorkYy");
	    String paramValue    	= request.getParameter("pValue");

        if (paramYear != null) {
            paramYear = paramYear.toString();
            paramYear = paramYear.replaceAll("/","");
            paramYear = paramYear.replaceAll("\\\\","");
            paramYear = paramYear.replaceAll("\\.","");
            paramYear = paramYear.replaceAll("&","");
        }

        if (paramValue != null) {
            paramValue = paramValue.toString();
        }

		JSONArray jsonArr = new JSONArray(paramValue);
		JSONObject jsonObj = null;

		String serverPath = "";
		String filePath = "";
		String nfsUploadPath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");

		if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
			serverPath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH");
        } else {
        	serverPath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH");
        }

		String message = "";
        String code = "1";
        Map param = null;

		if(jsonArr == null || jsonArr.length() == 0) {
			code = "-1";
   	    	message = "잘못된 파라메터";
		} else {

			for(int i=0; i<jsonArr.length(); i++) {
				jsonObj = jsonArr.getJSONObject(i);

				param = new HashMap();
			    param.put("ssnEnterCd", ssnEnterCd);
			    param.put("sabun", jsonObj.getString("sabun"));
			    param.put("workYy", jsonObj.getString("workYy"));
			    param.put("adjustType", jsonObj.getString("adjustType"));
			    param.put("fileType", jsonObj.getString("fileType"));
			    param.put("fileSeq", jsonObj.getString("fileSeq"));

			    String fileName = jsonObj.getString("fileName");
			    String fileType = jsonObj.getString("fileType");

			    if("1".equals(fileType)) {
	            	//hrfile/YEA_INCOME/회사코드/년도/
	            	filePath = serverPath+"/YEA_INCOME/"+ssnEnterCd+"/"+paramYear;
	            } else {
	            	//hrfile/YEA_ADDFILE/회사코드/년도/
	            	filePath = serverPath+"/YEA_ADDFILE/"+ssnEnterCd+"/"+paramYear;
	            }

			    try {
                    File f = new File(filePath + "/" + removeXSS(fileName, "fileName")); // 파일 객체생성
		       	    if( f.exists()) {
		       	    	boolean flag = true;

		       	    	if(f.delete()){ // 파일이 존재하면 파일을 삭제한다.

		       	    		// 파일 데이터 삭제
		       	    		if(deleteEvidenceDocData(param, locPath) != 1) {
		       	    			flag = false;
		       	    		}
		       	    	} else {
		       	    		flag = false;
		       	    	}

		       	    	if(!flag) {
		       	    	    code = "-1";
		                    message = "파일 삭제에 실패 하였습니다.";
		                    break;
		                } else {
		                	code = "1";
		                	message = "파일 삭제에 성공 하였습니다.";
		                }
		       	    } else {
		       	    	code = "-1";
		       	    	message = "삭제할 파일이 존재하지 않습니다.";
		       	    	break;
		       	    }
		        } catch(Exception e) {
		            code = "-1";
		            message = e.getMessage();
		            break;
		        }
			}
		}

        Map mapCode = new HashMap();
        mapCode.put("Code", code);
        mapCode.put("Message", message);

        Map rstMap = new HashMap();
        rstMap.put("Result", mapCode);
        out.print((new org.json.JSONObject(rstMap)).toString());
	} else if("saveYeaDataFileList2".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        
        
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = saveYeaDataFileList2(mp, locPath, ssnYeaLogYn);

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

    } else if("updateStatusCd".equals(cmd)) {

        Map mp = StringUtil.getRequestMap(request);
        
        
        mp.put("ssnEnterCd", ssnEnterCd);
        mp.put("ssnSabun", ssnSabun);
        mp.put("cmd", cmd);
        String message = "";
        String code = "1";

        try {
            int cnt = updateStatusCd(mp, locPath, ssnYeaLogYn);

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