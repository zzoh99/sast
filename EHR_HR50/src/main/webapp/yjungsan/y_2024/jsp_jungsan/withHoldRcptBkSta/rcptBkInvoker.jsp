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

<%@ include file="../../../common_jungsan/jsp/pathPropRd.jsp" %>

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
		Log.Error("checking exists.... " + e.getMessage());
		return false;
	} finally {
        // 연결 닫기
        if (con != null) {
        	con.disconnect();
        }
    }
}

private void directoryClean(String serverFilePath) throws Exception {
	
	File directory = new File(serverFilePath);
	File[] files = directory.listFiles(File::isFile);
	
	try{
		for (File file : files) {
			file.delete();
		}	
	} catch (Exception e) {
		Log.Error("delete fileDir....  " + e);
		throw new Exception("파일 디렉토리 삭제중 오류 발생.");
	}
}



private Map getRecentFile(String pWorkYy, String tmpSabun,String ssnEnterCd) throws Exception {
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
                               + "/YEA/rcptBk/"  + ssnEnterCd + "/" +  workYy + "/" + sabun ;
	
   	File directory = new File(serverFilePath);
	File[] files = directory.listFiles(File::isFile);
	long lastModifiedTime = Long.MIN_VALUE;
	long fileSize = 0;
    long zipLastModifiedTime = Long.MIN_VALUE;
	long zipFileSize = 0;
	String fileName;
    String extension;
    
	File chosenFile = null;
	File zipFile = null;
	
	Map<String, Object> rstMap = new HashMap<>();
	
	try {
		if (files != null) {
			for (File file : files) {
				if (file.lastModified() > lastModifiedTime) {
					chosenFile = file;
					lastModifiedTime = file.lastModified();
					fileSize = file.length();
				}
				// zip파일이 있을시에는 zip파일이 우선
				fileName = file.getName();
				extension = fileName.substring(fileName.lastIndexOf(".") + 1);
				
				if("zip".equals(extension)) {
					zipFile = file;
					zipLastModifiedTime = file.lastModified();
					zipFileSize = file.length();
				}
			}
			
			if(zipFileSize > 0) {
				chosenFile = zipFile;
				lastModifiedTime = zipLastModifiedTime;
				fileSize = zipFileSize;
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

private Map CheckDisk(String pWorkYy, String sabunCnt, String printOption, String tmpSabun,String ssnEnterCd) throws Exception {
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
                               + "/YEA/rcptBk/" + ssnEnterCd + "/" +  workYy + "/" + sabun ;
	
	//용량체크
	Map<String, Object> rstMap = new HashMap<>();
	
	try {
		File diskCheck = new File(serverFilePath);
	    
	    long usableSpace = diskCheck.getUsableSpace();
	    long totFile = Integer.parseInt(sabunCnt) * 200;
	    
	    usableSpace = (usableSpace/(1024 * 1024));
	    
	    Log.Debug("usableSpace============== "+usableSpace+" ===============");
	    Log.Debug("totFile============== "+totFile+" ===============");
		
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
private void fileDir(String pWorkYy, String tmpSabun,String ssnEnterCd) throws Exception {
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
                               + "/YEA/rcptBk/"  + ssnEnterCd + "/" +  workYy + "/" + sabun ;
	
	try{
		File dir = new File(serverFilePath);
		
		if(!dir.exists()) {
			dir.mkdirs();
		}
	} catch (Exception e) {
		Log.Error("checking fileDir....  " + e);
		throw new Exception("파일 디렉토리 생성중 오류 발생.");
	}
}

private Map cntChk(String pWorkYy, String tmpSabun,String ssnEnterCd) throws Exception {
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
                               + "/YEA/rcptBk/"  + ssnEnterCd + "/" +  workYy + "/" + sabun ;
	
	Map<String, Object> rstMap = new HashMap<>();
	int fileCnt = 0;
	
	try{
		File dir = new File(serverFilePath);
		File[] files = dir.listFiles();
	
		fileCnt = (files == null) ? 0 : files.length;
		
		rstMap.put("fileCnt", fileCnt);
		
	} catch (Exception e) {
		Log.Error("checking cntChk....  " + e);
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

String workYy = String.valueOf(request.getParameter("searchWorkYy"));
String tmpSabun  = String.valueOf(session.getAttribute("ssnSabun"));
String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");

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
                           + "/YEA/rcptBk/"  + ssnEnterCd + "/" +  workYy + "/" + tmpSabun ;

if("onload".equals(cmd)) {
	
Map rstMap  = new HashMap();
	
	try {
		rstMap = rdChk(rdBaseUrl + rdBasePath + URLDecoder.decode(request.getParameter("rdMrd")));
	} catch(Exception e) {
		throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
	}
	
	if(rstMap.get("fileExist") == "Y") {
		try {
			rstMap = getRecentFile(workYy, tmpSabun,ssnEnterCd);
		} catch(Exception e) {
			throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
		}
	}
	
	out.print((new org.json.JSONObject(rstMap)).toString());
	    
} else if("CheckDisk".equals(cmd)) {
	
	fileDir(workYy, tmpSabun,ssnEnterCd);
	
	Map rstMap  = new HashMap();
	
	try {
		rstMap = CheckDisk(workYy, sabunCnt, printOption, tmpSabun,ssnEnterCd);
	} catch(Exception e) {
		throw new Exception("파일 정보를 가져오는 중에 오류가 발생했습니다: " + e.getMessage());
	}
	
	out.print((new org.json.JSONObject(rstMap)).toString());
	
} else if("cntChk".equals(cmd)) {
	
	Map rstMap = new HashMap();
	
	try {
		rstMap = cntChk(workYy, tmpSabun,ssnEnterCd);
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
	
	directoryClean(serverFilePath);
	
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
	invoker.addParameter("mrd_path", rdBaseUrl + rdBasePath + rdMrd);
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
    
	Log.Debug("creFileName============== "+creFileName+" ===============");

	Integer retCode = 1;
	String  retMsg  = "파일생성이 완료되었습니다.";
	
	String rdParam1 = "";
	String rdParam2 = "";
	for(int i=1; i<16; i++) {
		rdParam1 = request.getParameter("rdParam" + Integer.toString(i)) ;
		
		if (!"".equals(rdParam1) && rdParam1!=null) {			
			
			Log.Debug("rdParam" + Integer.toString(i) + "============== " + URLDecoder.decode(rdParam1) + "    "+ rdParam1);
			
			// 개별파일 생성이면서 파라미터가 사번이면..
			if ( "N".equals(printOption) && i==4 ) {
				rdParam2 += "[&#'사번'&#]"; // ''로 엮인 놈 
		    } else if ( "N".equals(printOption) && i==9 ) {
				rdParam2 += "[&#사번&#]";   // ''로 엮이지 않은 놈
			} else if ( "N".equals(printOption) && i==10 ) {
				rdParam2 += "[1]";   // 정렬순서
			} else { 
				rdParam2 += URLDecoder.decode(rdParam1);
			}
		}
	}
	rdParam1  = "/rfn ["+rdUrl+"/DataServer/rdagent.jsp] ";
	rdParam1 += "/rsn ["+rdAliasName+"] ";
	rdParam1 += "/rreportopt [256] ";
	rdParam1 += "/rp " + rdParam2 ;
	rdParam1 += "/rv securityKey[]  sKey[null]  gKey[null]  sType[null]  qId[null]  themKey[''] " ;
		
	if("Y".equals(printOption)) {
		// 단일파일이면
		invoker.addParameter("mrd_param", "/rfn ["+rdUrl+"/DataServer/rdagent.jsp] /rsn ["+rdAliasName+"] /rreportopt [256] /rp "+rdParam2+" /rv securityKey[]  sKey[null]  gKey[null]  sType[null]  qId[null]  themKey[''] ");
		creFileName += ".pdf";
		
		Log.Debug(rdParam1);
			
		try {
			invoker.invoke(serverFilePath+"/"+creFileName);
		}
		catch(InvokerException e) {
			Log.Error("[Exception] " + e);
		}
	
	} else {
		// 개별파일 생성이면
		String rdParam00 = "";
		String rdParamJ = "";
		
		for (int i = 0; i < splitSabun.length; i++) {
			/// 파라미터 중 개별 사번 치환. ''로 엮인 놈
			rdParamJ = "";
			for(int j=1; j<16; j++) {
				rdParam00 = request.getParameter("rdParam" + Integer.toString(j)) ;
				
				if (!"".equals(rdParam00) && rdParam00!=null) {			
					// 개별파일 생성이면서 파라미터가 사번이면..
					if(j != 4) {
						rdParamJ += URLDecoder.decode(rdParam00);	
					} else {
						rdParamJ += "[";
						rdParamJ += splitSabun[i];
						rdParamJ += "]";
					}
				}
			}
			
			
			if (rdParam1 != null && !"".equals(rdParam1) && splitSabun[i] != null && !"".equals(splitSabun[i]) && splitName[i] != null && !"".equals(splitName[i])) {
				rdParam2 = rdParam1.replaceAll("&#'사번'&#",splitSabun[i]);
				// 파라미터 중 개별 사번 치환. ''로 엮이지 않은 놈
				splitSabun[i] = splitSabun[i].replaceAll("'","");
				splitSabun[i] = splitSabun[i].replaceAll("&amp;quot;","");

				splitName[i]  = splitName[i].replaceAll("'","");
				splitName[i]  = splitName[i].replaceAll("&amp;quot;","");


				rdParam2 = rdParam2.replaceAll("&#사번&#",splitSabun[i]);
				invoker.addParameter("mrd_param", "/rfn ["+rdUrl+"/DataServer/rdagent.jsp] /rsn ["+rdAliasName+"] /rreportopt [256] /rp "+rdParamJ+" /rv securityKey[]  sKey[null]  gKey[null]  sType[null]  qId[null]  themKey[''] ");
			}


			Log.Debug(rdParam2);
			
			/// 사용자가 지정한 명명규칙 적용
			arrFileName[i] = "";			
			for(int j=1; j<5; j++) {
				nameRule = request.getParameter("nameRule" + String.valueOf(j)); 
	
				if(!("".equals(arrFileName[i]) || arrFileName[i].matches("_$") || "5".equals(nameRule))) {
					arrFileName[i] += "_";
				}
	
				if("1".equals(nameRule)) {
					arrFileName[i] += tmpSabun;
				} else if("2".equals(nameRule)) {
					arrFileName[i] += splitSabun[i];
				} else if("3".equals(nameRule)) {
					arrFileName[i] += splitName[i];
				} else if("4".equals(nameRule)) {
					arrFileName[i] += formatedNow;
				} else if("5".equals(nameRule)) {
					arrFileName[i] += "";
				}		
			}
			arrFileName[i] += ".pdf";
			
			try {
				invoker.invoke(serverFilePath+"/"+arrFileName[i]);
			}
			catch(InvokerException e) {
				retCode = -1;
				retMsg  = splitSabun[i] + "(" + splitName[i] + ") >> " + e.getMessage();	
		 		Log.Error("InvokerException:" + e.getMessage());
		 		break;
			}
		}
		
		if (retCode > 0) {
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
						retCode = -1;
	 					retMsg  = e.getMessage();	
	 			 		Log.Error("IOException:" + e.getMessage()); 			 		
	 			 		break;
			        }
			    }
			} catch (FileNotFoundException e) {
				retCode = -1;
				retMsg  = e.getMessage();	
			 	Log.Error("FileNotFoundException:" + e.getMessage());
			} catch (IOException e) {
				retCode = -1;
				retMsg  = e.getMessage();	
			 	Log.Error("IOException:" + e.getMessage());
			}
		}
	}
	
	Map rstMap  = new HashMap();
	if (retCode > 0) {
		rstMap = getRecentFile(workYy, tmpSabun,ssnEnterCd);
	} else {
		rstMap.put("downFileName", "");
		rstMap.put("downFileDate", "");
		rstMap.put("downFileSize", "");		
	}
	
	Map mapCode = new HashMap();
	mapCode.put("Code", retCode);
	mapCode.put("Message", retMsg);
	
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
	 	    while((numRead = inputStream.read(buf, 0, buf.length)) != -1){
	 	    	outStream.write(buf, 0, numRead);
	 			outStream.flush();
	 	    }
	 		out.clear();
	 		out = pageContext.pushBody();
	 		outStream.close();
	 	    inputStream.close();
	 	    
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
