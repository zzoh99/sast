<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.zip.ZipEntry"%>
<%@ page import="java.util.zip.ZipOutputStream"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" import="m2soft.ers.invoker.InvokerException" %>
<%@ page language="java" import="m2soft.ers.invoker.http.ReportingServerInvoker" %>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.File"%>

<%!

private Map rdChk(String rdFilePath) throws Exception {
	/* File rdFile = new File(rdFilePath); */
	
	Map<String, Object> rstMap = new HashMap<>();
	
	try {
		if (exists(rdFilePath)) {
			rstMap.put("fileExist", "Y");	
		} else {
			rstMap.put("fileExist", "N");
		}

	} catch (Exception e) {
		throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
	}
	return rstMap;
	
	
}

private boolean exists(String rdFilePath) {
	HttpURLConnection con = null;
	try {
		HttpURLConnection.setFollowRedirects(false);
		
		con = (HttpURLConnection) new URL(rdFilePath).openConnection();
		con.setRequestMethod("HEAD");
		return (con.getResponseCode() == HttpURLConnection.HTTP_OK);
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		return false;
	} finally {
        // 연결 닫기
        if (con != null) {
        	con.disconnect();
        }
    }
}


private Map getRecentFile(String pWorkYy, String tmpSabun) throws Exception {
	// 시큐어코딩으로 인하여 전달받은 파라미터 XSS체크를 매번 수행 20240712
	String workYy = pWorkYy ;
	String sabun  = tmpSabun;
	
	if (workYy == null || "".equals(workYy)) {
		workYy = "" ;
	} else {
		workYy = workYy.replaceAll("/","");	
		workYy = workYy.replaceAll("\\\\","");
		workYy = workYy.replaceAll("\\.","");
		workYy = workYy.replaceAll("&", "");
	}

	if (sabun == null || "".equals(sabun)) {
		sabun = "" ;
	} else {
		sabun = sabun.replaceAll("/","");	
		sabun = sabun.replaceAll("\\\\","");
		sabun = sabun.replaceAll("\\.","");
		sabun = sabun.replaceAll("&", "");	
	}	

	String serverFilePath = StringUtil.getPropertiesValue("WAS.PATH") + StringUtil.getPropertiesValue("HRFILE.PATH") 
                            + "/YEA/rcpt/" + workYy + "/" + sabun ;
	
	File directory = new File(serverFilePath);
	File[] files = directory.listFiles(File::isFile);
	long lastModifiedTime = Long.MIN_VALUE;
	long fileSize = 0;
	File chosenFile = null;
	Map<String, Object> rstMap = new HashMap<>();
	
	try {
		if (files != null) {
			for (File file : files) {
				if (file.lastModified() > lastModifiedTime) {
					chosenFile = file;
					lastModifiedTime = file.lastModified();
					fileSize = file.length();
				} 
			}
			
			for (File file : files) {
				if (chosenFile != file) {
					file.delete();
				} 
			}
		}

		double fileSizeInKB = fileSize / 1024;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String formattedDate = sdf.format(lastModifiedTime);
		
		rstMap.put("downFileName", chosenFile != null ? chosenFile.getName() : null);
		rstMap.put("downFileDate", formattedDate);
		rstMap.put("downFileSize", fileSizeInKB + "KB");
		
	} catch (Exception e) {
		throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
	}
	return rstMap;
}

private Map CheckDisk(String pWorkYy, String sabunCnt, String printOption, String tmpSabun) throws Exception {
	// 시큐어코딩으로 인하여 전달받은 파라미터 XSS체크를 매번 수행 20240712
	String workYy = pWorkYy ;
	String sabun  = tmpSabun;
	
	if (workYy == null || "".equals(workYy)) {
		workYy = "" ;
	} else {
		workYy = workYy.replaceAll("/","");	
		workYy = workYy.replaceAll("\\\\","");
		workYy = workYy.replaceAll("\\.","");
		workYy = workYy.replaceAll("&", "");
	}

	if (sabun == null || "".equals(sabun)) {
		sabun = "" ;
	} else {
		sabun = sabun.replaceAll("/","");	
		sabun = sabun.replaceAll("\\\\","");
		sabun = sabun.replaceAll("\\.","");
		sabun = sabun.replaceAll("&", "");	
	}	

	String serverFilePath = StringUtil.getPropertiesValue("WAS.PATH") + StringUtil.getPropertiesValue("HRFILE.PATH") 
                            + "/YEA/rcpt/" + workYy + "/" + sabun ;
	
	//용량체크
	Map<String, Object> rstMap = new HashMap<>();
	
	try {
		File diskCheck = new File(serverFilePath);
	    
	    long usableSpace = diskCheck.getUsableSpace();
	    long totFile = Integer.parseInt(sabunCnt) * 200;
	    
	    usableSpace = (usableSpace/(1024 * 1024));
	    
	    if("Y".equals(printOption)) {
	    	totFile = 0;
		}
	    
		rstMap.put("usableSpace", usableSpace);
		rstMap.put("totFile", totFile);
		
		
	} catch (Exception e) {
		throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
	}
	return rstMap;
}

