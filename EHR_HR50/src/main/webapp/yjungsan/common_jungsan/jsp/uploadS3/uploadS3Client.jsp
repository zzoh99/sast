<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.hr.common.logger.Log" %>

<%@ page import="java.io.IOException" %>
<%@ page import="com.amazonaws.services.s3.AmazonS3Client" %>
<%@ page import="com.amazonaws.services.s3.model.PutObjectRequest" %>
<%@ page import="com.amazonaws.auth.BasicAWSCredentials" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.io.File" %>

<%!
	public void uploadFileToS3Client(FileItem fileItem) throws IOException {
	
		String s3AcessKey = StringUtil.getOptiPropertiesValue("aws.s3.access.key");
		String s3SecretKey = StringUtil.getOptiPropertiesValue("aws.s3.secret.key");
		String s3BucketName = StringUtil.getOptiPropertiesValue("aws.s3.bucket.name");
		
        // AWS S3 클라이언트 생성
        AmazonS3Client s3Client = new AmazonS3Client(new BasicAWSCredentials(s3AcessKey, s3SecretKey));


        String fileName = fileItem.getName();

        // S3에 업로드할 경로 설정
        String key = "yjungsan/test/" + fileName;

        // 업로드할 파일의 임시 경로 얻기
        try {
		    // 업로드할 파일의 임시 경로 얻기
		    File tempFile = File.createTempFile("temp", null);
		 	// S3에 파일 업로드
	        s3Client.putObject(new PutObjectRequest(s3BucketName, key, tempFile));

	        if (tempFile != null) tempFile.delete();
		} catch (IOException e) {
		    // 예외 처리 코드
		    Log.Error(e.getMessage());
		}

    }
%>