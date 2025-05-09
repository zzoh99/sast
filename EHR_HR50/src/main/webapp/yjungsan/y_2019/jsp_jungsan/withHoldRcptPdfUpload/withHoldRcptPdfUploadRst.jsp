<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLDecoder"%>
 
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%!

//증빙자료 목록 조회
public List selectWithHoldRcptPdfUploadList(Map paramMap, String locPath) throws Exception {

	//파라메터 복사.
	Map pm =  StringUtil.getParamMapData(paramMap);
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
	List listData = null;
	
	try{
		//쿼리 실행및 결과 받기.
		listData  = (queryMap == null) ? null : DBConn.executeQueryList(queryMap,"selectWithHoldRcptPdfUploadList",pm);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("조회에 실패하였습니다.");
	} finally {
		queryMap = null;
	}
	
	return listData;
}

public int deleteWithHoldRcptData(Map paramMap, String locPath) throws Exception {
	
	// 파라메터 셋팅

	// 사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
    Connection conn = DBConn.getConnection();
	Map queryMap = XmlQueryParser.getQueryMap(locPath);
    int rstCnt = 0;
	
    if (conn != null) {
	    try {
	    	conn.setAutoCommit(false);
	    	
	    	rstCnt = DBConn.executeUpdate(conn, queryMap, "deleteWithHoldRcptData", paramMap);
	    	
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
%>

<%
	String locPath = xmlPath+"/withHoldRcptPdfUpload/withHoldRcptPdfUpload.xml";

	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");

	if("selectWithHoldRcptPdfUploadList".equals(cmd)) {
		//증빙자료 목록 조회
		Map mp = StringUtil.getRequestMap(request);
		mp.put("ssnEnterCd", ssnEnterCd);
		mp.put("ssnSabun", ssnSabun);
		
		List listData  = new ArrayList();
		String message = "";
		String code = "1";
	
		try {
			listData = selectWithHoldRcptPdfUploadList(mp, locPath);
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
		
	} else if("deleteWithHoldRcptPdfUploadList".equals(cmd)) {
		//PDF 파일 삭제
        Map mp = StringUtil.getRequestMap(request);
	    
        String paramYear       = request.getParameter("searchWorkYy") != null ? request.getParameter("searchWorkYy").toString() : "";
	    String paramValue    	= request.getParameter("pValue") != null ? request.getParameter("pValue").toString() : "";

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
		       	    File f = new File(filePath+"/"+fileName); // 파일 객체생성
		       	    if( f.exists()) {
		       	    	boolean flag = true;
		       	    	
		       	    	if(f.delete()){ // 파일이 존재하면 파일을 삭제한다.
		       	    		
		       	    		// 파일 데이터 삭제
		       	    		if(deleteWithHoldRcptData(param) != 1) {
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
	}
%>