//파일 디렉토리 생성
private void fileDir(String pWorkYy, String tmpSabun) throws Exception {
	// 시큐어코딩으로 인하여 전달받은 파라미터 XSS체크를 매번 수행 20240712
	String workYy = pWorkYy ;
	String sabun  = tmpSabun;
	
	if (workYy == null || "".equals(workYy)) {
		workYy = "" ;
	} else {
		workYy = workYy.replaceAll("/","");	
		workYy = workYy.replaceAll("\\\\","");
		workYy = workYy.replaceAll("\\.","");
		workYy = workYy.replaceAll("&", "");
	}

	if (sabun == null || "".equals(sabun)) {
		sabun = "" ;
	} else {
		sabun = sabun.replaceAll("/","");	
		sabun = sabun.replaceAll("\\\\","");
		sabun = sabun.replaceAll("\\.","");
		sabun = sabun.replaceAll("&", "");	
	}	

	String serverFilePath = StringUtil.getPropertiesValue("WAS.PATH") + StringUtil.getPropertiesValue("HRFILE.PATH") 
                            + "/YEA/rcpt/" + workYy + "/" + sabun ;
	
	try{
		File dir = new File(serverFilePath);
		
		if(!dir.exists()) {
			dir.mkdirs();
		}
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("파일 디렉토리 생성중 오류 발생.");
	}
}

private Map cntChk(String pWorkYy, String tmpSabun) throws Exception {
	// 시큐어코딩으로 인하여 전달받은 파라미터 XSS체크를 매번 수행 20240712
	String workYy = pWorkYy ;
	String sabun  = tmpSabun;
	
	if (workYy == null || "".equals(workYy)) {
		workYy = "" ;
	} else {
		workYy = workYy.replaceAll("/","");	
		workYy = workYy.replaceAll("\\\\","");
		workYy = workYy.replaceAll("\\.","");
		workYy = workYy.replaceAll("&", "");
	}

	if (sabun == null || "".equals(sabun)) {
		sabun = "" ;
	} else {
		sabun = sabun.replaceAll("/","");	
		sabun = sabun.replaceAll("\\\\","");
		sabun = sabun.replaceAll("\\.","");
		sabun = sabun.replaceAll("&", "");	
	}	

	String serverFilePath = StringUtil.getPropertiesValue("WAS.PATH") + StringUtil.getPropertiesValue("HRFILE.PATH") 
                            + "/YEA/rcpt/" + workYy + "/" + sabun ;
	
	Map<String, Object> rstMap = new HashMap<>();
	int fileCnt = 0;
	
	try{
		File dir = new File(serverFilePath);
		File[] files = dir.listFiles();
	
		fileCnt = (files == null) ? 0 : files.length;
		
		rstMap.put("fileCnt", fileCnt);
		
	} catch (Exception e) {
		Log.Error("[Exception] " + e);
		throw new Exception("파일 디렉토리 생성중 오류 발생.");
	}
	
	return rstMap;
}

%>

<%

request.setCharacterEncoding(StringUtil.getPropertiesValue("SYS.ENC"));
Map paramMap = StringUtil.getRequestMap(request);
Map pm =  StringUtil.getParamMapData(paramMap);

String cmd = request.getParameter("cmd");
String sabunCnt = request.getParameter("sabunCnt");
String printOption = request.getParameter("sprintOption");

String rdAliasName = StringUtil.getPropertiesValue("RD.ALIAS.NAME"); //RD alias
String rdUrl = StringUtil.getPropertiesValue("RD.URL"); //RD url

