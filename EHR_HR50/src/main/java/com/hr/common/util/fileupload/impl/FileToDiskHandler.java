package com.hr.common.util.fileupload.impl;

import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.common.util.StringUtil;
import com.hr.common.util.classPath.ClassPathUtils;
import com.hr.common.util.fileupload.jfileupload.web.JFileUploadService;
import org.apache.commons.fileupload.util.Streams;
import org.springframework.util.ResourceUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FileToDiskHandler extends AbsFileHandler {

	private String targetPath = null;
	private String workDir = null;
	private ArrayList<String> files = null;
	private String pathPattern = null;

	public FileToDiskHandler(HttpServletRequest request, HttpServletResponse response, FileUploadConfig config) {
		super(request, response, config);
		
		//HttpSession sesson = request.getSession();
		if( session != null ) {
			this.fileDownSetPwd = (String) session.getAttribute("ssnFileDownSetPwd");
			this.tmpPassword = (String) session.getAttribute("ssnFileDownPwd");
		}
		if( this.fileDownSetPwd == null || "".equals(this.fileDownSetPwd) ) {
			this.fileDownSetPwd = "N";
		}
	}

	@Override
	protected void init() throws Exception {
		String realPath = (this.config.getDiskPath().length()==0 ) ? ClassPathUtils.getClassPathHrfile() : this.config.getDiskPath();
		Log.Debug("[FileToDiskHandler.init] ClassPathUtil.getClassPathHrfile() : " + ClassPathUtils.getClassPathHrfile());
		this.targetPath = StringUtil.replaceAll(realPath + File.separator + this.enterCd, "//", "/");
		Log.Debug("[FileToDiskHandler.init] targetPath : " + targetPath);

		String tmp = this.config.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
		tmp = tmp == null ? "" : tmp;

		Pattern p = Pattern.compile("@([\\w]*)@");
		Matcher m = p.matcher(tmp);

		while (m.find()) {
			if (m.groupCount() > 0) {
				String replaceKey = m.group(0);
				String patternKey = m.group(1);
				pathPattern = patternKey;
				try {
					if ("time".equals(patternKey)) { // 밀리세컨드 패턴 추가
						tmp = tmp.replace(replaceKey, String.valueOf(System.currentTimeMillis()));
					} else {
						tmp = tmp.replace(replaceKey, DateUtil.getCurrentDay(patternKey));
					}
				} catch (Exception e) { Log.Debug(e.getLocalizedMessage()); }
			}
		}

		this.workDir = StringUtil.replaceAll(tmp, "//", "/");
	}

	@Override
	public void fileupload(InputStream inStrm, String fileNm, Map<String, Object> tsys200Map, Map<String, Object> tsys201Map, Map<String, Object> tsys202Map, int cnt) throws Exception {
		if(this.targetPath == null) {
			init();
		}

		if(tsys200Map != null) {
			tsys200Map.put("filePath", this.workDir);
		} else {
			if(tsys201Map != null) {
				// TSYS200에 이미 저장된 filePath 가 있는 경우, workDir 경로 변경
				// -> 신청서에서 202409월에 파일첨부하여 임시저장한 후 동일한 신청서에 202410월에 새로 파일을 추가한 경우,
				//     TSYS200의 filePath는 /appl/202409 이나, 신규 파일이 저장되는 경로는 /appl/202410 이다.
				//     따라서 해당 이슈를 해결하기 위해 TSYS200의 filePath를 우선 조회하여 workDir를 변경하는 로직을 추가 함
				WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
				JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("ssnEnterCd", this.enterCd);
				paramMap.put("fileSeq", tsys201Map.get("fileSeq").toString());
				Map<?, ?> map = jFileUploadService.jFileCount(paramMap);

				if (map != null) {
					this.workDir = map.get("filePath").toString();
				}
			}
		}

		FileOutputStream fo = null;
		try {
			String realFileName = null;
			int fileSize = inStrm.available();

			String nmPattern = config.getProperty(FileUploadConfig.POSTFIX_NAME_PATTERN);
			if(nmPattern.startsWith("default")) {
				realFileName = fileNm.substring(0, fileNm.lastIndexOf("."));
			} else if(nmPattern.startsWith("random")) {
				realFileName = getTimeStemp()+cnt;
			} else if(nmPattern.startsWith("sabun")) {
				realFileName = request.getParameter("sabun");
				if(realFileName == null || "".equals(realFileName)) {
					realFileName = (String) session.getAttribute("ssnSabun");
				}
			}

			if(nmPattern.endsWith("Ext")) {
				realFileName += fileNm.substring(fileNm.lastIndexOf("."));
			}

			String path = StringUtil.replaceAll(this.targetPath + "/" + this.workDir + "/" + realFileName, "//", "/");
			File toDir = new File(path);
			File upDir = toDir.getParentFile();

			if (upDir != null && !upDir.exists()) {
				upDir.mkdirs();// 폴더경로 없으면 만들어 놓기.
			}

			fo = new FileOutputStream(toDir);

			Streams.copy(inStrm, fo, true);

			tsys201Map.put("ssnEnterCd", this.enterCd);
//			tsys201Map.put("fileSeq", tsys200Map.get("fileSeq"));
			tsys201Map.put("seqNo", cnt);
			tsys201Map.put("sFileNm", realFileName);
			tsys201Map.put("rFileNm", fileNm);
			tsys201Map.put("fileSize", fileSize);
			tsys201Map.put("ssnSabun", session.getAttribute("ssnSabun"));

			if(this.files == null) {
				this.files = new ArrayList<String>();
			}

			this.files.add(realFileName);
		} catch (Exception e) {
			if(this.files != null && this.files.size() > 0) {
				for(String fileName : this.files) {
					String path = StringUtil.replaceAll(this.targetPath + "/" + this.workDir + "/" + fileName, "//", "/");
					File file = new File(path);
					if(file.isFile()) {
						file.delete();
					}
				}
			}
			Log.Debug(e.getLocalizedMessage());
		} finally {
			if (fo != null) fo.close();
		}
	}

	// ibSheet 파일업로드 -> temp 경로 업로드
	@Override
	public void ibFileupload(InputStream inStrm, String fileNm, Map<String, Object> tsys200Map, Map<String, Object> tsys201Map, Map<String, Object> tsys202Map, int cnt) throws Exception {
		if(this.targetPath == null) {
			init();
		}

		if(tsys200Map != null) {
			tsys200Map.put("filePath", this.workDir + "/" + tsys200Map.get("fileSeq").toString());
		}
		FileOutputStream fo = null;
		try {
			String realFileName = null;
			int fileSize = inStrm.available();

			String nmPattern = config.getProperty(FileUploadConfig.POSTFIX_NAME_PATTERN);
			if(nmPattern.startsWith("default")) {
				realFileName = fileNm.substring(0, fileNm.lastIndexOf("."));
			} else if(nmPattern.startsWith("random")) {
				realFileName = getTimeStemp()+cnt;
			} else if(nmPattern.startsWith("sabun")) {
				realFileName = request.getParameter("sabun");
				if(realFileName == null || "".equals(realFileName)) {
					realFileName = (String) session.getAttribute("ssnSabun");
				}
			}

			if(nmPattern.endsWith("Ext")) {
				realFileName += fileNm.substring(fileNm.lastIndexOf("."));
			}

			// 업로드 경로 설정: 임시 경로\fileSeq
			String fileSeq = tsys201Map.get("fileSeq").toString();
			String tempPath = config.getTempDir();
			String path = StringUtil.replaceAll(tempPath + "/" + fileSeq + "/" + realFileName, "//", "/");

			File toDir = new File(path);
			File upDir = toDir.getParentFile();

			if (upDir != null && !upDir.exists()) {
				upDir.mkdirs();// 폴더경로 없으면 만들어 놓기.
			}

			fo = new FileOutputStream(toDir);

			Streams.copy(inStrm, fo, true);

			//tsys201Map.put("ssnEnterCd", this.enterCd);
			tsys201Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			tsys201Map.put("seqNo", cnt);
			tsys201Map.put("sFileNm", realFileName);
			tsys201Map.put("rFileNm", fileNm);
			tsys201Map.put("fileSize", fileSize);
			tsys201Map.put("ssnSabun", session.getAttribute("ssnSabun"));

			if(this.files == null) {
				this.files = new ArrayList<String>();
			}

			this.files.add(realFileName);
		} catch (Exception e) {
			if(this.files != null && this.files.size() > 0) {
				for(String fileName : this.files) {
					String path = StringUtil.replaceAll(this.targetPath + "/" + this.workDir + "/" + fileName, "//", "/");
					File file = new File(path);
					if(file.isFile()) {
						file.delete();
					}
				}
			}
			Log.Debug(e.getLocalizedMessage());
		} finally {
			if (fo != null) fo.close();
		}
	}

	@Override
	protected InputStream filedownload(Map<?, ?> paramMap) throws Exception {
		if(paramMap == null) {
			return null;
		}

		if(this.targetPath == null) {
			init();
		}
		String filePath = String.valueOf(paramMap.get("filePath"));
		String sname = String.valueOf(paramMap.get("sFileNm"));
		String path = StringUtil.replaceAll(this.targetPath + File.separator + filePath + File.separator, "//", "/");
		Log.Debug("[FileToDiskHandler.filedownload] path : " + path);
		Log.Debug("[FileToDiskHandler.filedownload] path + sname : " + path + sname);

		File file = new File(path + sname);

		// 파일 존재 유무 체크, 파일이 없으면 temp\fileSeq 경로에 파일이 있는지 확인
		if (!file.exists()) {

			String fileSeq = String.valueOf(paramMap.get("fileSeq"));
			String tempPath = config.getTempDir();
			path = StringUtil.replaceAll(tempPath + "/" + fileSeq + "/", "//", "/");

			file = new File(path + sname);

			if (!file.exists()) {
				Log.Debug("NO FILE EXISTS : {}", paramMap);
				file = ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + "/static" + "/common/images/common/img_photo.gif");
			}
		}

		FileInputStream fis = null;
		try {
			fis = new FileInputStream(file);
		}  catch(Exception e) {
			if(fis != null){
				try {
					fis.close();
				}catch (IOException ie){
					Log.Debug("FileInputStream CLOSE FAIL");
				}
			}
		}

		return fis;
	}

	@Override
	protected void filedelete(List<Map<?, ?>> deleteList) throws Exception {
		WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
		JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

		if (!jFileUploadService.fileStoreDelete(deleteList, false)) {
			throw new Exception("Error!");
		}

		if (deleteList != null && deleteList.size() > 0) {
			Iterator<Map<?, ?>> it = deleteList.iterator();

			while (it.hasNext()) {
				Map<?, ?> map = it.next();

				String filePath = String.valueOf(map.get("filePath"));
				String sname = String.valueOf(map.get("sFileNm"));
				String path = StringUtil.replaceAll(this.targetPath + "/" + filePath + "/", "//", "/");
				File file = new File(path + sname);

				if (file.isFile()) {
					file.delete();

					// 파일 삭제 후 디렉토리 비어 있는지 확인
					File dir = new File(path);
					if ("time".equals(this.pathPattern) && dir.isDirectory() && dir.listFiles().length == 0) {
						dir.delete();
					}
				}
			}
		}
	}

	@Override
	protected void ibFileDelete(List<Map<?, ?>> deleteList) throws Exception {
		WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
		JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

		if (deleteList != null && deleteList.size() > 0) {
			Iterator<Map<?, ?>> it = deleteList.iterator();

			while (it.hasNext()) {
				Map<?, ?> map = it.next();

				String sname = String.valueOf(map.get("sFileNm"));

				// 삭제 경로 설정: 임시 경로\fileSeq
				String fileSeq = String.valueOf(map.get("fileSeq"));
				String tempPath = config.getTempDir();
				String path = StringUtil.replaceAll(tempPath + "/" + fileSeq + "/", "//", "/");

				File file = new File(path + sname);

				if (file.isFile()) {
					file.delete();
				}
			}
		}
	}

	@Override
	public void fileuploadPhoto(InputStream inStrm, String fileNm, Map tsys200Map, Map tsys201Map, int cnt) throws Exception {
		if(this.targetPath == null) {
			init();
		}

		if(tsys200Map != null) {
			tsys200Map.put("filePath", this.workDir);
		}

		try {
			String realFileName = null;
			int fileSize = inStrm.available();
			String p_sabun ="";

			String nmPattern = config.getProperty(FileUploadConfig.POSTFIX_NAME_PATTERN);
			if(nmPattern.startsWith("default")) {
				realFileName = fileNm.substring(0, fileNm.lastIndexOf("."));
			} else if(nmPattern.startsWith("random")) {
				realFileName = getTimeStemp()+cnt;
			} else if(nmPattern.startsWith("sabun")) {
				//realFileName = request.getParameter("sabun");
				realFileName = fileNm.substring(0,fileNm.indexOf("."));
				p_sabun = realFileName;
				if(realFileName == null || "".equals(realFileName)) {
					realFileName = (String) session.getAttribute("ssnSabun");
				}
			}else if(nmPattern.startsWith("origin")){
				realFileName = fileNm;
			}

			if(nmPattern.endsWith("Ext")) {
				realFileName += fileNm.substring(fileNm.lastIndexOf("."));
			}

			String path = this.targetPath + File.separator + this.workDir + File.separator + realFileName;
			path = path.replaceAll(Matcher.quoteReplacement(File.separator)+Matcher.quoteReplacement(File.separator), Matcher.quoteReplacement(File.separator));

			//Log.Debug("======================= fileupload =========================)");
			//Log.Debug("============================================================)");
			//Log.Debug("path : " + path);
			//Log.Debug("============================================================)");
			//Log.Debug("============================================================)");

			File toDir = new File(path);
			File upDir = toDir.getParentFile();

			if (!upDir.exists()) {
				upDir.mkdirs();// �뤃�뜑寃쎈줈 �뾾�쑝硫� 留뚮뱾�뼱 �넃湲�.
			}

			FileOutputStream fo = new FileOutputStream(toDir);

			Streams.copy(inStrm, fo, true);

			tsys201Map.put("ssnEnterCd", this.enterCd);
//			tsys201Map.put("fileSeq", tsys200Map.get("fileSeq"));
			tsys201Map.put("seqNo", cnt);
			tsys201Map.put("sFileNm", realFileName);
			tsys201Map.put("rFileNm", fileNm);
			tsys201Map.put("fileSize", fileSize);
			tsys201Map.put("pSabun", p_sabun);

			tsys201Map.put("ssnSabun", session.getAttribute("ssnSabun"));

			if(this.files == null) {
				this.files = new ArrayList<String>();
			}

			this.files.add(realFileName);
		} catch (Exception e) {
			e.printStackTrace();

			if(this.files != null && this.files.size() > 0) {
				for(String fileName : this.files) {
					String path = StringUtil.replaceAll(this.targetPath + File.separator + this.workDir + File.separator + fileName, "//",  Matcher.quoteReplacement(File.separator));
					File file = new File(path);
					if(file.isFile()) {
						file.delete();
					}
				}
			}

			throw e;
		} finally {
		}
	}

	@Override
	public void fileuploadRecord(InputStream inStrm, String fileNm, Map tsys200Map, Map tsys201Map, int cnt) throws Exception {
		if(this.targetPath == null) {
			init();
		}

		if(tsys200Map != null) {
			tsys200Map.put("filePath", this.workDir);
		}

		try {
			String realFileName = null;
			int fileSize = inStrm.available();
			String p_sabun ="";

			String nmPattern = config.getProperty(FileUploadConfig.POSTFIX_NAME_PATTERN);
			if(nmPattern.startsWith("default")) {
				realFileName = fileNm.substring(0, fileNm.lastIndexOf("."));
			} else if(nmPattern.startsWith("random")) {
				realFileName = getTimeStemp()+cnt;
			} else if(nmPattern.startsWith("sabun")) {
				//realFileName = request.getParameter("sabun");
				realFileName = fileNm.substring(0,fileNm.indexOf("."));
				p_sabun = realFileName;
				if(realFileName == null || "".equals(realFileName)) {
					realFileName = (String) session.getAttribute("ssnSabun");
				}
			}else if(nmPattern.startsWith("origin")){
				realFileName = fileNm;
			}

			if(nmPattern.endsWith("Ext")) {
				realFileName += fileNm.substring(fileNm.lastIndexOf("."));
			}

			String path = this.targetPath + File.separator + this.workDir + File.separator + realFileName;
			path = path.replaceAll(Matcher.quoteReplacement(File.separator)+Matcher.quoteReplacement(File.separator), Matcher.quoteReplacement(File.separator));

			//Log.Debug("======================= fileupload =========================)");
			//Log.Debug("============================================================)");
			//Log.Debug("path : " + path);
			//Log.Debug("============================================================)");
			//Log.Debug("============================================================)");

			File toDir = new File(path);
			File upDir = toDir.getParentFile();

			if (!upDir.exists()) {
				upDir.mkdirs();
			}

			FileOutputStream fo = new FileOutputStream(toDir);

			Streams.copy(inStrm, fo, true);

			tsys201Map.put("ssnEnterCd", this.enterCd);
//			tsys201Map.put("fileSeq", tsys200Map.get("fileSeq"));
			tsys201Map.put("seqNo", cnt);
			tsys201Map.put("sFileNm", realFileName);
			tsys201Map.put("rFileNm", fileNm);
			tsys201Map.put("fileSize", fileSize);
			tsys201Map.put("pSabun", p_sabun);

			tsys201Map.put("ssnSabun", session.getAttribute("ssnSabun"));

			if(this.files == null) {
				this.files = new ArrayList<String>();
			}

			this.files.add(realFileName);
		} catch (Exception e) {
			e.printStackTrace();

			if(this.files != null && this.files.size() > 0) {
				for(String fileName : this.files) {
					String path = StringUtil.replaceAll(this.targetPath + File.separator + this.workDir + File.separator + fileName, "//",  Matcher.quoteReplacement(File.separator));
					File file = new File(path);
					if(file.isFile()) {
						file.delete();
					}
				}
			}

			throw e;
		} finally {
		}
	}

	@Override
	protected void initYJungsanPdf() throws Exception {

		String realPath = (this.config.getDiskPath().length()==0 ) ?ClassPathUtils.getClassPathHrfile() : this.config.getDiskPath();
		realPath = realPath.replaceAll("/",  Matcher.quoteReplacement(File.separator));

		this.targetPath = realPath + File.separator + "YEA_INCOME" + File.separator + this.enterCd;
		this.targetPath.replaceAll(Matcher.quoteReplacement(File.separator)+Matcher.quoteReplacement(File.separator), Matcher.quoteReplacement(File.separator));

		String tmp = this.config.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
		tmp = tmp == null ? "" : tmp;

		//Log.Debug("========================= init() ===========================)");
		//Log.Debug("============================================================)");
		//Log.Debug("this.config.getDiskPath() : " + this.config.getDiskPath().toString());
		//Log.Debug("tmp : " + tmp);
		//Log.Debug("realPath : " + realPath);
		//Log.Debug("this.targetPath : " + this.targetPath);
		//Log.Debug("============================================================)");
		//Log.Debug("============================================================)");

		Pattern p = Pattern.compile("@([\\w]*)@");
		Matcher m = p.matcher(tmp);

		while (m.find()) {
			if (m.groupCount() > 0) {
				String replaceKey = m.group(0);
				String patternKey = m.group(1);

				try {
					tmp = tmp.replace(replaceKey, DateUtil.getCurrentDay(patternKey));
				} catch (Exception e) {
				}
			}
		}

		this.workDir = StringUtil.replaceAll(tmp, Matcher.quoteReplacement(File.separator)+Matcher.quoteReplacement(File.separator), Matcher.quoteReplacement(File.separator));
	}


	@Override
	protected InputStream filedownloadYJungsanPdf(Map<?, ?> paramMap) throws Exception {
		if(paramMap == null) {
			return null;
		}

		String realPath = (this.config.getDiskPath().length()==0 ) ? request.getSession().getServletContext().getRealPath(File.separator) : this.config.getDiskPath();
		realPath = realPath.replaceAll("/",  Matcher.quoteReplacement(File.separator));

		String filePath = String.valueOf(paramMap.get("filePath"));
		filePath = filePath.replaceAll("/", Matcher.quoteReplacement(File.separator));

		String sname = String.valueOf(paramMap.get("sFileNm"));
		String path = realPath + File.separator + filePath + File.separator;
		path = path.replaceAll(Matcher.quoteReplacement(File.separator)+Matcher.quoteReplacement(File.separator), Matcher.quoteReplacement(File.separator));

		//Log.Debug("============================================================");
		//Log.Debug("======================= FileToDiskHandler.filedownload =======================");
		//Log.Debug("paramMap : " + paramMap.toString());
		//Log.Debug("path : " + path);
		//Log.Debug("path : " + path + sname);
		//Log.Debug("============================================================");
		//Log.Debug("============================================================");

		File file = new File(path + sname);

		return new FileInputStream(file);
		//return new BufferedInputStream( new FileInputStream(file));
	}

	@Override
	public void fileuploadYJungsanPdf(InputStream inStrm, String fileNm, Map tyea105Map, int cnt) throws Exception {

		if(this.targetPath == null) {
			initYJungsanPdf();
		}

		try {
			String workYy = "";
			if(tyea105Map != null) {
				workYy = tyea105Map.get("workYy").toString();
			}


			String realFileName = null;
			int fileSize = inStrm.available();
			String nmPattern = config.getProperty(FileUploadConfig.POSTFIX_NAME_PATTERN);
			if(nmPattern.startsWith("default")) {
				realFileName = fileNm.substring(0, fileNm.lastIndexOf("."));
			} else if(nmPattern.startsWith("random")) {
				realFileName = getTimeStemp()+cnt;
			} else if(nmPattern.startsWith("sabun")) {
				realFileName = request.getParameter("sabun");
				if(realFileName == null || "".equals(realFileName)) {
					realFileName = (String) session.getAttribute("ssnSabun");
				}
			}else if(nmPattern.startsWith("origin")){
				realFileName = fileNm;
			}

			if(nmPattern.endsWith("Ext")) {
				realFileName += fileNm.substring(fileNm.lastIndexOf("."));
			}

			String path = this.targetPath + File.separator + this.workDir + workYy + File.separator + realFileName;
			path = path.replaceAll(Matcher.quoteReplacement(File.separator)+Matcher.quoteReplacement(File.separator), Matcher.quoteReplacement(File.separator));

			//Log.Debug("======================= fileupload =========================)");
			//Log.Debug("============================================================)");
			//Log.Debug("path : " + path);
			//Log.Debug("============================================================)");
			//Log.Debug("============================================================)");

			File toDir = new File(path);
			File upDir = toDir.getParentFile();
			if (!upDir.exists()) {
				upDir.mkdirs();
			}

			FileOutputStream fo = new FileOutputStream(toDir);

			Streams.copy(inStrm, fo, true);

			//String savePath = File.separator + path.substring(path.indexOf("hrfile")).replace(File.separator+realFileName, "");
			String savePath = path.substring(path.indexOf("hrfile")+6).replace(File.separator+realFileName, "");

			//tyea105Map.put("workYy", infoArr[0]);
			//tyea105Map.put("sabun", infoArr[1]);
			tyea105Map.put("adjustType", "1");
			tyea105Map.put("fileType", "1");
			tyea105Map.put("filePath", savePath);
			tyea105Map.put("fileName", fileNm);
			tyea105Map.put("attr1", realFileName);
			tyea105Map.put("attr2", fileSize);
			if(this.files == null) {
				this.files = new ArrayList<String>();
			}

			this.files.add(realFileName);
		} catch (Exception e) {
			e.printStackTrace();

			if(this.files != null && this.files.size() > 0) {
				for(String fileName : this.files) {
					String path = StringUtil.replaceAll(this.targetPath + File.separator + this.workDir + File.separator + fileName, "//",  Matcher.quoteReplacement(File.separator));
					File file = new File(path);
					if(file.isFile()) {
						file.delete();
					}
				}
			}

			throw e;
		} finally {
		}
	}


	@Override
	protected void filedeleteYJungsanPdf(List<Map<?, ?>> deleteList) throws Exception {
		WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
		JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

		if (deleteList != null && deleteList.size() > 0) {
			Iterator<Map<?, ?>> it = deleteList.iterator();

			while (it.hasNext()) {
				Map<?, ?> map = it.next();

				String filePath = String.valueOf(map.get("workYy"));
				filePath = filePath.replaceAll("/",  Matcher.quoteReplacement(File.separator));

				String sname = String.valueOf(map.get("fileName"));


				String path = this.targetPath + File.separator + filePath + File.separator;
				path = path.replaceAll(Matcher.quoteReplacement(File.separator)+Matcher.quoteReplacement(File.separator), Matcher.quoteReplacement(File.separator));

				//Log.Debug("============================================================)");
				//Log.Debug("========================= filedelete =======================)");
				//Log.Debug("path : " + path);
				//Log.Debug("fullPath : " + path+sname);
				//Log.Debug("============================================================)");
				//Log.Debug("============================================================)");

				File file = new File(path + sname);

				if (file.isFile()) {
					file.delete();
				}
			}
		}
	}

}
