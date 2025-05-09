<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hr.common.logger.Log" %>
<%@ page import="org.json.JSONObject" %>

<%@ page import="org.springframework.core.io.ByteArrayResource" %>
<%@ page import="org.springframework.util.LinkedMultiValueMap" %>
<%@ page import="org.springframework.util.MultiValueMap" %>
<%@ page import="org.springframework.http.*" %>
<%@ page import="org.springframework.web.client.RestTemplate" %>
<%@ page import="org.springframework.web.client.RestClientException" %>
<%@ page import="org.springframework.web.client.HttpServerErrorException" %>
<%@ page import="java.io.InputStream" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.MalformedURLException" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.util.zip.ZipEntry"%>
<%@ page import="java.util.zip.ZipOutputStream"%>
<%@ page import="com.fasterxml.jackson.databind.JsonNode" %>

<%-- 20250416
     연말정산 [시스템사용기준관리]의 파일업로드타입(CPN_YEA_FILE_UPLOAD_TYPE) = 2(AWS S3 kainos프레임워크) 인경우 전용 로직.
     해당 사이트는 pom.xml에 자체 개발한 kainos.framework.aws.s3 라이브러리를 탑재하고 있음. (특정 고객사의 자체 프레임워크이므로 표준 이식 불가)
     해당 사이트의 OuterTryService.java에는 위의 라이브러리를 참조하는 uploadFile과 downloadFile이 별도 구현되어 있음.     
 --%>
<%@ page import="kainos.framework.aws.s3.dto.KainosObjectStorageDto" %>
<%@ page import="kainos.framework.aws.s3.service.KainosObjectStorageService" %>
<%@ page import="kainos.framework.aws.s3.support.enums.ObjectStorage" %>
<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.fileupload.util.Streams" %>
<%@ page import="com.hr.common.upload.outerTry.OuterTryService" %>
<%@ page import="org.springframework.web.context.*" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>

<%@ page import="javax.servlet.*" %>

<%!
public void saveFileToS3(String rWorkDir, String sabun, String fileName, InputStream inStrm, String fileId) throws HttpServerErrorException, RestClientException, Exception {
	
	ServletContext servletContext = getServletContext();
	WebApplicationContext waContext = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext);
	OuterTryService outerTryService = (OuterTryService)waContext.getBean("OuterTryService");

	Log.Debug("saveFileToS3 stary - ");
	Log.Debug("saveFileToS3 rWorkDir - "+rWorkDir);
	Log.Debug("saveFileToS3 sabun - "+sabun);
	Log.Debug("saveFileToS3 fileName - "+fileName);
	Log.Debug("saveFileToS3 fileId - "+fileId);
    
    String tempDir = System.getProperty("java.io.tmpdir");
    File tempFile = new File(tempDir, fileId);

	
	if (inStrm == null) {
		throw new IllegalArgumentException("잘못된 파라미터입니다.");
	}

	if (rWorkDir == null) {
		throw new IllegalArgumentException("Invalid file path");
	}

	if (fileName == null) {
		throw new IllegalArgumentException("Invalid file name");
	}

	if (sabun == null) {
		throw new IllegalArgumentException("Invalid sabun");
	}
	try {
		FileOutputStream fo = new FileOutputStream(tempFile);
        Streams.copy(inStrm, fo, true);
        Log.Debug("Saved to temp file: " + tempFile.getAbsolutePath());
        String temp = outerTryService.uploadFile(tempFile); // AWS S3 kainos프레임워크 전용 사이트는 OuterTryService.java에 해당 메소드가 자체 구현되어 있음.
        Log.Debug("S3 upload result: " + temp);
	}catch(HttpServerErrorException ex) {
		Log.Error("S3 File upload error: "+ ex);
	}catch (RestClientException ex) {
		Log.Error("S3 File upload error: "+ ex);
	}catch(Exception ex){
		Log.Error("S3 File upload error: "+ ex);
	}finally{
		if (tempFile.exists()) {
            tempFile.delete(); // 업로드 후 파일 삭제
        }
	}
}

