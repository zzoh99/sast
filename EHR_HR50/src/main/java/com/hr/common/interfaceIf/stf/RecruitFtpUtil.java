package com.hr.common.interfaceIf.stf;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Value;

import com.hr.common.logger.Log;
import com.hr.common.util.ftp.FtpUtil;

public class RecruitFtpUtil {
	
	public static String TYPE_RECRUIT 	= "RECRUIT";
	public static String TYPE_EHR 		= "EHR";
	
	@Value("${disk.path}") public static String DISK_PATH;
	@Value("${stf.path}") public static String STF_PATH;
	
	private static String JNDI_EHR;
	private static String JNDI_REC;
	
	public RecruitFtpUtil() throws Exception{
		InputStream is = getClass().getResourceAsStream("/opti.properties");
		
		Properties props = new Properties();
		try {
			props.load(is);
		}catch (Exception ex) {
			//ex.printStackTrace();
			throw new Exception(ex.toString());
		}
		
		JNDI_EHR = props != null && props.getProperty("jndi.hrDB") != null ? props.getProperty("jndi.hrDB").trim():"";
		JNDI_REC = props != null && props.getProperty("jndi.hiDB") != null ? props.getProperty("jndi.hiDB").trim():"";
	}
	
	public static int imgFileFtpDownload(String keyCol, String keyVal, String type){
		int result = 0;
		
		try {
			String fileRootPath = DISK_PATH.trim();
			String downRootPath = STF_PATH.trim();
			
			//해당 테이블의 이미지 path 정보 Get
			List<Map<String,Object>> photoList = new ArrayList<Map<String,Object>>();
			photoList = getPhotoInfoList(keyCol, keyVal, type);
			
			//이미지파일 FTP다운로드
			for(Map<String,Object> photo: photoList){
				if(!photo.isEmpty()){
					String photoInfo = (String)photo.get("photoInfo");
					if( photoInfo != null && !"".equals(photoInfo) ){
						String fileName = photoInfo.substring(photoInfo.lastIndexOf("/") + 1);
						String subPath = photoInfo.substring(photoInfo.lastIndexOf("recfile"), photoInfo.length() - fileName.length());
						String targetPath = downRootPath + subPath;
						String filePath = fileRootPath + subPath;
						result = result + FtpUtil.download(filePath, fileName, targetPath);
					}
				}
			}			
		} catch(Exception e) {
			Log.Error("======== RecruitFtpUtil imgFileFtpDownload exception:"+e);
		}
		
		return result;
	}
	
	public static int imgFileFtpUpload(String tableName, String targetColumn, String keyCol, String keyVal, String type){
		
		int result = 0;
		
		try{
			String localePath = DISK_PATH.trim();
			String remotePath = STF_PATH.trim();
			
			//해당 테이블의 이미지 path 정보 Get
			List<Map<String,Object>> srcList = new ArrayList<Map<String,Object>>();
			srcList = extractSrcPath(tableName, targetColumn, keyCol, keyVal, type);
			
			//이미지파일 FTP전송 후 전송결과 UPDATE
			for(Map<String,Object> src: srcList){
				if(!src.isEmpty()){
					String fullPath = (String)src.get("src");
					String srchKeyVal = (String)src.get("keyVal");
					
					if(fullPath != null && !"".equals(fullPath)){
						String fileName = fullPath.substring(fullPath.lastIndexOf("/") + 1);
						String recPath = fullPath.substring(fullPath.lastIndexOf("recfile"), fullPath.length() - fileName.length());
						
						String localeFilePath = localePath + recPath;
						String remoteFilePath = remotePath + recPath;	

						try {
							int ftpResult = FtpUtil.upload(localeFilePath, remoteFilePath, fileName);
							
							//키값을 넘겨 받지 않은 경우에만 전송결과 UPDATE
							if( ftpResult > 0 && "".equals( keyVal) ){
								RecruitFtpUtil.afterFtpUpload(tableName, keyCol, srchKeyVal, type);
								result = result + ftpResult;
							}
						} catch (Exception e) {
							// TODO Auto-generated catch block
							Log.Debug(e.getLocalizedMessage());
						}
					}
					
					

				}
				
			}			
		}catch(Exception e){
			Log.Error("======== RecruitFtpUtil imgFileFtpUpload exception:"+e);
		}
		
		return result;

	}
	
	public static List<Map<String,Object>> getPhotoInfoList(String keyCol, String keyVal, String type) {
		DataSource ds = null;
		Context ctxt = null;
		
		String TYPE_JNDI = null;
		
		if( TYPE_EHR == type ){
			TYPE_JNDI = JNDI_EHR;
		}else if( TYPE_RECRUIT == type ){
			TYPE_JNDI = JNDI_REC;
		}
		
		Connection conn    = null;
		ResultSet  rs          = null;
		PreparedStatement psmt = null;
		
		List<Map<String,Object>> infoList = new ArrayList<Map<String,Object>>();
		
		try {
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(TYPE_JNDI);
			conn = ds.getConnection();
			
			StringBuffer sbQuery = new StringBuffer();
			sbQuery.append("SELECT  PHOTO_INFO ").append("  FROM TSTF410").append(" WHERE " + keyCol + " = " + keyVal);
			
			psmt = conn.prepareStatement(sbQuery.toString());
			rs = psmt.executeQuery();
			
			if ( rs != null ) {
				while(rs.next()){
					Map<String,Object> tempMap = new HashMap<String,Object>();
					String photoPath = rs.getString("PHOTO_INFO");
					tempMap.put("photoInfo", photoPath);
					infoList.add(tempMap);
				}
			}
		} catch(Exception e){
			Log.Error("======== RecruitFtpUtil conn exception:"+e);
			if(conn != null){ try { conn.rollback(); } catch (SQLException e1) { Log.Debug(e1.getLocalizedMessage()); } }
		} finally {
			if (rs != null) { try { rs.close(); } catch (SQLException e) { Log.Debug(e.getLocalizedMessage()); } }
			if (psmt != null) { try { psmt.close(); } catch (SQLException e) { Log.Debug(e.getLocalizedMessage());} }
			if (conn != null){ try { conn.close(); } catch (SQLException e) { Log.Debug(e.getLocalizedMessage()); } }
		}
		
		return infoList;
	}