String workYy = String.valueOf(request.getParameter("searchWorkYy"));
String tmpSabun  = String.valueOf(session.getAttribute("ssnSabun"));

LocalDateTime now = LocalDateTime.now();
String formatedNow = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
String formatedYyyy = now.format(DateTimeFormatter.ofPattern("yyyy"));
String formatedMm = now.format(DateTimeFormatter.ofPattern("MM"));
String formatedDd = now.format(DateTimeFormatter.ofPattern("dd"));

if (workYy == null || "".equals(workYy)) {
	workYy = "";
} else {
	workYy = workYy.replaceAll("/","");	
	workYy = workYy.replaceAll("\\\\","");
	workYy = workYy.replaceAll("\\.","");
	workYy = workYy.replaceAll("&", "");
}

if (tmpSabun == null || "".equals(tmpSabun)) {
	tmpSabun = "";	
} else {
	tmpSabun = tmpSabun.replaceAll("/","");	
	tmpSabun = tmpSabun.replaceAll("\\\\","");
	tmpSabun = tmpSabun.replaceAll("\\.","");
	tmpSabun = tmpSabun.replaceAll("&", "");	
}	

String serverFilePath = StringUtil.getPropertiesValue("WAS.PATH") + StringUtil.getPropertiesValue("HRFILE.PATH") 
                           + "/YEA/rcpt/" + workYy + "/" + tmpSabun ;

