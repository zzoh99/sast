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

<%!
public void saveFileToS3(String rWorkDir, String sabun, String fileName, InputStream inStrm, String fileId) throws HttpServerErrorException, RestClientException, Exception {
	
	String s3ApiBucketName = getOptiPropertiesValue("s3.api.bucket.name");
	String s3ApiUpload = getOptiPropertiesValue("s3.api.end.point.upload");
	String s3ApiUrl = getOptiPropertiesValue("s3.api.url");
	String s3ApiDownload = getOptiPropertiesValue("s3.api.end.point.download");
	String s3ApiList = getOptiPropertiesValue("s3.api.end.point.list");
	
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
		
	    // HTTP 요청 엔티티 생성
	    MultiValueMap<String, Object> body = new LinkedMultiValueMap<String, Object>();
	    body.add("bucketName", 		s3ApiBucketName); 				//버컷명
	    body.add("saveFileName", 	fileName); 					//파일저장명
	    body.add("dir", 			rWorkDir); 							//경로
	    body.add("crempid", 		sabun);  						//파일생성자
	    body.add("fileId", 			fileId);					//파일문서번호
	    body.add("isPublic", 		"N");    						//버킷공개여부

	    // InputStream을 바이트 배열로 읽어서 전송
	    byte[] fileBytes = readInputStreamToByteArray(inStrm);
	    body.add("file", new ByteArrayResource(fileBytes) {
	        @Override
	        public String getFilename() {
	            return fileName; // Set the filename
	        }
	    });
	    
	    // HTTP 요청 URL
	    String apiUrl 		= s3ApiUrl + s3ApiUpload;
	    // RestTemplate 인스턴스 생성
	    RestTemplate restTemplate = new RestTemplate();
	    
	    // 요청 헤더 설정
	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
	    headers.add("accept", "*/*");
	    
	    // HTTP 요청 엔티티 생성
	    HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(body, headers);
	    ResponseEntity<JSONObject> responseEntity = restTemplate.exchange(
	    		apiUrl, 
	    		HttpMethod.POST, 
	    		entity, 
	    		JSONObject.class);
	    
	    // 응답 처리
	    if (responseEntity.getStatusCodeValue() == HttpURLConnection.HTTP_OK) {
	        // 성공적인 응답 처리
	    	JSONObject responseBody = responseEntity.getBody();
	        	            
	    } else {
	        // 에러 응답 처리
	        Log.Error("============================================================");
	        Log.Error("file upload failed!"+ responseEntity.getStatusCode());
	        Log.Error("============================================================");
	    }
	}catch(HttpServerErrorException ex) {
		Log.Error("S3 File upload error: "+ ex);
	}catch (RestClientException ex) {
		Log.Error("S3 File upload error: "+ ex);
	}catch(Exception ex){
		Log.Error("S3 File upload error: "+ ex);
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
	
	if (filePath == null || sFileName == null) {
		throw new IllegalArgumentException("잘못된 파라미터입니다.");
	}
	
	String sfilePath = sanitizeFilePath(filePath);
	//String rfileNm = sanitizeFileName(rFileName);
	//String sfileNm = sanitizeFileName(sFileName);
	String rfileNm = rFileName;
	String sfileNm = sFileName;
	String downloadUrl 	= filelist(filePath, sfileNm);
	HttpURLConnection connection = null;
	
	InputStream in = null;
	BufferedInputStream inputStream = null;
	BufferedOutputStream outputStream = null;
	
	if(!"".equals(downloadUrl) && isValidURL(downloadUrl)) {
		try {
			in = new URL(downloadUrl).openStream();
			inputStream = new BufferedInputStream(in);
            outputStream = new BufferedOutputStream(response.getOutputStream());

            connection = (HttpURLConnection) new URL(downloadUrl).openConnection();
            int responseCode = connection.getResponseCode();

            if (responseCode != HttpURLConnection.HTTP_OK) {
                throw new IOException("HTTP 응답 코드가 OK가 아닙니다: " + responseCode);
            }

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
            Log.Error("I/O 예외 발생: " + ex);
            throw ex;
        } finally {
            // 연결 닫기
            if (connection != null) {
                connection.disconnect();
            }

    		if(outputStream != null) outputStream.close();    
    		if(inputStream != null) inputStream.close();
    		if(in != null) in.close();
        }
	}
}

public void downloadPdfToS3(String filePath, String rFileName, String sFileName, HttpServletResponse response) throws Exception {
	
	if (filePath == null || sFileName == null) {
		throw new IllegalArgumentException("잘못된 파라미터입니다.");
	}
	
	String rfileNm = rFileName;
	String sfileNm = sFileName;
	String downloadUrl 	= filelist(filePath, sfileNm);
	HttpURLConnection connection = null;
	
	InputStream in = null;
	BufferedInputStream inputStream = null;
	BufferedOutputStream outputStream = null;
	
	if(!"".equals(downloadUrl) && isValidURL(downloadUrl)) {
		try {
			in = new URL(downloadUrl).openStream();
			inputStream = new BufferedInputStream(in);
            outputStream = new BufferedOutputStream(response.getOutputStream())

            connection = (HttpURLConnection) new URL(downloadUrl).openConnection();
            int responseCode = connection.getResponseCode();

            if (responseCode != HttpURLConnection.HTTP_OK) {
                throw new IOException("HTTP 응답 코드가 OK가 아닙니다: " + responseCode);
            }

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
            Log.Error("I/O 예외 발생: " + ex);
            //throw ex;
        } finally {
            // 연결 닫기
            if (connection != null) {
                connection.disconnect();
            }

    		if(outputStream != null) outputStream.close();    
    		if(inputStream != null) inputStream.close();
    		if(in != null) in.close();
        }
	} 
}