//InputStream을 바이트 배열로 읽는 메서드
public byte[] readInputStreamToByteArray(InputStream inputStream) throws IOException {
	ByteArrayOutputStream buffer = new ByteArrayOutputStream();
	int nRead;
	byte[] data = new byte[1024];
	while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
		buffer.write(data, 0, nRead);
	}
	buffer.flush();
	return buffer.toByteArray();
}

public void downloadToS3(String filePath, String rFileName, String sFileName, HttpServletResponse response) throws Exception {
	Log.Debug("filePath : "+filePath);
	if (filePath == null || sFileName == null) {
		throw new IllegalArgumentException("잘못된 파라미터입니다.");
	}
	ServletContext servletContext = getServletContext();
	WebApplicationContext waContext = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext);
	OuterTryService outerTryService = (OuterTryService)waContext.getBean("OuterTryService");
	
	String rfileNm = rFileName;
	String sfileNm = sFileName;	

	InputStream inputStream = null;
	BufferedOutputStream outputStream = null;

    String s3Path = String.valueOf("/" + String.valueOf(session.getAttribute("ssnEnterCd")).toLowerCase() + "/yjungsan/unlimited/"+sFileName);
    Log.Debug("s3Path : "+s3Path);
    Log.Debug("rFileName : "+rFileName);
    Log.Debug("sFileName : "+sFileName);
    byte[] file = outerTryService.downloadFile(s3Path); // AWS S3 kainos프레임워크 전용 사이트는 OuterTryService.java에 해당 메소드가 자체 구현되어 있음.
    Log.Debug("file : "+file.length);
	
	try {		
		   inputStream = new ByteArrayInputStream(file);
           outputStream = new BufferedOutputStream(response.getOutputStream());

           response.setHeader("Content-Type", "application/octet-stream");
           response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(rfileNm, "UTF-8").replaceAll("\\+", "%20"));
           response.setHeader("Pragma", "no-cache");
           response.setHeader("Expires", "-1");

           byte[] buffer = new byte[1024];
           int bytesRead;
           while ((bytesRead = inputStream.read(buffer)) != -1) {
               outputStream.write(buffer, 0, bytesRead);
           }
           outputStream.flush();

       } catch (IOException ex) {
           Log.Error("S3 TYPE 2 I/O 예외 발생: " + ex);
           throw ex;
       } finally {

   		if(outputStream != null) outputStream.close();    
   		if(inputStream != null) inputStream.close();
       }
	
}

public void downloadToPdfS3(String filePath, String rFileName, String sFileName, HttpServletResponse response) throws Exception {
	Log.Debug("filePath : "+filePath);
	if (filePath == null || sFileName == null) {
		throw new IllegalArgumentException("잘못된 파라미터입니다.");
	}
	ServletContext servletContext = getServletContext();
	WebApplicationContext waContext = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext);
	OuterTryService outerTryService = (OuterTryService)waContext.getBean("OuterTryService");
	
	String rfileNm = rFileName;
	String sfileNm = sFileName;	

    String s3Path = String.valueOf("/" + String.valueOf(session.getAttribute("ssnEnterCd")).toLowerCase() + "/yjungsan/unlimited/"+sFileName);
    Log.Debug("s3Path : "+s3Path);
    Log.Debug("rFileName : "+rFileName);
    Log.Debug("sFileName : "+sFileName);
    byte[] file = outerTryService.downloadFile(s3Path); // AWS S3 kainos프레임워크 전용 사이트는 OuterTryService.java에 해당 메소드가 자체 구현되어 있음.
    Log.Debug("file : "+file);
	
	try {	
           response.setContentType("application/pdf");
           response.setHeader("Content-Disposition", "inline; filename=\"" + rFileName + "\"");
           response.setContentLength(file.length);
           
        // 파일을 클라이언트에 스트리밍
           OutputStream outStream = response.getOutputStream();
           outStream.write(file);
           outStream.flush();
           outStream.close();     
       } catch (IOException ex) {
           Log.Error("S3 TYPE 2 I/O 예외 발생: " + ex);
           throw ex;
       }
}