if("onload".equals(cmd)) {
	
	Map rstMap  = new HashMap();
	
	try {
		rstMap = rdChk(StringUtil.getBaseUrl(request)+"/html/report/"+URLDecoder.decode(request.getParameter("rdMrd")));
	} catch(Exception e) {
		throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
	}
	
	if(rstMap.get("fileExist") == "Y") {
		try {
			rstMap = getRecentFile(workYy, tmpSabun);
		} catch(Exception e) {
			throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
		}
	}
	
	out.print((new org.json.JSONObject(rstMap)).toString());
	    
} else if("CheckDisk".equals(cmd)) {
	
	fileDir(workYy, tmpSabun);
	
	Map rstMap  = new HashMap();
	
	try {
		rstMap = CheckDisk(workYy, sabunCnt, printOption, tmpSabun);
	} catch(Exception e) {
		throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
	}
	
	out.print((new org.json.JSONObject(rstMap)).toString());
	
} else if("cntChk".equals(cmd)) {
	
	Map rstMap = new HashMap();
	
	try {
		rstMap = cntChk(workYy, tmpSabun);
	} catch(Exception e) {
		throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
	}
	
	out.print((new org.json.JSONObject(rstMap)).toString());
	
} else if("creFile".equals(cmd)) {

	String pSabuns = URLDecoder.decode(request.getParameter("sPsabuns"));
	String arrName = URLDecoder.decode(request.getParameter("arrName"));
	String sabun = URLDecoder.decode(request.getParameter("ssabun"));
	String empName = URLDecoder.decode(request.getParameter("empName"));
	
	String rdTitle = URLDecoder.decode(request.getParameter("rdTitle"));
	String rdMrd = URLDecoder.decode(request.getParameter("rdMrd"));
	String rdParam1 = URLDecoder.decode(request.getParameter("rdParam1"));
	String rdParam2 = URLDecoder.decode(request.getParameter("rdParam2"));
	String rdParam3 = URLDecoder.decode(request.getParameter("rdParam3"));
	String rdParam4 = URLDecoder.decode(request.getParameter("rdParam4"));
	String rdParam5 = URLDecoder.decode(request.getParameter("rdParam5"));
	String rdParam6 = URLDecoder.decode(request.getParameter("rdParam6"));
	String rdParam7 = URLDecoder.decode(request.getParameter("rdParam7"));
	String rdParam8 = URLDecoder.decode(request.getParameter("rdParam8"));
	String rdParam9 = URLDecoder.decode(request.getParameter("rdParam9"));
	String rdParam10 = URLDecoder.decode(request.getParameter("rdParam10"));
	String rdParam11 = URLDecoder.decode(request.getParameter("rdParam11"));
	String rdParam12 = URLDecoder.decode(request.getParameter("rdParam12"));
	String rdParam13 = URLDecoder.decode(request.getParameter("rdParam13"));
	String rdParam14 = URLDecoder.decode(request.getParameter("rdParam14"));
	String rdParam15 = URLDecoder.decode(request.getParameter("rdParam15"));
	String rdParam16 = URLDecoder.decode(request.getParameter("rdParam16"));
	String rdParam17 = URLDecoder.decode(request.getParameter("rdParam17"));
	
	String[] arrFileName;
	String[] zipFileCnt;
	request.setCharacterEncoding(StringUtil.getPropertiesValue("SYS.ENC"));
	String[] splitSabun = pSabuns.split(",");
	String[] splitName = arrName.split(",");
	arrFileName = new String[splitSabun.length];
	
	ReportingServerInvoker invoker = new ReportingServerInvoker(rdUrl+"/ReportingServer/service");
	
	invoker.setCharacterEncoding("utf-8");   //캐릭터셋
	invoker.setReconnectionCount(3);        //재접속 시도 회수
	invoker.setConnectTimeout(50);           //커넥션 타임아웃
	invoker.setReadTimeout(300);             //송수신 타임아웃	      
	invoker.addParameter("opcode", "500");
	invoker.addParameter("mrd_path", StringUtil.getBaseUrl(request)+"/html/report/"+rdMrd);
	invoker.addParameter("export_type", "pdf");
	invoker.addParameter("protocol", "file");

	String creFileName = "";
	String nameRule = ""; 
	
	for(int i=1; i<5; i++) {
		nameRule = request.getParameter("nameRule" + String.valueOf(i)); 

		if(!("".equals(creFileName) || creFileName.matches("_$") || "5".equals(nameRule))) {
			creFileName += "_";
		}

		if("1".equals(nameRule)) {
			creFileName += tmpSabun;
		} else if("2".equals(nameRule)) {
			creFileName += sabun;
		} else if("3".equals(nameRule)) {
			creFileName += empName;
		} else if("4".equals(nameRule)) {
			creFileName += formatedNow;
		} else if("5".equals(nameRule)) {
			creFileName += "";
		}		
	}
	
	if(Integer.parseInt(sabunCnt) > 1) {
		creFileName += "_외"+(Integer.parseInt(sabunCnt)-1)+"건";
	}

	creFileName = creFileName.replaceAll("/","");	
	creFileName = creFileName.replaceAll("\\\\","");
	creFileName = creFileName.replaceAll("\\.","");
	creFileName = creFileName.replaceAll("&", "");	
    
	if("Y".equals(printOption)) {
		Log.Debug("creFileName============== "+creFileName+" ===============");
		
		invoker.addParameter("mrd_param", "/rfn ["+rdUrl+"/DataServer/rdagent.jsp] /rsn ["+rdAliasName+"] /rreportopt [256] /rp "+rdParam1+rdParam2+rdParam3+rdParam4+rdParam5+rdParam6+rdParam7+rdParam8+rdParam9+rdParam10+rdParam11+rdParam12+rdParam13+rdParam14+rdParam15+rdParam16+rdParam17+" /rv securityKey[]  sKey[null]  gKey[null]  sType[null]  qId[null]  themKey[''] ");
		creFileName += ".pdf";
		try {
			invoker.invoke(serverFilePath+"/"+creFileName);
		}
		catch(InvokerException e) {
			Log.Error("[Exception] " + e);
		}
	
	} else {
		
		for (int i = 0; i < splitSabun.length; i++) {
			invoker.addParameter("mrd_param", "/rfn ["+rdUrl+"/DataServer/rdagent.jsp] /rsn ["+rdAliasName+"] /rreportopt [256] /rp "+rdParam1+rdParam2+rdParam3+"["+splitSabun[i]+"]"+rdParam5+rdParam6+rdParam7+rdParam8+rdParam9+"["+splitSabun[i].replace("'", "")+"]"+rdParam11+rdParam12+rdParam13+rdParam14+rdParam15+rdParam16+rdParam17+" /rv securityKey[]  sKey[null]  gKey[null]  sType[null]  qId[null]  themKey[''] ");
			arrFileName[i] = splitSabun[i].replace("'", "")+"_"+splitName[i].replace("'", "")+".pdf";
			try {
				invoker.invoke(serverFilePath+"/"+arrFileName[i]);
			}
			catch(InvokerException e) {
				Log.Error("[Exception] " + e);
			}
		}	
		
		File zipFile = new File(serverFilePath, creFileName+".zip");
		byte[] buf = new byte[4096];
		
		try(ZipOutputStream out_ = new ZipOutputStream(new FileOutputStream(zipFile))) {
			for(String zipfileName : arrFileName) {

				zipfileName = zipfileName.replaceAll("/","");	
				zipfileName = zipfileName.replaceAll("\\\\","");
				/*시큐어코딩 조치 대상이지만 파일 확장자로인해 주석*/
				//zipfileName = zipfileName.replaceAll("\\.","");
				zipfileName = zipfileName.replaceAll("&", "");	
		        
				File file = new File(serverFilePath, zipfileName);
				
				try(FileInputStream in = new FileInputStream(file)) {
					ZipEntry zf = new ZipEntry(file.getName());
					out_.putNextEntry(zf);
					int len = 0;
					while((len = in.read(buf)) > 0) {
						out_.write(buf, 0, len);
					}
					out_.closeEntry();
				}catch (IOException e) {
		            Log.Error("[Exception] " + e);
		        }
		    }
		} catch (FileNotFoundException e) {
		    Log.Error("[Exception] " + e);
		} catch (IOException e) {
		    Log.Error("[Exception] " + e);
		}
	}
	
	Map rstMap  = new HashMap();
	rstMap = getRecentFile(workYy, tmpSabun);
	
	Map mapCode = new HashMap();
	mapCode.put("Code", 1);
	mapCode.put("Message", "파일생성이 완료되었습니다.");
	
	rstMap.put("Result", mapCode);
	out.print((new org.json.JSONObject(rstMap)).toString());

} else if("downFile".equals(cmd)) {
		
	String downfileName = URLDecoder.decode(request.getParameter("downfileName"));
	BufferedInputStream  inputStream = null;
	BufferedOutputStream outStream = null;	
	
	Log.Debug("============== [파일 다운로드 시작] ===============");
	Log.Debug("downfileName===="+downfileName+" ===============");

	if (downfileName == null || "".equals(downfileName)) {
 		out.println("<script>alert('파일다운로드 중 오류가 발생하였습니다.');</script>");
 		Log.Error("[FileDownload]: downfileName is null");
	} else {
		try {
			downfileName = downfileName.replaceAll("/","");	
			downfileName = downfileName.replaceAll("\\\\","");
			/*시큐어코딩 조치 대상이지만 파일 확장자로인해 주석*/
			//downfileName = downfileName.replaceAll("\\.","");
			downfileName = downfileName.replaceAll("&", "");	
	        
			File file =  new File(serverFilePath, downfileName);
	 	    byte buf[] = new byte[4096];
	 		
	 	    /***** 레진에서 필요 *****/
	 		response.reset();
	 		response.setContentLength((int)file.length());
	 		/*******************/
	
	 		response.setHeader("Content-Type", "application/octet-stream");
	 		response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(downfileName, "UTF-8") + ";");
	 		response.setHeader("Pargma", "no-cache");
	 		response.setHeader("Expires", "-1");
	
	 	    inputStream = new BufferedInputStream(new FileInputStream(file));
	 	    outStream = new BufferedOutputStream(response.getOutputStream());
	
	 	    int numRead;
			if(inputStream != null && outStream != null) {
				while ((numRead = inputStream.read(buf, 0, buf.length)) != -1) {
					outStream.write(buf, 0, numRead);
					outStream.flush();
				}
				out.clear();
				out = pageContext.pushBody();
				outStream.close();
				inputStream.close();
			}
	 	    
	 	} catch(Exception e) {
	 		out.println("<script>alert('파일다운로드 중 오류가 발생하였습니다.');</script>");	
	 		Log.Error("[FileDownload]:" + e.getMessage());
	 	} finally {
	 	    try {
	 	        if (outStream != null) {
	 	            outStream.close();
	 	        }
	 	        if (inputStream != null) {
	 	            inputStream.close();
	 	        }
	 	    } catch (IOException e) {
	 	        Log.Error("Error closing streams: " + e.getMessage());
	 	    }
	 	}
	}
	
	Log.Debug("============== [파일 다운로드 종료] ===============");
}
%>