	public static List<Map<String,Object>> extractSrcPath(String tableName, String targetColumn, String keyCol, String keyVal, String type){
		DataSource ds = null;
		Context ctxt = null;
		String TYPE_JNDI = null;
		if( TYPE_EHR == type ) {
			TYPE_JNDI = JNDI_EHR;
		} else if( TYPE_RECRUIT == type ) {
			TYPE_JNDI = JNDI_REC;
		}
		
		Connection conn    = null;
		ResultSet  rs          = null;
		PreparedStatement psmt = null;
		Pattern imgPattern = Pattern.compile("(?i)< *[img][^\\>]*[src] *= *[\"\']{0,1}([^\"\'\\ >]*)");
		List<Map<String,Object>> srcList = new ArrayList<Map<String,Object>>();
		
		try {
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(TYPE_JNDI);
			conn = ds.getConnection();
			
			List<Map<String,Object>> contentList = new ArrayList<Map<String,Object>>();
			
			StringBuffer sbQuery = new StringBuffer();
			sbQuery.append("SELECT  " + targetColumn)
				.append("          ," + keyCol + " AS KEYCOL" )
				.append("  FROM " + tableName );
			
			if ( "".equals(keyVal) ){
				sbQuery.append(" WHERE FTP_UPLOAD_YN = 'N' ");
			}else{
				sbQuery.append(" WHERE " + keyCol + " = " + keyVal + " ");
			}

			psmt = conn.prepareStatement(sbQuery.toString());
			rs = psmt.executeQuery();
			
			if ( rs != null ) {
				while(rs.next()){
					Map<String,Object> tempMap = new HashMap<String,Object>();
					tempMap.put(targetColumn, rs.getString(targetColumn));
					tempMap.put("keyVal", rs.getString("KEYCOL"));
					contentList.add(tempMap);
				}
			}
			
			
			for(Map<String,Object> mp : contentList) {
				String contents = (String)mp.get(targetColumn);
				String srchKeyVal = (String)mp.get("keyVal");
				Matcher captured = imgPattern.matcher(contents); 
				
				while(captured.find()){
					if( captured.group(1).indexOf("recfile") > 0 ){
						Map<String,Object> tempMap = new HashMap<String,Object>();
						tempMap.put("src", captured.group(1));
						tempMap.put("keyVal", srchKeyVal);
					    srcList.add(tempMap);	
					}
				}
			}
					
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			try { if (conn != null) conn.rollback(); } catch (SQLException e1) { Log.Error(e1.getLocalizedMessage()); }			
		} finally {
			if (rs != null) { try { rs.close(); } catch (SQLException e) { Log.Error(e.getLocalizedMessage()); } }
			if (psmt != null) { try { psmt.close(); } catch (SQLException e) { Log.Error(e.getLocalizedMessage()); } }
			if (conn != null) { try { conn.close(); } catch (SQLException e) { Log.Error(e.getLocalizedMessage()); } }
		}
		return srcList;
	}
	
	public static void afterFtpUpload(String tableName, String keyCol, String keyVal, String type){
		DataSource ds = null;
		Context ctxt = null;
		
		String TYPE_JNDI = null;
		
		if( TYPE_EHR == type ){
			TYPE_JNDI = JNDI_EHR;
		} else if( TYPE_RECRUIT == type ){
			TYPE_JNDI = JNDI_REC;
		}
		
		Connection conn    = null;
		PreparedStatement psmt = null;
		
		try {
			ctxt = new InitialContext();
			ds = (DataSource)ctxt.lookup(TYPE_JNDI);
			conn = ds.getConnection();
			StringBuffer sbQuery = new StringBuffer();
			sbQuery.append("UPDATE " + tableName)
				.append("      SET FTP_UPLOAD_YN = 'Y' " )
				.append("    WHERE " + keyCol + " = '" + keyVal + "'")
				.append("      AND FTP_UPLOAD_YN = 'N' " );

			psmt = conn.prepareStatement(sbQuery.toString());
			psmt.executeQuery();
			
		} catch(Exception e){
			Log.Error("======== RecruitFtpUtil conn exception:"+e);
		} finally {
			if (psmt != null) { try { psmt.clearBatch(); psmt.close(); } catch (SQLException e) { Log.Debug(e.getLocalizedMessage()); } }
			if (conn != null) { try { conn.close(); } catch (SQLException e) { Log.Debug(e.getLocalizedMessage()); } }
		}
	}
}
