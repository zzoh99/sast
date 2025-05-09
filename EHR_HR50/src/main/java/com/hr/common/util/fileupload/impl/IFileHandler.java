package com.hr.common.util.fileupload.impl;

import org.json.JSONArray;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

public interface IFileHandler {

	/**
	 * 파일 그대로 다운로드 할 지 여부 설정. true 일 경우, 암호화 여부에 상관없이 파일 그대로 다운로드.
	 * @param isDirectDownload 파일 그자체로 다운로드 할지 여부 (기본값: false)
	 */
	void setIsDirectDownload(boolean isDirectDownload);

	JSONArray upload() throws Exception;
	void fileupload(InputStream inStrm, String fileNm, Map<String, Object> tsys200Map, Map<String, Object> tsys201Map, Map<String, Object> tsys202Map, int cnt) throws Exception;
	void ibFileupload(InputStream inStrm, String fileNm, Map<String, Object> tsys200Map, Map<String, Object> tsys201Map, Map<String, Object> tsys202Map, int cnt) throws Exception;

	void download() throws Exception;
	void download(boolean isDirectView) throws Exception;
	void download(boolean isDirectView, Map<String, Object> paramMap) throws Exception;
	void download(boolean isDirectView, String[] fileSeqArr, String[] seqNoArr) throws Exception;
	void downloadPdf(String filePath, String fileName) throws Exception;

	void delete() throws Exception;
	void ibDelete() throws Exception;

	JSONArray ibupload(String cmd, List<Map<String, Object>> ibFileList) throws Exception;

	JSONArray copy(String targetUploadType, String[] fileSeqArr, String[] seqNoArr) throws Exception;

	JSONArray photoFileUpload() throws Exception;
	JSONArray recordFileUpload() throws Exception;

	JSONArray yjungsanPdfUpload() throws Exception;
	void downloadYJungsanPdf(String[] filePathArr, String[] fileNameArr, String[] downFileNameArr) throws Exception;
	void deleteYJungsanPdf() throws Exception;

	void loadView(boolean isDirectView, String[] fileSeqArr, String[] seqNoArr) throws Exception;
}
