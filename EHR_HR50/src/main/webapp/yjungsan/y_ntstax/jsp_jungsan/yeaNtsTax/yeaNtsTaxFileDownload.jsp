<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="org.json.JSONObject" %>
<%@ page import="com.hr.common.logger.Log" %>

<%
	//Logger log = Logger.getLogger(this.getClass());
	request.setCharacterEncoding(StringUtil.getPropertiesValue("SYS.ENC"));
	
	Map paramMap = StringUtil.getRequestMap(request);
	Map pm =  StringUtil.getParamMapData(paramMap);
	
	Log.Debug("============== [NTSTAX 파일 다운로드 시작] ===============");

	try {
		String serverFileName = (String)pm.get("fileName");
		String ssnEnterCd = (String)pm.get("ssnEnterCd");
		String viewFileName = serverFileName.substring(0,serverFileName.lastIndexOf("."));
		String serverFilePath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치
		/*태영건설은 신고파일 저장경로를 변경해서 사용(태영건설 정화미님) - 2020.02.18.
		String serverFilePath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH")+"/NTS_FILES/"+ssnEnterCd; //저장위치 
		*/
		
		Log.Debug("serverFileName == "+serverFileName);
		Log.Debug("viewFileName == "+viewFileName);
		Log.Debug("serverFilePath == "+serverFilePath);
		
		File file = new File(serverFilePath+"/"+serverFileName);
	    byte buf[] = new byte[4096];
		
	    /***** 레진에서 필요 *****/
		response.reset();
		response.setContentLength((int)file.length());
		/*******************/

		response.setHeader("Content-Type", "application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename=" + viewFileName + ";");
		response.setHeader("Pargma", "no-cache");
		response.setHeader("Expires", "-1");

	    BufferedInputStream  inputStream = new BufferedInputStream(new FileInputStream(file));
	    BufferedOutputStream outStream = new BufferedOutputStream(response.getOutputStream());

	    int numRead;
	    while((numRead = inputStream.read(buf, 0, buf.length)) != -1){
	    	outStream.write(buf, 0, numRead);
			outStream.flush();
	    }
		out.clear();
		out = pageContext.pushBody();
		outStream.close();
	    inputStream.close();
	} catch(Exception e) {
		out.println("<script>alert('파일다운로드중 오류가 발생하였습니다.');</script>");	
		//e.printStackTrace();
	}
	
	Log.Debug("============== [NTSTAX 파일 다운로드 종료] ===============");
	
%>