public void zipFiledownloadToS3(String filePath , String rFileName, String sFileName, HttpServletResponse response, ZipOutputStream zipOutputStream, String zipname) throws Exception {
	
	if (filePath == null || rFileName == null || sFileName == null) {
		throw new IllegalArgumentException("잘못된 파라미터입니다.");
	}

	String sfilePath = sanitizeFilePath(filePath);
	//String rfileNm = sanitizeFileName(rFileName);
	//String sfileNm = sanitizeFileName(sFileName);
	String rfileNm = rFileName;
	String sfileNm = sFileName;
	String downloadUrl = filelist(sfilePath, sfileNm);
	HttpURLConnection connection = null;

	if (downloadUrl.isEmpty() || !isValidURL(downloadUrl)) {
		Log.Error("S3 File download error: Invalid or empty URL");
		throw new MalformedURLException("잘못된 URL 형식이거나 URL이 비어있습니다.");
	}

	InputStream in = null;
	BufferedInputStream inputStream = null; 
			
	try {
		in = new URL(downloadUrl).openStream();
		inputStream = new BufferedInputStream(in) ;
		
        connection = (HttpURLConnection) new URL(downloadUrl).openConnection();
        int responseCode = connection.getResponseCode();

        if (responseCode != HttpURLConnection.HTTP_OK) {
            throw new IOException("HTTP 응답 코드가 OK가 아닙니다: " + responseCode);
        }

        response.setHeader("Content-Type", "application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=" +
                URLEncoder.encode(zipname, "UTF-8").replaceAll("\\+", "%20"));
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "-1");

        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            zipOutputStream.write(buffer, 0, bytesRead);
        }
    } catch (IOException ex) {
    	Log.Error("I/O 예외 발생: " + ex);
        throw ex;
    } finally {
        // 연결 닫기
        if (connection != null) {
            connection.disconnect();
        }
        
		if(inputStream != null) inputStream.close();
		if(in != null) in.close();

    }

}

public String filelist(String dir, String fileId)  throws HttpServerErrorException, RestClientException, Exception {
	
	String downloadUrl = "";
	
	String s3ApiBucketName = getOptiPropertiesValue("s3.api.bucket.name");
	String s3ApiUrl = getOptiPropertiesValue("s3.api.url");
	String s3ApiList = getOptiPropertiesValue("s3.api.end.point.list");
	
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

public boolean deleteFileToS3(String filePath, String fileId) throws Exception {
	
	String listEndpoint = getOptiPropertiesValue("s3.api.end.point.delete");
	String apiUrl 		= getOptiPropertiesValue("s3.api.url") + listEndpoint;
	String bucketName 	= getOptiPropertiesValue("s3.api.bucket.name");
	
	int dotIndex = fileId.lastIndexOf(".");
	if(dotIndex > 0){
		fileId = fileId.substring(0, dotIndex);
	}
	String key 			= filePath.substring(1)+"/"+fileId;
	
	boolean flag = true;
	
	// Create a JSONObject for request parameters
	org.json.simple.JSONObject requestParams = new org.json.simple.JSONObject();
	requestParams.put("bucketName", bucketName);
	requestParams.put("key", key);
	
	// Create a RestTemplate
	RestTemplate restTemplate = new RestTemplate();
	// Set request headers
	HttpHeaders headers = new HttpHeaders();
	headers.set("accept", "*/*");
	//headers.set("Origin", "http://localhost"); 
	headers.set("Access-Control-Request-Method", "GET, POST, PUT, DELETE"); // 허용할 HTTP 메서드 설정
	headers.set("Access-Control-Request-Headers", "authorization, content-type"); // 허용할 헤더 설정
	//headers.set("Authorization", "Bearer your-access-token"); // 필요한 경우 인증 정보 설정

	// Create an HttpEntity with the request body and headers
	HttpEntity<String> requestEntity = new HttpEntity<String>(requestParams.toString(), headers);

	// Create the queryString
	String queryString = "bucketName=" + URLEncoder.encode(bucketName, "UTF-8") + "&key=" + URLEncoder.encode(key, "UTF-8");
	apiUrl += "?" + queryString;

	ResponseEntity<org.json.simple.JSONObject> responseEntity = restTemplate.exchange(
			apiUrl,
			HttpMethod.DELETE,
			new HttpEntity<org.json.simple.JSONObject>(headers),
			org.json.simple.JSONObject.class);

	// 응답 처리
	if (responseEntity.getStatusCodeValue() == 200) {
		// 성공적인 응답 처리
		org.json.simple.JSONObject responseBody = responseEntity.getBody();
	} else {
		flag = false;
		// 에러 응답 처리
		Log.Debug("============================================================");
		Log.Debug("HTTP 요청 실패: " + responseEntity.getStatusCode());
		Log.Debug("============================================================");
	}
	
	return flag;
}
%>