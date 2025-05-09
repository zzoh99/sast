package com.hr.common.util.fileupload.impl;

import com.hr.common.util.classPath.ClassPathUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.ResourceBundle;

public class FileUploadConfig {

	public static final String POSTFIX_STORE_TYPE = "storeType";
	public static final String POSTFIX_STORE_PATH = "storePath";
	public static final String POSTFIX_NAME_PATTERN = "nmPattern";
	public static final String POSTFIX_FILE_SIZE = "fileSize";
	public static final String POSTFIX_MIME_TYPE = "mimeType";
	public static final String POSTFIX_EXT_EXTENSION = "extExtension";
	public static final String POSTFIX_MIME_EXTENSION = "mimeExtension";
	public static final String POSTFIX_FILE_COUNT = "fileCount";
	public static final String POSTFIX_MULTIPLE = "multiple";
	
	private final String PREFIX_COMMON = "common";
	private final String TEMP_DIR = "common.temp.path";
	private final String DISK_PATH = "disk.path";

	private final String CONTEXT_PATH = "context.path";


	private ResourceBundle rb = null;
	private ResourceBundle optiRb = null;
	private String uploadType = null;

	public FileUploadConfig(String uploadType) {
		this.rb = ResourceBundle.getBundle(ClassPathUtils.getFileuploadPropertiesPath());
		this.optiRb = ResourceBundle.getBundle(ClassPathUtils.getOptiPropertiesPath());
		this.uploadType = uploadType;
	}

	private String getCommonProperty(String propertyKey) {
		String key = this.PREFIX_COMMON + "." + propertyKey;

		if (rb.containsKey(key)) {
			return rb.getString(key);
		}

		return null;
	}

	public String getProperty(String propertyKey) {
		if (this.uploadType == null || "".equals(this.uploadType)) {
			return getCommonProperty(propertyKey);
		}

		String key = this.uploadType + "." + propertyKey;

		if (rb.containsKey(key)) {
			return rb.getString(key);
		} else {
			return getCommonProperty(propertyKey);
		}
	}
	
	public String getTempDir() {
		if(this.optiRb.containsKey(TEMP_DIR)) {
			return optiRb.getString(TEMP_DIR);
		} else {
			return "/temp";
		}
	}
	
	public String getDiskPath() {
		if(this.optiRb.containsKey(DISK_PATH)) {
			return optiRb.getString(DISK_PATH);
		} else {
			return optiRb.getString(CONTEXT_PATH);
		}
	}

	/**
	 * 기존 getDiskPath 메소드를 이용한 Path 취득 시 값이 없을 경우 request를 이용한 hrfile 경로 취득
	 * 
	 * @param request HttpServletRequest
	 * @return DiskPath 경로
	 */
	public String getDiskPath(HttpServletRequest request) {
		//return (getDiskPath().length() == 0) ? request.getSession().getServletContext().getRealPath("/") + "/hrfile" : getDiskPath();
		return (getDiskPath().length() == 0) ? ClassPathUtils.getClassPathHrfile() : getDiskPath();
	}

	public List<String[]> getPropertyList() {
		List<String[]> list = new ArrayList<String[]>();

		String value = getProperty(FileUploadConfig.POSTFIX_MIME_TYPE);
		if (value != null && !"".equals(value))
			list.add(new String[] { FileUploadConfig.POSTFIX_MIME_TYPE, value });

		value = getProperty(FileUploadConfig.POSTFIX_EXT_EXTENSION);
		if (value != null && !"".equals(value))
			list.add(new String[] { FileUploadConfig.POSTFIX_EXT_EXTENSION, value });

		value = getProperty(FileUploadConfig.POSTFIX_MIME_EXTENSION);
		if (value != null && !"".equals(value))
			list.add(new String[] { FileUploadConfig.POSTFIX_MIME_EXTENSION, value });

		value = getProperty(FileUploadConfig.POSTFIX_FILE_SIZE);
		if (value != null && !"".equals(value))
			list.add(new String[] { FileUploadConfig.POSTFIX_FILE_SIZE, value });

		value = getProperty(FileUploadConfig.POSTFIX_FILE_COUNT);
		if (value != null && !"".equals(value))
			list.add(new String[] { FileUploadConfig.POSTFIX_FILE_COUNT, value });
		
		value = getProperty(FileUploadConfig.POSTFIX_MULTIPLE);
		if (value != null && !"".equals(value))
			list.add(new String[] { FileUploadConfig.POSTFIX_MULTIPLE, value });

		return list;
	}
	
	public String getPropertyByJSON() {
		List<String[]> list = getPropertyList();
		StringBuffer sb = new StringBuffer();
		
		sb.append("{");
		
		Iterator<String[]> it = list.iterator();
		
		while(it.hasNext()) {
			String[] arr = it.next();
			
			sb.append("\"" + arr[0] + "\"");
			sb.append(":");
			sb.append("\"" + arr[1] + "\"");
			
			if(it.hasNext()) {
				sb.append(",");
			}
		}
		
		sb.append("}");
		
		return sb.toString();
	}
}
