<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.exception.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.net.URLEncoder"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.util.zip.ZipOutputStream"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ include file="../common/include/session.jsp"%>

<%@ include file="../../../common_jungsan/jsp/uploadS3/uploadS3_TYPE2.jsp" %>
<%@ page import="java.net.URL" %>

<%!

public void download(HttpServletRequest request, HttpServletResponse response, String filePath, String fileName, boolean isDel) throws Exception {

	File downfile = new File(filePath);
	if(!downfile.exists()) {
		throw new Exception("파일이 존재하지 않습니다");
	}

	InputStream in = null;
	BufferedInputStream  inputStream = null;
    BufferedOutputStream outStream = null;
    
    try {

    	in = new FileInputStream(downfile);
    	inputStream = new BufferedInputStream(in);
    	outStream = new BufferedOutputStream(response.getOutputStream());
        
        /***** 레진에서 필요 *****/
    	response.reset();
    	response.setContentLength((int)downfile.length());
    	/*******************/
    	response.setHeader("Content-Type", "application/octet-stream");
    	response.setHeader("Content-Disposition","attachment;filename="+URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20")+"");
    	response.setHeader("Pargma", "no-cache");
    	response.setHeader("Expires", "-1");
    	
    	byte buf[] = new byte[4096];    	
    	int numRead = 0;    	
        while((numRead = inputStream.read(buf, 0, buf.length)) != -1){
        	outStream.write(buf, 0, numRead);
    		outStream.flush();
        }
        
	} catch (Exception e) {
	        throw new IOException();
	} finally {
		if(outStream != null) outStream.close();    
		if(inputStream != null) inputStream.close();
		if(in != null) in.close();
		/*
		if(isDel) {
        	if(downfile != null) downfile.delete();
        }
		*/
		if(isDel) {
			if(downfile.exists()){
				if(FileDelete(downfile)){
				} else{
					Log.Error("[yeaDataAddFileDownload] 파일 삭제 중 에러");
				}
			}
		}
	}
}

private synchronized boolean FileDelete(File file) {
    return file.delete();
}
%>

<%
	request.setCharacterEncoding(StringUtil.getPropertiesValue("SYS.ENC"));
	
	//로그인 정보 Session취득
    String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
    String ssnSabun = (String)session.getAttribute("ssnSabun");
	
	Map paramMap = StringUtil.getRequestMap(request);
	
	//회사에 따라서 StringUtil의 getRequestMap 세션 정보를 put하는 구문이 빠져있는 곳이 있어서 세션에서 불러온 값으로 재셋팅 - 2020.01.23
	paramMap.put("ssnEnterCd", ssnEnterCd);
	paramMap.put("ssnSabun", ssnSabun);
	
	Map pm =  StringUtil.getParamMapData(paramMap);
	
	Log.Debug("============== [NTSTAX 파일 다운로드 시작] ===============");

	try {
		String pWorkYy = pm.get("pWorkYy").toString();
		String pValue = pm.get("pValue").toString();
		
		JSONArray jsonArr = new JSONArray(pValue);
		JSONObject jsonObj = null;
		
		String dbFileName = "";
		String fileName = "";
		String fileType = "";
		String sabun = "";
		String nfilename = "";
		String serverPath = "";
		String filePath = "";
		String sfileName = "";
		String rfileName = "";
		String fileId  = "";
		String nfsUploadPath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");
		
		if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
			serverPath = nfsUploadPath+StringUtil.getPropertiesValue("HRFILE.PATH");
        } else {
        	serverPath = StringUtil.getPropertiesValue("WAS.PATH")+StringUtil.getPropertiesValue("HRFILE.PATH");
        }
		
		if(jsonArr == null || jsonArr.length() == 0) {
			throw new Exception("잘못된 파라메터");
		} else if(jsonArr.length() == 1){
			//단건 다운
			jsonObj = jsonArr.getJSONObject(0);
			
			dbFileName = jsonObj.getString("dbFileName");
			fileName = jsonObj.getString("fileName");
			fileType = jsonObj.getString("fileType");
			sabun	 = jsonObj.getString("sabun");
			sfileName = jsonObj.getString("attr1");
			fileId = jsonObj.getString("attr2");
			
			if("1".equals(fileType)) {
            	//hrfile/YEA_INCOME/회사코드/년도/
            	filePath = serverPath+"/YEA_INCOME/"+ssnEnterCd+"/"+pWorkYy;
            } else {
            	//hrfile/YEA_ADDFILE/회사코드/년도/
            	filePath = serverPath+"/YEA_ADDFILE/"+ssnEnterCd+"/"+pWorkYy;
            }
			int pos = fileName.lastIndexOf(".");
			String _fileName = fileName.substring(0, pos);
			String ext = fileName.substring( pos + 1 );
				
			nfilename = sabun+"_"+_fileName+"."+ext;				
			
			if("1".equals(fileType)) {
        		filePath = "/YEA_INCOME/"+ssnEnterCd+"/"+pWorkYy;
			} else {
				filePath = "/YEA_ADDFILE/"+ssnEnterCd+"/"+pWorkYy;
			}
        	downloadToS3(filePath, sfileName, fileId, response);
		} else {
			//여러개 다운시에는 압축해서 다운
			Log.Debug("============== [S3 TYPE2 여러 건 다운로드 시작] ===============");
			Date today = new Date();         
			SimpleDateFormat date = new SimpleDateFormat("yyyyMMddHHmmss");
			String now = date.format(today);
			
			byte[] buf = new byte[1024];
			String zipName = "ehr_"+now+".zip";
			
			// 응답 헤더 설정 (ZIP 파일)
	        response.setContentType("application/zip");
	        response.setHeader("Content-Disposition", "attachment; filename=\"" + zipName + "\"");
	        response.setHeader("Content-Transfer-Encoding", "binary");
	        response.setStatus(HttpServletResponse.SC_OK);			
			
	        try (ZipOutputStream zipOutputStream = new ZipOutputStream(response.getOutputStream())) {
				// 파일 이름 중복 체크
		        Set<String> existingEntries = new HashSet<>();
				
				//파일 압축
				for(int i=0; i<jsonArr.length(); i++) {
					jsonObj = jsonArr.getJSONObject(i);
					
					dbFileName = jsonObj.getString("dbFileName");					
					fileName = jsonObj.getString("fileName");					
					fileType = jsonObj.getString("fileType");					
					sabun	 = jsonObj.getString("sabun");					
					sfileName = jsonObj.getString("attr1");					
					fileId = jsonObj.getString("attr2");					
	
					if("1".equals(fileType)) {
						//hrfile/YEA_INCOME/회사코드/년도/
						filePath = "/YEA_INCOME/"+ssnEnterCd+"/"+pWorkYy;
					} else {
						//hrfile/YEA_ADDFILE/회사코드/년도/
						filePath = "/YEA_ADDFILE/"+ssnEnterCd+"/"+pWorkYy;
					}


					String zipEntryName = null;
					String ext = null;
					if(sfileName != null) {
						// 중복된 파일 이름을 피하기 위한 방식
						zipEntryName = sfileName;
			        	ext = zipEntryName.substring(zipEntryName.lastIndexOf("."));
					}
			        int index = 1;
			        		        
			        while (existingEntries.contains(zipEntryName)) {
			            zipEntryName = sfileName.replace(ext, "_" + index + ext);
			            index++;
			        }
			        
			        existingEntries.add(zipEntryName);  // 파일이 추가되었음을 추적
	
					ZipEntry zipEntry = new ZipEntry(zipEntryName);
					zipOutputStream.putNextEntry(zipEntry);
	
					zipFiledownloadToS3(filePath, zipEntryName, fileId, response, zipOutputStream, zipName);
	
					zipOutputStream.closeEntry();
				}
				zipOutputStream.flush();
				zipOutputStream.close();
	        } catch (IOException e) {
	            Log.Error("ZIP 파일 생성 오류: " + e);
	        }
			Log.Debug("============== [S3 TYPE2 여러 건 다운로드 종료] ===============");
		}
		
	} catch(Exception e) {
		out.println("<script>alert('파일다운로드중 오류가 발생하였습니다.');</script>");	
		Log.Error("[yeaDataAddFileDownloadS3_TYPE2]: 파일다운로드중 오류가 발생하였습니다." + e.getMessage());
	}
	
	Log.Debug("============== [NTSTAX 파일 다운로드 종료] ===============");
	
%>