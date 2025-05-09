package com.hr.common.util.fileupload.impl;

import com.hr.common.logger.Log;
import com.hr.common.util.fileupload.jfileupload.web.JFileUploadService;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class FileToDBHandler extends AbsFileHandler {

	public FileToDBHandler(HttpServletRequest request, HttpServletResponse response, FileUploadConfig config) {
		super(request, response, config);
	}

	protected String getTimeStemp() {
		//수정 소스 추가
		Random rng = new Random();
		double r = rng.nextDouble();
		//수정 소스 변경
//		String rtnStr = Math.random()+ "";
		String rtnStr = Double.toString(r)+ "";
		rtnStr = rtnStr.substring(2);
		return rtnStr;
	}

	@Override
	protected void init() throws Exception {

	}

	@Override
	public void fileupload(InputStream inStrm, String fileNm, Map<String, Object> tsys200Map, Map<String, Object> tsys201Map, Map<String, Object> tsys202Map, int cnt) throws Exception {
		if(tsys200Map != null) {
			tsys200Map.put("filePath", "");
		}
		
		
		ByteArrayOutputStream buffer = null;

		try {
			buffer = new ByteArrayOutputStream();
			int fileSize = inStrm.available();

			int nRead;
			byte[] data = new byte[16384];

			while ((nRead = inStrm.read(data, 0, data.length)) != -1) {
				buffer.write(data, 0, nRead);
			}
			buffer.flush();
			
			tsys201Map.put("ssnEnterCd", this.enterCd);
//			tsys201Map.put("fileSeq", tsys200Map.get("fileSeq"));
			tsys201Map.put("seqNo", cnt);
			tsys201Map.put("sFileNm", "");
			tsys201Map.put("rFileNm", fileNm);
			tsys201Map.put("fileSize", fileSize);
			tsys201Map.put("ssnSabun", session.getAttribute("ssnSabun"));
			
			tsys202Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
//			tsys202Map.put("fileSeq", tsys200Map.get("fileSeq"));
			tsys202Map.put("seqNo", cnt);
			tsys202Map.put("fileData", buffer.toByteArray());
			tsys202Map.put("ssnSabun", session.getAttribute("ssnSabun"));
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			throw e;
		} finally {
			try {
				if (buffer != null) {
					buffer.close();
					buffer = null;
				}
			} catch (Exception ee) { Log.Debug(ee.getLocalizedMessage()); }
		}
	}

	@Override
	public void ibFileupload(InputStream inStrm, String fileNm, Map<String, Object> tsys200Map, Map<String, Object> tsys201Map, Map<String, Object> tsys202Map, int cnt) throws Exception {
		// fileupload 호출
		fileupload(inStrm, fileNm, tsys200Map, tsys201Map, tsys202Map, cnt);
	}
	
	@Override
	protected InputStream filedownload(Map<?, ?> paramMap) throws Exception {
		if(paramMap == null) {
			return null;
		}
		
		WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
		JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");
		Map<?, ?> map = jFileUploadService.tsys202Search(paramMap);

		Object o = map.get("fileData");

		if (o != null) {
			return new ByteArrayInputStream((byte[]) map.get("fileData"));
		} else {
			throw new Exception("<script>alert('The file does not exist.');</script>");
		}
	}

	@Override
	protected void filedelete(List<Map<?, ?>> deleteList) throws Exception {
		WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
		JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

		if (!jFileUploadService.fileStoreDelete(deleteList, true)) {
			throw new Exception("Error!");
		}
	}

	@Override
	protected void ibFileDelete(List<Map<?, ?>> deleteList) throws Exception {
		filedelete(deleteList);
	}

	@Override
	public void fileuploadPhoto(InputStream inStrm, String fileNm, Map tsys200Map, Map tsys201Map, int cnt)
			throws Exception {
	}
	@Override
	public void fileuploadRecord(InputStream inStrm, String fileNm, Map tsys200Map, Map tsys201Map, int cnt)
			throws Exception {
	}
	@Override
	protected void initYJungsanPdf() throws Exception {

	}
	@Override
	public void fileuploadYJungsanPdf(InputStream inStrm, String fileNm, Map tyea105Map, int cnt) throws Exception {

	}
	@Override
	protected void filedeleteYJungsanPdf(List<Map<?, ?>> deleteList) throws Exception {

	}
	@Override
	protected InputStream filedownloadYJungsanPdf(Map<?, ?> paramMap) throws Exception {
		return null;
	}
}