public void zipFiledownloadToS3(String filePath , String rFileName, String sFileName, HttpServletResponse response, ZipOutputStream zipOutputStream, String zipname) throws Exception {
	
	if (filePath == null || rFileName == null || sFileName == null) {
		throw new IllegalArgumentException("잘못된 파라미터입니다.");
	}

	String sfilePath = "";
	String rfileNm = rFileName;
	String sfileNm = sFileName;
	
	ServletContext servletContext = getServletContext();
	WebApplicationContext waContext = WebApplicationContextUtils.getRequiredWebApplicationContext(servletContext);
	OuterTryService outerTryService = (OuterTryService)waContext.getBean("OuterTryService");
    	
    String s3Path = String.valueOf("/" + String.valueOf(session.getAttribute("ssnEnterCd")).toLowerCase() + "/yjungsan/unlimited/"+sFileName);


    // S3에서 파일 다운로드 (byte 배열 형태)
    byte[] file = outerTryService.downloadFile(s3Path);	 // AWS S3 kainos프레임워크 전용 사이트는 OuterTryService.java에 해당 메소드가 자체 구현되어 있음.
    Log.Debug("file : "+file.length);
	
	//ZipEntry zipEntry = new ZipEntry(rFileName);
	//zipOutputStream.putNextEntry(zipEntry);
    
    try (ByteArrayInputStream inputStream = new ByteArrayInputStream(file)) {
        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            zipOutputStream.write(buffer, 0, bytesRead);
        }
        
     // 파일을 클라이언트에 스트리밍
        /* zipOutputStream.write(file);
        zipOutputStream.flush();  */
    } catch (IOException ex) {
    	Log.Error("S3 TYPE2 I/O 예외 발생: " + ex);
        throw ex;
    }
}

public String filelist(String dir, String fileId)  throws HttpServerErrorException, RestClientException, Exception {
	
	String downloadUrl = "";
	
	/* String s3ApiBucketName = getOptiPropertiesValue("s3.api.bucket.name");
	String s3ApiUrl = getOptiPropertiesValue("s3.api.url");
	String s3ApiList = getOptiPropertiesValue("s3.api.end.point.list"); */
	String s3ApiBucketName = "";
	String s3ApiUrl = "";
	String s3ApiList = "";
	try{
		// HTTP 요청 URL
	    String downApiUrl 		= s3ApiUrl + s3ApiList;
	    String bucketName 		= s3ApiBucketName;      

	    // Create a RestTemplate
	    RestTemplate restTemplate = new RestTemplate();

	    // Set request headers
	    HttpHeaders headers = new HttpHeaders();
	    headers.set("accept", "application/json");
	    
	    String queryString = "bucketName=" 	+ bucketName 
					        + "&dir=" 		+ dir
					        + "&fileId=" 	+ fileId;
	    downApiUrl += "?" + queryString; 
	    
	    ResponseEntity<JsonNode> responseEntity = restTemplate.exchange(
	    		downApiUrl,
	            HttpMethod.GET,
	            new HttpEntity<JsonNode>(headers),
	            JsonNode.class);
	    
	    // 응답 데이터 가져오기
	    JsonNode responseBody = responseEntity.getBody();
	    
	    if (responseEntity.getStatusCode().is2xxSuccessful()) {
	        JsonNode dataNode = responseBody.get("data");
	        if (dataNode.isArray() && dataNode.size() > 0) {
	            JsonNode item = dataNode.get(0); // Get the first item from the array
	            downloadUrl = item.get("url").asText();
	        }
	    }else {
	    	// 에러 응답 처리
	    	Log.Debug("============================================================");
	    	Log.Debug("HTTP 요청 실패: " + responseEntity.getStatusCode());
	    	Log.Debug("============================================================");
	    }
	}catch (HttpServerErrorException ex) {
		Log.Error("S3 File filelist error: "+ ex);
	}catch (RestClientException ex) {
		Log.Error("S3 File filelist error: "+ ex);
	}catch(Exception ex){
		Log.Error("S3 File filelist error: "+ ex);
	}

	return downloadUrl;
}

public boolean isValidURL(String urlString) {
	try {
		new URL(urlString);
		return true;
	} catch (MalformedURLException e) {
		return false;
	}
}
%>