<%@page import="signgate.provider.ec.codec.Base16"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="org.apache.commons.codec.binary.Base64"%>
<%@ page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
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
<%@ include file="../auth/saveLog.jsp"%>
<%!

//전자서명(소득공제서)
public int saveIncomeElcSign(Map paramMap, String locPath) throws Exception {

	//사용자가 직접 트렌젝션 관리하기 위해 커넥션 가져오기.
	Connection conn = DBConn.getConnection();
	int rstCnt = 0;
	//xml 파서를 이용한 방법;
	Map queryMap = XmlQueryParser.getQueryMap(locPath);

	conn.setAutoCommit(false);

	try{
		rstCnt = DBConn.executeUpdate(conn, queryMap, "saveIncomeElcSign", paramMap);
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

	return rstCnt;
}
%>

<%
	
	FileUploadConfig fileConfig = new FileUploadConfig("pht002");
	
	String locPath = xmlPath+"/yeaData/yeaData.xml";
	
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
	String ssnSabun = (String)session.getAttribute("ssnSabun");
	String cmd = (String)request.getParameter("cmd");
	String searchWorkYy 	= (String)request.getParameter("searchWorkYy");
	String searchAdjustType = (String)request.getParameter("searchAdjustType");
	String searchSabun 		= (String)request.getParameter("searchSabun");
	String forSubmitYn 		= (String)request.getParameter("forSubmitYn");
	String incomeSubmitYn 	= (String)request.getParameter("incomeSubmitYn");
	String penSubmitYn 		= (String)request.getParameter("penSubmitYn");
	String rentSubmitYn 	= (String)request.getParameter("rentSubmitYn");
	String medSubmitYn 		= (String)request.getParameter("medSubmitYn");
	String doSubmitYn 		= (String)request.getParameter("doSubmitYn");

	Map param = new HashMap();
	param.put("ssnSabun", 	session.getAttribute("ssnSabun"));
	param.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
	param.put("searchWorkYy", 		searchWorkYy);
	param.put("searchAdjustType", 	searchAdjustType);
	param.put("searchSabun", 		searchSabun);
	param.put("forSubmitYn", 		forSubmitYn);
	param.put("incomeSubmitYn", 	incomeSubmitYn);
	param.put("penSubmitYn", 		penSubmitYn);
	param.put("rentSubmitYn", 		rentSubmitYn);
	param.put("medSubmitYn", 		medSubmitYn);
	param.put("doSubmitYn", 		doSubmitYn);

	String realPath = (fileConfig.getDiskPath().length() == 0)? request.getSession().getServletContext().getRealPath("/")+"/hrfile" : fileConfig.getDiskPath();
	String targetPath = StringUtil.replaceAll(realPath + "/" + session.getAttribute("ssnEnterCd"), "//", "/");

    String tmp = fileConfig.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
    tmp = tmp == null ? "" : tmp;
	targetPath = targetPath + tmp+"/";

	String sign = String.valueOf(request.getParameter("sign"));
	
	if (sign.indexOf(",") < 0) {
		//URI 인코딩이 걸려 있는 경우 DECODE 수행		
		if (StringUtil.getPropertiesValue("SYS.ENC").contains("8")) {
			sign = URLDecoder.decode(sign, "UTF-8");
		} else {
			sign = URLDecoder.decode(sign, "EUC-KR");
		}
	}
	
	sign = StringUtils.split(sign, ",")[1];
	
	String fileName = "sign"+System.currentTimeMillis()+".png";

	File f = new File(targetPath+fileName);
	FileUtils.writeByteArrayToFile(f, Base64.decodeBase64(sign));

	
    //프로그램관리 저장
    Map mp = StringUtil.getRequestMap(request);
    mp.put("ssnEnterCd", ssnEnterCd);
    mp.put("ssnSabun", ssnSabun);
    mp.put("cmd", cmd);

    String message = "";
    String code = "1";

	param.put("seqNo",     "0");
	//param.put("fileSize",  f.length());
	param.put("filePath",  tmp);
	param.put("rFileNm",   fileName );
	param.put("sFileNm",   fileName );

     try {
         int cnt = saveIncomeElcSign(param, locPath);

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
%>