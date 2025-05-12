package com.hr.common.util.fileupload.impl;

import com.hr.common.exception.FileUploadException;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.*;
import com.hr.common.util.classPath.ClassPathUtils;
import com.hr.common.util.fileupload.jfileupload.web.JFileUploadService;
import com.hr.common.util.securePath.SecurePathUtil;
import net.sf.jazzlib.CRC32;
import net.sf.jazzlib.ZipEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.apache.tika.Tika;
import org.apache.tika.io.FilenameUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.util.ResourceUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public abstract class AbsFileHandler implements IFileHandler {

	private final int DISK_THRESHOLD_SIZE = 1024 * 1024 * 3; // 3MB
	private Object lockObj = new Object();
	protected HttpSession session = null;
	protected HttpServletRequest request = null;
	protected HttpServletResponse response = null;
	protected FileUploadConfig config = null;
	protected String enterCd = null;
	
	protected String fileDownSetPwd = "N";
	protected String tmpPassword = "";

	// 파일 1개일 경우, 암호화 여부 상관없이 압축하지 않고 파일 그대로 다운로드 되도록 설정.
	// 파일다운로드 시 암호화로 설정할 경우 무조건 비밀번호가 적용된 상태로 압축되어 로고 등 이미지가 표시되지 않는 오류 발생하여 옵션 추가.
	protected boolean isDirectDownload = false;

	public AbsFileHandler(HttpServletRequest request, HttpServletResponse response, FileUploadConfig config) {
		this.request = request;
		this.session = request.getSession();
		this.response = response;
		this.config = config;
		this.enterCd = request.getParameter("enterCd");
		if(this.enterCd == null || "".equals(this.enterCd)) {
			this.enterCd = (String) session.getAttribute("ssnEnterCd");
		}
	}

	public void setIsDirectDownload(boolean isDirectDownload) {
		this.isDirectDownload = isDirectDownload;
	}

	protected abstract void init() throws Exception;

	public abstract void fileupload(InputStream inStrm, String fileNm, Map<String, Object> tsys200Map, Map<String, Object> tsys201Map, Map<String, Object> tsys202Map, int cnt) throws Exception;

	public abstract void ibFileupload(InputStream inStrm, String fileNm, Map<String, Object> tsys200Map, Map<String, Object> tsys201Map, Map<String, Object> tsys202Map, int cnt) throws Exception;

	public abstract void fileuploadPhoto(InputStream inStrm, String fileNm, Map tsys200Map, Map tsys201Map, int cnt) throws Exception;

	public abstract void fileuploadRecord(InputStream inStrm, String fileNm, Map tsys200Map, Map tsys201Map, int cnt) throws Exception;

	protected abstract void initYJungsanPdf() throws Exception;
	protected abstract void filedeleteYJungsanPdf(List<Map<?, ?>> deleteList) throws Exception;
	protected abstract InputStream filedownloadYJungsanPdf(Map<?, ?> paramMap) throws Exception;
	public abstract void fileuploadYJungsanPdf(InputStream inStrm, String fileNm, Map tyea105Map, int cnt) throws Exception;

	protected String getTimeStemp() {
		return System.currentTimeMillis()+"";
	}

	protected String getClassPathStatic() {
		return ClassPathUtils.getClassPathStatic();
	}

	public JSONArray upload() throws Exception {
		synchronized (lockObj) {
			if (ServletFileUpload.isMultipartContent(request)) {
				init();
				DiskFileItemFactory factory = new DiskFileItemFactory();
				factory.setSizeThreshold(DISK_THRESHOLD_SIZE);

				// 안전한 임시 디렉토리 생성
				Path tempDirPath = SecurePathUtil.getSecurePath(config.getTempDir());
				String tempDir = tempDirPath.toString();
				File uploadDir = new File(tempDir);
				if (!uploadDir.exists()) {
					SecurePathUtil.createSecureDirectory(config.getTempDir(), tempDir);
				}

				factory.setRepository(uploadDir);

				ServletFileUpload sUpload = new ServletFileUpload(factory);
				sUpload.setFileSizeMax(Long.valueOf(config.getProperty(FileUploadConfig.POSTFIX_FILE_SIZE)));

				//List<FileItem> fList = sUpload.parseRequest(request);
				List<MultipartFile> fList = new ArrayList<MultipartFile>();
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
				Iterator<String> it = multipartRequest.getFileNames();
				while(it.hasNext()) {
					List<MultipartFile> list = multipartRequest.getFiles(it.next().toString());
					for(int i = 0 ; i < list.size() ; i++) {
						MultipartFile mfile = list.get(i);
						fList.add(mfile);
					}
				}

				File toDir = null;
				FileOutputStream fo = null;

				try {
					JSONArray jsonArray = new JSONArray();


					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");
					Iterator<MultipartFile> fIt = fList.iterator();

					if (fIt != null) {
						int curFileCnt = fList.size();
						String fileCnt = config.getProperty(FileUploadConfig.POSTFIX_FILE_COUNT);
						int totFileCnt = Integer.valueOf(fileCnt != null && !"".equals(fileCnt) ? fileCnt : "0");
						String fileSeq = multipartRequest.getParameter("fileSeq");

						int realCnt = 0;
						Map<String, Object> tsys200Map = null;
						boolean isMaster = false;

						if (fileSeq != null && !"".equals(fileSeq)) {
							Map<String, Object> paramMap = new HashMap<String, Object>();
							paramMap.put("ssnEnterCd", this.enterCd);

							SecurityMgrService securityMgrService = (SecurityMgrService) webAppCtxt.getBean("SecurityMgrService");
							String encryptKey = securityMgrService.getEncryptKey(this.enterCd);

							fileSeq = CryptoUtil.decrypt(encryptKey, fileSeq);
							paramMap.put("fileSeq", fileSeq);

							Map<?, ?> map = jFileUploadService.jFileCount(paramMap);

							if (map != null) {
								isMaster = true;
								String cnt = String.valueOf(map.get("cnt"));
								realCnt = Integer.valueOf(cnt != null && !"".equals(cnt) ? cnt : "0");

								if (totFileCnt > 0 && curFileCnt + realCnt > totFileCnt) {
									throw new FileUploadException("File Count Error!");
								}
								String mcnt = String.valueOf(map.get("mcnt"));
								realCnt = Integer.valueOf(mcnt != null && !"".equals(mcnt) ? mcnt : "0");
							}
						} else {
							fileSeq = jFileUploadService.jFileSequence();
						}

						if (!isMaster) {
							tsys200Map = new HashMap<String, Object>();
							tsys200Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
							tsys200Map.put("fileSeq", fileSeq);
							tsys200Map.put("ssnSabun", session.getAttribute("ssnSabun"));
						}

						List<Map<?, ?>> tsys201List = new ArrayList<Map<?, ?>>();
						List<Map<?, ?>> tsys202List = new ArrayList<Map<?, ?>>();

						while (fIt.hasNext()) {
							MultipartFile fItem = fIt.next();

							//if (fItem.isFormField()) {

							//} else {
								String itemName = FilenameUtils.getName(fItem.getOriginalFilename());
								itemName = SecurePathUtil.sanitizeFileName(itemName); // 파일명 검증
								boolean isVaild = true;
								String vaildMsg = null;

								String extExtension = config.getProperty(FileUploadConfig.POSTFIX_EXT_EXTENSION);
								if (extExtension != null && !"".equals(extExtension)) {
									String[] arr = itemName.split("\\.");

									if (arr.length == 1) {
										isVaild = false;
										vaildMsg = "File Type Error! " + itemName;
									} else {
										isVaild = true;
									}

									String ext = arr[arr.length - 1];
									Pattern p = Pattern.compile(extExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
									Matcher m = p.matcher(ext);
									if (!m.matches()) {
										isVaild = false;
										vaildMsg = "File Type Error! " + itemName;
									} else {
										isVaild = true;
									}
								}

								if(!isVaild) {
									String mimeExtension = config.getProperty(FileUploadConfig.POSTFIX_MIME_EXTENSION);
									if (mimeExtension != null && !"".equals(mimeExtension)) {
										mimeExtension = mimeExtension.replaceAll("\\*", ".*");

										Path secureFilePath = SecurePathUtil.getSecurePath(config.getTempDir(), itemName);
										String securePath = secureFilePath.toString();
										toDir = new File(securePath);

										File upDir = toDir.getParentFile();

										if (!upDir.exists()) {
											SecurePathUtil.createSecureDirectory(config.getTempDir(), upDir.getAbsolutePath());
										}

										fo = new FileOutputStream(toDir);

										Streams.copy(fItem.getInputStream(), fo, true);
										fo.flush();

										Tika tika = new Tika();
										String mType = tika.detect(toDir);
										toDir.delete();

										Pattern p = Pattern.compile(mimeExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
										Matcher m = p.matcher(mType);
										if (!m.matches()) {
											isVaild = false;
											vaildMsg = "File Type Error!  " + itemName + " [" + mType + "]";
										} else {
											isVaild = true;
										}
									}
								}

								if(!isVaild) {
									throw new FileUploadException(vaildMsg);
								}

								Map<String, Object> tsys201Map = new HashMap<String, Object>();
								Map<String, Object> tsys202Map = new HashMap<String, Object>();

								fileupload(fItem.getInputStream(), itemName, tsys200Map, tsys201Map, tsys202Map, realCnt);
								tsys201Map.put("fileSeq", fileSeq);
								tsys201List.add(tsys201Map);

								if(tsys202Map.size() > 0) {
									tsys202Map.put("fileSeq", fileSeq);
									tsys202List.add(tsys202Map);
								}
								JSONObject jsonObject = new JSONObject();
								jsonObject.put("fileSeq", fileSeq);
								jsonObject.put("seqNo", realCnt);
								jsonObject.put("rFileNm", tsys201Map.get("rFileNm"));
								jsonObject.put("sFileNm", tsys201Map.get("sFileNm"));
								jsonObject.put("fileSize", tsys201Map.get("fileSize"));
								jsonArray.put(jsonObject);

								realCnt++;
							//}
						}

						boolean result = jFileUploadService.fileStoreSave(tsys200Map, tsys201List, tsys202List);

						if (!result) {
							throw new Exception("fileSave falied");
						}
					}

					return jsonArray;
				} catch(Exception e) {
					Log.Debug(e.getLocalizedMessage());
					throw new Exception("Saved Error!");
				} finally {
					try {
						if(fo != null) {
							fo.close();
							fo = null;
						}
					} catch (Exception ee) { Log.Debug(ee.getLocalizedMessage()); }
					try {
						if(toDir != null) {
							toDir.delete();
						}
					} catch (Exception ee) { Log.Debug(ee.getLocalizedMessage()); }

				}
			} else {
				throw new Exception("Error!");
			}
		}
	}

	protected abstract InputStream filedownload(Map<?, ?> paramMap) throws Exception;

	public void download() throws Exception {
		download(false);
	}

	public void download(boolean isDirectView) throws Exception {
		Map<String, String[]> paramMap = request.getParameterMap();
		Log.Debug(paramMap.toString());
		String[] fileSeqArr = paramMap.get("fileSeq");
		String[] seqNoArr = paramMap.get("seqNo");

		download(isDirectView, fileSeqArr, seqNoArr);
	}

	public void download(boolean isDirectView, Map<String, Object> paramMap) throws Exception {
		Log.Debug(paramMap.toString());
		Log.Debug("fileSeq 타입: " + paramMap.get("fileSeq").getClass().getName());
		Log.Debug(paramMap.get("fileSeq").toString());
		String[] fileSeqArr = (String[]) paramMap.get("fileSeq");
		String[] seqNoArr = (String[]) paramMap.get("seqNo");
		Log.Debug(fileSeqArr[0]);
		Log.Debug(seqNoArr[0]);
		download(isDirectView, fileSeqArr, seqNoArr);
	}

	public void download(boolean isDirectView, String[] fileSeqArr, String[] seqNoArr) throws Exception {
		synchronized (lockObj) {
			init();

			File zipFile = null;
			FileOutputStream fos = null;
			ZipArchiveOutputStream zos = null;
			InputStream in = null;
			OutputStream outt = null;
			List<Map<?, ?>> outputList = null;

			try {
				if(fileSeqArr != null) {
					outputList = new ArrayList<>();
					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

					for(int i = 0; i < fileSeqArr.length; i++) {
						String fileSeq = fileSeqArr[i];
						if(fileSeq == null || "".equals(fileSeq)) {
							continue;
						}

						Map<String, Object> map = new HashMap<String, Object>();
						map.put("ssnEnterCd", this.enterCd);
						map.put("fileSeq", fileSeq);

						if(seqNoArr == null) {
							Collection<?> resultList = jFileUploadService.fileSearchByFileSeq(map);

							for(Object listItem : resultList) {
								outputList.add((Map<?, ?>) listItem);
							}
						} else {
							String seqNo = seqNoArr[i];
							if(seqNo == null || "".equals(seqNo)) {
								continue;
							}

							map.put("seqNo", seqNo);

							// Ib File Upload 임시저장 상태인 파일 다운로드 시도하는 경우.
							if(seqNo.equals("temp")) {
								Map<String, String[]> paramMap = request.getParameterMap();
								String[] sFileNmArr = paramMap.get("sFileNm");
								String[] rFileNmArr = paramMap.get("rFileNm");
								Map tempFile = new HashMap<>();
								tempFile.put("fileSeq", fileSeq);
								tempFile.put("filePath", "");
								tempFile.put("sFileNm", sFileNmArr[i]);
								tempFile.put("rFileNm", rFileNmArr[i]);
								outputList.add(tempFile);
							} else {
								//outputList.add(jFileUploadService.fileSearchBySeqNo(map));
								Map<?,?> tmp = jFileUploadService.fileSearchBySeqNo(map);
								if(tmp != null) {
									outputList.add(jFileUploadService.fileSearchBySeqNo(map));
								}
							}

						}
					}

					if(outputList.size() > 0) {
						String downloadName = null;
						
						// 파일 암호 설정이 N이거나 설정값이 없는 경우[일반적인]
						if(this.isDirectDownload || "N".equals(fileDownSetPwd)) {
							// 파일이 1개인 경우
							if(outputList.size() == 1) {
								Map<?, ?> resultMap = outputList.get(0);
								downloadName = SecurePathUtil.sanitizeFileName(StringUtil.stringValueOf(resultMap.get("rFileNm")));
								
								in = filedownload(resultMap);
								
								// 파일이 여러개인 경우
							} else {
								downloadName = getTimeStemp() + ".zip";
								Path secureZipPath = SecurePathUtil.getSecurePath(config.getTempDir(), downloadName);
								String securePath = secureZipPath.toString();
								zipFile = new File(securePath);
								File upDir = zipFile.getParentFile();
								
								if(upDir != null && !upDir.isDirectory()) {
									SecurePathUtil.createSecureDirectory(config.getTempDir(), upDir.getAbsolutePath());
								}
								
								fos = new FileOutputStream(zipFile);
								zos = new ZipArchiveOutputStream(fos);
								
								Iterator<Map<?, ?>> it = outputList.iterator();
								
								while(it.hasNext()) {
									Map<?, ?> resultMap = it.next();
									addEntry(zos, filedownload(resultMap), String.valueOf(resultMap.get("rFileNm")));
								}
								
								zos.close();
								zos = null;
								fos.close();
								fos = null;
								
								in = new FileInputStream(zipFile);
								zipFile.delete();
							}
						} else {
							
							/**
							 * [2020.12.16 gjyoo]
							 * 파일 암호 설정이 활성화된 경우 비밀번호 설정된 zip파일로 압축하여 다운로드 처리함.
							 * - 참고
							 *     # 시스템 > 시스템 설정  > Code = SYS_FILE_DOWN_SET_PWD
							 *     # 사용라이브러리 : zip4j-2.6.4.jar
							 */
							
							downloadName = getTimeStemp() + ".zip";
							Path secureZipPath = SecurePathUtil.getSecurePath(config.getTempDir(), downloadName);
							String securePath = secureZipPath.toString();
							zipFile = new File(securePath);
							
							File upDir = zipFile.getParentFile();
							if(upDir != null && !upDir.isDirectory()) {
								SecurePathUtil.createSecureDirectory(config.getTempDir(), upDir.getAbsolutePath());
							}
							
							// load Zip4j util
							Zip4jUtil zip4jUtil = new Zip4jUtil(zipFile, true, tmpPassword.toCharArray());
							for (Map<?, ?> resultMap : outputList) {
								zip4jUtil.addEntry(String.valueOf(resultMap.get("rFileNm")), filedownload(resultMap));
							}
							// close zip4j out stream object
							zip4jUtil.close();
							
							in = new FileInputStream(zipFile);
							zipFile.delete();
							
						}

						if(in == null) {
							throw new Exception("<script>alert('download : The file does not exist.');</script>");
						}

						Tika tika = new Tika();
						String mType = tika.detect(downloadName);

						if ( !"".equals(mType)){
							response.setHeader("Content-Type", mType);
							response.setHeader("Content-Disposition", getEncodedFilename(downloadName, getBrowser(request)));
							response.setContentLength((int) in.available());
							Log.Debug("in.available() : " + in.available());
						}else{
							response.setHeader("Content-Type", "application/octet-stream");
							response.setHeader("Content-Disposition", getEncodedFilename(downloadName, getBrowser(request)));
							response.setContentLength((int) in.available());
						}

						/*if(!isDirectView) {
							response.setHeader("Content-Type", "application/octet-stream");
							response.setHeader("Content-Disposition", getEncodedFilename(downloadName, getBrowser(request)));
							response.setContentLength((int) in.available());
						}*/

						outt = response.getOutputStream();

						byte b[] = new byte[1024];
						int numRead = 0;
						while ((numRead = in.read(b)) != -1) {
							outt.write(b, 0, numRead);
						}

						outt.flush();
						outt.close();
						outt = null;
						in.close();
						in = null;
					} else {

						File imgFile =  ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + getClassPathStatic() + "/common/images/common/img_photo.gif");
						FileInputStream ifo = new FileInputStream(imgFile);
						ByteArrayOutputStream baos = new ByteArrayOutputStream();
						byte[] buf = new byte[1024];
						int readlength = 0;
						byte[] imgbuf = null;
						try{
							while( (readlength =ifo.read(buf)) != -1 )
							{
								baos.write(buf,0,readlength);
							}
							imgbuf = baos.toByteArray();
						}finally {
							try {
								baos.close();
							}catch (IOException ie){
								Log.Debug("ByteArrayOutputStream CLOSE FAIL");
							}
							try {
								ifo.close();
							}catch (IOException ie){
								Log.Debug("FileInputStream CLOSE FAIL");
							}
						}

						int length = imgbuf.length;

						Log.Debug("img.length=> "+ length );

						OutputStream out = response.getOutputStream();
						out.write(imgbuf , 0, length);
						out.close();
					}

				} else {
					File imgFile =  ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + getClassPathStatic() + File.separator + "common" + File.separator + "images" + File.separator + "common" + File.separator + "img_photo.gif");
					FileInputStream ifo = new FileInputStream(imgFile);
					ByteArrayOutputStream baos = new ByteArrayOutputStream();
					byte[] buf = new byte[1024];
					int readlength = 0;
					byte[] imgbuf = null;

					try {
						while( (readlength =ifo.read(buf)) != -1 )
						{
							baos.write(buf,0,readlength);
						}
						imgbuf = baos.toByteArray();
					}finally {
						try {
							baos.close();
						}catch (IOException ie){
							Log.Debug("ByteArrayOutputStream CLOSE FAIL");
						}
						try {
							ifo.close();
						}catch (IOException ie){
							Log.Debug("FileInputStream CLOSE FAIL");
						}
					}

					int length = imgbuf.length;

					Log.Debug("img.length=> "+ length );

					OutputStream out = response.getOutputStream();
					out.write(imgbuf , 0, length);
					out.close();
				}
			} catch (Exception e) {
				Log.Debug(e.getLocalizedMessage());
				throw e;
			} finally {
				try {
					if(outt != null) {
						outt.close();
					}
				} catch (Exception ee) {}

				try {
					if(in != null) {
						in.close();
					}
				} catch (Exception ee) {}

				try {
					if(fos != null) {
						fos.close();
					}
				} catch (Exception ee) {}

				try {
					if(zos != null) {
						zos.close();
					}
				} catch (Exception ee) {}

				if(zipFile != null && zipFile.exists()) {
					zipFile.delete();
				}
			}
		}
	}

	private void addEntry(ZipArchiveOutputStream zos, InputStream is, String realFileName) throws Exception {
		ByteArrayOutputStream baos = null;
		ByteArrayInputStream bais = null;
		BufferedInputStream bis = null;

		try {
			byte buffer[] = new byte[102400];
			int bytesRead = 0;


			baos = new ByteArrayOutputStream();

			while ((bytesRead = is.read(buffer)) > 0) {
				baos.write(buffer, 0, bytesRead);
			}

			bais = new ByteArrayInputStream(baos.toByteArray());
			baos.close();
			baos = null;

			bis = new BufferedInputStream(bais);
			CRC32 crc = new CRC32();

			bais.mark(0);
			while ((bytesRead = bis.read(buffer)) > 0) {
				crc.update(buffer, 0, bytesRead);
			}

			bais.reset();
			bis.close();
			bis = null;
			bis = new BufferedInputStream(bais);

			ZipArchiveEntry entry = new ZipArchiveEntry(realFileName);
			entry.setMethod(ZipEntry.STORED);
			entry.setCompressedSize(bais.available());
			entry.setSize(bais.available());
			entry.setCrc(crc.getValue());
			zos.putArchiveEntry(entry);

			while ((bytesRead = bis.read(buffer)) > 0) {
				zos.write(buffer, 0, bytesRead);
			}

			bis.close();
			bis = null;
			bais.close();
			bais = null;
			zos.closeArchiveEntry();
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			throw e;
		} finally {
			try { if(bis != null) { bis.close(); bis = null;} } catch(Exception ee){ Log.Debug(ee.getLocalizedMessage()); }
			try { if(bais != null) { bais.close(); bais = null;} } catch(Exception ee){ Log.Debug(ee.getLocalizedMessage()); }
			try { if(baos != null) { baos.close(); baos = null;} } catch(Exception ee){ Log.Debug(ee.getLocalizedMessage()); }
			try { if(zos != null) { zos.closeArchiveEntry(); zos = null;} } catch(Exception ee){ Log.Debug(ee.getLocalizedMessage()); }
		}
	}

	protected abstract void filedelete(List<Map<?, ?>> deleteList) throws Exception;

	public void delete() throws Exception {
		synchronized(lockObj) {
			init();

			Map<String, String[]> paramMap = request.getParameterMap();

			String[] fileSeqArr = paramMap.get("fileSeq");
			String[] seqNoArr = paramMap.get("seqNo");

			try {
				if(fileSeqArr != null) {
					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

					List<Map<?, ?>> deleteList = new ArrayList<Map<?,?>>();

					if(seqNoArr == null || seqNoArr.length > 1) {
						if(seqNoArr == null) {
							for(String fSeq : fileSeqArr) {
								Map<String, Object> map = new HashMap<String, Object>();
								map.put("ssnEnterCd", this.enterCd);
								map.put("fileSeq", fSeq);

								Collection<?> resultList = jFileUploadService.fileSearchByFileSeq(map);

								for(Object listItem : resultList) {
									deleteList.add((Map<?, ?>) listItem);
								}
							}
						} else {
							for(String sNo : seqNoArr) {
								Map<String, Object> map = new HashMap<String, Object>();
								map.put("ssnEnterCd", this.enterCd);
								map.put("fileSeq", fileSeqArr[0]);
								map.put("seqNo", sNo);

								deleteList.add(jFileUploadService.fileSearchBySeqNo(map));
							}
						}
					} else {
						Map<String, Object> map = new HashMap<String, Object>();
						map.put("ssnEnterCd", this.enterCd);
						map.put("fileSeq", fileSeqArr[0]);
						map.put("seqNo", seqNoArr[0]);

						deleteList.add(jFileUploadService.fileSearchBySeqNo(map));
					}


					filedelete(deleteList);
				}
			} catch (Exception e) {
				Log.Debug(e.getLocalizedMessage());
				throw e;
			}
		}
	}

	protected abstract void ibFileDelete(List<Map<?, ?>> deleteList) throws Exception;

	public void ibDelete() throws Exception {
		synchronized(lockObj) {
			init();

			Map<String, String[]> paramMap = request.getParameterMap();

			String[] fileSeqArr = paramMap.get("fileSeq");
			String[] seqNoArr = paramMap.get("seqNo");

			try {
				if(fileSeqArr != null) {
					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

					List<Map<?, ?>> deleteList = new ArrayList<Map<?,?>>();

					if(seqNoArr == null || seqNoArr.length > 1) {
						if(seqNoArr == null) {
							for(String fSeq : fileSeqArr) {
								Map<String, Object> map = new HashMap<String, Object>();
								map.put("ssnEnterCd", this.enterCd);
								map.put("fileSeq", fSeq);

								Collection<?> resultList = jFileUploadService.fileSearchByFileSeq(map);

								for(Object listItem : resultList) {
									deleteList.add((Map<?, ?>) listItem);
								}
							}
						} else {
							for(String sNo : seqNoArr) {
								Map<String, Object> map = new HashMap<String, Object>();
								map.put("ssnEnterCd", this.enterCd);
								map.put("fileSeq", fileSeqArr[0]);
								map.put("seqNo", sNo);

								deleteList.add(jFileUploadService.fileSearchBySeqNo(map));
							}
						}
					} else {
						Map<String, Object> map = new HashMap<String, Object>();
						map.put("ssnEnterCd", this.enterCd);
						map.put("fileSeq", fileSeqArr[0]);
						map.put("seqNo", seqNoArr[0]);

						deleteList.add(jFileUploadService.fileSearchBySeqNo(map));
					}


					ibFileDelete(deleteList);
				}
			} catch (Exception e) {
				Log.Debug(e.getLocalizedMessage());
				throw e;
			}
		}
	}

	protected String getBrowser(HttpServletRequest request) {
		/*
		String header = request.getHeader("User-Agent");
		if (header != null) {
			if (header.indexOf("Trident") > -1) {
				return "MSIE";
			} else if (header.indexOf("Chrome") > -1) {
				return "Chrome";
			} else if (header.indexOf("Opera") > -1) {
				return "Opera";
			} else if (header.indexOf("iPhone") > -1 && header.indexOf("Mobile") > -1) {
				return "iPhone";
			} else if (header.indexOf("Android") > -1 && header.indexOf("Mobile") > -1) {
				return "Android";
			}
		}
		return "Firefox";
		*/
		return HttpUtils.getBrowser(request);
	}

	protected String getEncodedFilename(String filename, String browser) throws Exception {
		/*
		String dispositionPrefix = "attachment;filename=";
		// String getDecodedFilename = "attachment;filename=";
		String encodedFilename = null;
		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		} else {
			throw new RuntimeException("Not supported browser");
		}

		return dispositionPrefix + encodedFilename;
		*/
		//return HttpUtils.getEncodedFilenameAddPrefix(filename, browser, "attachment;filename=");
		// [2021.08.31] 파일명에 쉼표가 포함된 경우 IE 브라우저외 브라우저에서 다운로드 안되는 현상 수정
		return HttpUtils.getEncodedFilenameAddPrefix(filename.replace(",", "_"), browser, "attachment;filename=");
	}

	public JSONArray copy(String targetUploadType, String[] fileSeqArr, String[] seqNoArr) throws Exception {
		JSONArray jsonArray = new JSONArray();

		if(fileSeqArr != null && fileSeqArr.length > 0) {
			WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
			JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

			String newFileSeq = jFileUploadService.jFileSequence();

			Map<String, Object> tsys200Map = new HashMap<String, Object>();
			Map<String, Object> tsys201Map = new HashMap<String, Object>();
			Map<String, Object> tsys202Map = new HashMap<String, Object>();

			List<Map<?, ?>> tsys201List = new ArrayList<Map<?, ?>>();
			List<Map<?, ?>> tsys202List = new ArrayList<Map<?, ?>>();

			tsys200Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			tsys200Map.put("fileSeq", newFileSeq);
			tsys200Map.put("ssnSabun", session.getAttribute("ssnSabun"));

			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(targetUploadType, request, response);

			for(int i = 0; i < fileSeqArr.length; i++) {
				String fileSeq = fileSeqArr[i];
				String seqNo = seqNoArr[i];

				Map<String, Object> map = new HashMap<String, Object>();
				map.put("ssnEnterCd", this.enterCd);
				map.put("fileSeq", fileSeq);
				map.put("seqNo", seqNo);

				Map<?, ?> paramMap = jFileUploadService.fileSearchBySeqNo(map);
				InputStream is = filedownload(paramMap);
				tsys201Map.put("fileSeq", newFileSeq);
				fileHandler.fileupload(is, (String) paramMap.get("rFileNm"), tsys200Map, tsys201Map, tsys202Map, i);
				tsys201List.add(tsys201Map);

				JSONObject jsonObject = new JSONObject();
				jsonObject.put("fileSeq", newFileSeq);
				jsonObject.put("seqNo", i);
				jsonObject.put("rFileNm", tsys201Map.get("rFileNm"));
				jsonObject.put("sFileNm", tsys201Map.get("sFileNm"));
				jsonObject.put("fileSize", tsys201Map.get("fileSize"));
				jsonArray.put(jsonObject);


				if(tsys202Map.size() > 0) {
					tsys202List.add(tsys202Map);
				}
			}

			boolean result = jFileUploadService.fileStoreSave(tsys200Map, tsys201List, tsys202List);

			if (!result) {
				throw new Exception("fileCopy falied");
			}
		}

		return jsonArray;
	}
	
	
	public JSONArray ibupload(String cmd, List<Map<String, Object>> ibFileList) throws Exception {
		
		synchronized (lockObj) {
			if (ServletFileUpload.isMultipartContent(request)) {
				init();

				DiskFileItemFactory factory = new DiskFileItemFactory();
				factory.setSizeThreshold(DISK_THRESHOLD_SIZE);

				File uploadDir = new File(config.getTempDir());
				if (!uploadDir.exists()) {
					uploadDir.mkdirs();
				}

				factory.setRepository(uploadDir);

				ServletFileUpload sUpload = new ServletFileUpload(factory);
				sUpload.setFileSizeMax(Long.valueOf(config.getProperty(FileUploadConfig.POSTFIX_FILE_SIZE)));

//				List<FileItem> fList = sUpload.parseRequest(request);
				
				
				List<MultipartFile> fList = new ArrayList<MultipartFile>();
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
				Iterator<String> it = multipartRequest.getFileNames();
				while(it.hasNext()) {
				    List<MultipartFile> list = multipartRequest.getFiles(it.next().toString());
				    for(MultipartFile f : list) {
				    	fList.add(f);
				    }
				}
				
				
				
				File toDir = null;
				FileOutputStream fo = null;

				try {
					JSONArray jsonArray = new JSONArray();

					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");
					Iterator<MultipartFile> fIt = fList.iterator();

					String fileCnt = config.getProperty(FileUploadConfig.POSTFIX_FILE_COUNT);
					int totFileCnt = Integer.valueOf(fileCnt != null && !"".equals(fileCnt) ? fileCnt : "0");
					String fileSeq = request.getParameter("fileSeq");

					if (fIt != null) {
						//int curFileCnt = fList.size();
						int curFileCnt = 0;
//						for (MultipartFile item : fList) {
//							if (!item.isFormField()) {
//								curFileCnt++;
//							}
//						}

						int realCnt = 0;
						Map<String, Object> tsys200Map = null;
						boolean isMaster = false;

						if (fileSeq != null && !"".equals(fileSeq)) {
							Map<String, Object> paramMap = new HashMap<String, Object>();
							paramMap.put("ssnEnterCd", this.enterCd);

							SecurityMgrService securityMgrService = (SecurityMgrService) webAppCtxt.getBean("SecurityMgrService");
							String encryptKey = securityMgrService.getEncryptKey(this.enterCd);
							fileSeq = CryptoUtil.decrypt(encryptKey, fileSeq);
							paramMap.put("fileSeq", fileSeq);

							Map<?, ?> map = jFileUploadService.jFileCount(paramMap);

							if (map != null) {
								isMaster = true;
								String cnt = String.valueOf(map.get("cnt"));
								realCnt = Integer.valueOf(cnt != null && !"".equals(cnt) ? cnt : "0");

								// 파일 목록이 파라미터로 넘어온 경우, DB상의 파일개수 - 삭제한 파일 개수
								if(ibFileList != null) {
									realCnt -= (int) ibFileList.stream()
											.filter(file -> "D".equals(file.get("status")))
											.count();
								}

								if (totFileCnt > 0 && curFileCnt + realCnt > totFileCnt) {
									throw new FileUploadException("File Count Error!");
								}
								String mcnt = String.valueOf(map.get("mcnt"));
								realCnt = Integer.valueOf(mcnt != null && !"".equals(mcnt) ? mcnt : "0");
							}
						} else {
							fileSeq = jFileUploadService.jFileSequence();
						}

						if (!isMaster) {
							tsys200Map = new HashMap<String, Object>();
							tsys200Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
							tsys200Map.put("fileSeq", fileSeq);
							tsys200Map.put("ssnSabun", session.getAttribute("ssnSabun"));
						}

						List<Map<?, ?>> tsys201List = new ArrayList<Map<?, ?>>();
						List<Map<?, ?>> tsys202List = new ArrayList<Map<?, ?>>();

						while (fIt.hasNext()) {
							MultipartFile fItem = fIt.next();

//							if (fItem.isFormField()) {
//
//							} else {
								String itemName = FilenameUtils.getName(fItem.getOriginalFilename());
								itemName = SecurePathUtil.sanitizeFileName(itemName); // 파일명 검증
								
								boolean isVaild = true;
								String vaildMsg = null;

								String extExtension = config.getProperty(FileUploadConfig.POSTFIX_EXT_EXTENSION);
								if (extExtension != null && !"".equals(extExtension)) {
									String[] arr = itemName.split("\\.");

									if (arr.length == 1) {
										isVaild = false;
										vaildMsg = "File Type Error! " + itemName;
									} else {
										isVaild = true;
									}

									String ext = arr[arr.length - 1];
									Pattern p = Pattern.compile(extExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
									Matcher m = p.matcher(ext);
									if (!m.matches()) {
										isVaild = false;
										vaildMsg = "File Type Error! " + itemName;
									} else {
										isVaild = true;
									}
								}
								
								if(!isVaild) {
									String mimeExtension = config.getProperty(FileUploadConfig.POSTFIX_MIME_EXTENSION);
									if (mimeExtension != null && !"".equals(mimeExtension)) {
										mimeExtension = mimeExtension.replaceAll("\\*", ".*");

										Path secureFilePath = SecurePathUtil.getSecurePath(config.getTempDir(), itemName);
										String securePath = secureFilePath.toString();
										toDir = new File(securePath);

										File upDir = toDir.getParentFile();

										if (!upDir.exists()) {
											SecurePathUtil.createSecureDirectory(config.getTempDir(), upDir.getAbsolutePath());
										}

										
										fo = new FileOutputStream(toDir);
										Streams.copy(fItem.getInputStream(), fo, true);
										fo.flush();
										
										Tika tika = new Tika();
										String mType = tika.detect(toDir);
										toDir.delete();

										Pattern p = Pattern.compile(mimeExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
										Matcher m = p.matcher(mType);
										
										if (!m.matches()) {
											isVaild = false;
											vaildMsg = "File Type Error!  " + itemName + " [" + mType + "]";
										} else {
											isVaild = true;
										}
									}
								}
								
								if(!isVaild) {
									throw new FileUploadException(vaildMsg);
								}
								
								Map<String, Object> tsys201Map = new HashMap<String, Object>();
								Map<String, Object> tsys202Map = new HashMap<String, Object>();

								tsys201Map.put("fileSeq", fileSeq);

								if(cmd.equals("ibupload")) {
									fileupload(fItem.getInputStream(), itemName, tsys200Map, tsys201Map, tsys202Map, realCnt);
									tsys201List.add(tsys201Map);

									if(tsys202Map.size() > 0) {
										tsys202Map.put("fileSeq", fileSeq);
										tsys202List.add(tsys202Map);
									}
								} else if (cmd.equals("ibFileUpload")) {
									ibFileupload(fItem.getInputStream(), itemName, tsys200Map, tsys201Map, tsys202Map, realCnt);
								}

								JSONObject jsonObject = new JSONObject();
								jsonObject.put("fileSeq", fileSeq);
								jsonObject.put("seqNo", realCnt);
								jsonObject.put("rFileNm", tsys201Map.get("rFileNm"));
								jsonObject.put("sFileNm", tsys201Map.get("sFileNm"));
								jsonObject.put("fileSize", tsys201Map.get("fileSize"));
								jsonArray.put(jsonObject);

								realCnt++;
//							}
						}

						boolean result = jFileUploadService.fileStoreSave(tsys200Map, tsys201List, tsys202List);

						if (!result) {
							throw new Exception("fileSave falied");
						}
					}

					return jsonArray;
				} catch(Exception e) {
					Log.Debug(e.getLocalizedMessage());
					throw new Exception("Saved Error!");
				} finally {
					try {
						if(fo != null) {
							fo.close();
							fo = null;
						}
					} catch (Exception ee) { Log.Debug(ee.getLocalizedMessage()); }
					try {
						if(toDir != null) {
							toDir.delete();
						}
					} catch (Exception ee) { Log.Debug(ee.getLocalizedMessage()); }

				}
			} else {
				throw new Exception("Error!");
			}
		}
		
	}

	public void downloadPdf(String filePath, String fileName) throws Exception {
		synchronized (lockObj) {
			init();

			File file = null;
			FileOutputStream fos = null;
			ZipArchiveOutputStream zos = null;
			InputStream in = null;
			OutputStream outt = null;

			try {

				String downloadName = SecurePathUtil.sanitizeFileName(fileName);
				String securePath = SecurePathUtil.getSecurePath(request.getContextPath(), filePath, downloadName).toString();

				file = new File(securePath);
				
				if (file.isFile()) {
					in = new FileInputStream(file);
	
					Tika tika = new Tika();
					String mType = tika.detect(downloadName);
	
					if ( !"".equals(mType)){
						response.setHeader("Content-Type", mType);
						response.setHeader("Content-Disposition", getEncodedFilename(downloadName, getBrowser(request)));
						response.setContentLength((int) in.available());
					}else{
						response.setHeader("Content-Type", "application/octet-stream");
						response.setHeader("Content-Disposition", getEncodedFilename(downloadName, getBrowser(request)));
						response.setContentLength((int) in.available());
					}
	
					outt = response.getOutputStream();
	
					byte b[] = new byte[1024];
					int numRead = 0;
					while ((numRead = in.read(b)) != -1) {
						outt.write(b, 0, numRead);
					}
	
					outt.flush();
					outt.close();
					outt = null;
					in.close();
					in = null;
				}else {
					throw new Exception("<script>alert('downloadPdf : The file does not exist.');</script>");
				}
			} catch (Exception e) {
				throw new Exception("<script>alert('downloadPdf : The file does not exist.');</script>");
			} finally {
				try {
					if(outt != null) {
						outt.close();
					}
				} catch (Exception ee) {}

				try {
					if(in != null) {
						in.close();
					}
				} catch (Exception ee) {}

				try {
					if(fos != null) {
						fos.close();
					}
				} catch (Exception ee) {}

				try {
					if(zos != null) {
						zos.close();
					}
				} catch (Exception ee) {}
			}
		}
	}


	/**
	 * 사진 일괄 파일 업로드
	 * @return
	 * @throws Exception
	 */
	public JSONArray photoFileUpload() throws Exception {

		synchronized (lockObj) {
			if (ServletFileUpload.isMultipartContent(request)) {
				init();

				DiskFileItemFactory factory = new DiskFileItemFactory();
				factory.setSizeThreshold(DISK_THRESHOLD_SIZE);

				File uploadDir = new File(config.getTempDir());
				if (!uploadDir.exists()) {
					uploadDir.mkdirs();
				}

				factory.setRepository(uploadDir);

				ServletFileUpload sUpload = new ServletFileUpload(factory);
				sUpload.setFileSizeMax(Long.valueOf(config.getProperty(FileUploadConfig.POSTFIX_FILE_SIZE)));

				//List<FileItem> fList = sUpload.parseRequest(request);
				List<MultipartFile> fList = new ArrayList<MultipartFile>();
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
				Iterator<String> it = multipartRequest.getFileNames();
				while(it.hasNext()) {
					List<MultipartFile> list = multipartRequest.getFiles(it.next().toString());
					for(MultipartFile f : list) {
						fList.add(f);
					}
				}

				File toDir = null;
				FileOutputStream fo = null;

				try {
					JSONArray jsonArray = new JSONArray();

					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");
					Iterator<MultipartFile> fIt = fList.iterator();

					String fileCnt = config.getProperty(FileUploadConfig.POSTFIX_FILE_COUNT);
					int totFileCnt = Integer.valueOf(fileCnt != null && !"".equals(fileCnt) ? fileCnt : "0");
					String fileSeq = request.getParameter("fileSeq");
					totFileCnt =100; //지금 picture 업로드popup의 첨부 파일 max 가 1개라서 100개로 임의로 세팅

					if (fIt != null) {
						//int curFileCnt = fList.size();
						int curFileCnt = 0;
						for (MultipartFile item : fList) {
							if (item.getOriginalFilename() != null && !"".equals(item.getOriginalFilename())) {
								curFileCnt++;
							}
						}

						int realCnt = 0;
						Map<String, Object> tsys200Map = null;
						boolean isMaster = false;

						if (fileSeq != null && !"".equals(fileSeq)) {
							Map<String, Object> paramMap = new HashMap<String, Object>();
							paramMap.put("ssnEnterCd", this.enterCd);
							paramMap.put("fileSeq", fileSeq);
							Map<?, ?> map = jFileUploadService.jFileCount(paramMap);

							if (map != null) {
								isMaster = true;
								String cnt = String.valueOf(map.get("cnt"));
								realCnt = Integer.valueOf(cnt != null && !"".equals(cnt) ? cnt : "0");

								if (totFileCnt > 0 && curFileCnt + realCnt > totFileCnt) {
									throw new FileUploadException("File Count Error!");
								}
								String mcnt = String.valueOf(map.get("mcnt"));
								realCnt = Integer.valueOf(mcnt != null && !"".equals(mcnt) ? mcnt : "0");
							}
						} else {
							fileSeq = jFileUploadService.jFileSequence();
						}

						//if (!isMaster) {
						tsys200Map = new HashMap<String, Object>();
						tsys200Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
						tsys200Map.put("fileSeq", fileSeq);
						tsys200Map.put("ssnSabun", session.getAttribute("ssnSabun"));
						//}

						List<Map<?, ?>> tsys201List = new ArrayList<Map<?, ?>>();
						List<Map<?, ?>> tsys202List = new ArrayList<Map<?, ?>>();

						List<Map<?, ?>> thrm911List = new ArrayList<Map<?, ?>>();  //thrm911
						List<Map<?, ?>> empPictureList = new ArrayList<Map<?, ?>>();  //EMPLOYEE_PICTURE


						while (fIt.hasNext()) {
							MultipartFile fItem = fIt.next();

							String itemName = FilenameUtils.getName(fItem.getOriginalFilename());
							itemName = SecurePathUtil.sanitizeFileName(itemName); // 파일명 검증

							boolean isVaild = true;
							String vaildMsg = null;

							String extExtension = config.getProperty(FileUploadConfig.POSTFIX_EXT_EXTENSION);
							if (extExtension != null && !"".equals(extExtension)) {
								String[] arr = itemName.split("\\.");

								if (arr.length == 1) {
									isVaild = false;
									vaildMsg = "File Type Error! " + itemName;
								} else {
									isVaild = true;
								}

								String ext = arr[arr.length - 1];
								Pattern p = Pattern.compile(extExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
								Matcher m = p.matcher(ext);
								if (!m.matches()) {
									isVaild = false;
									vaildMsg = "File Type Error! " + itemName;
								} else {
									isVaild = true;
								}
							}

							if(!isVaild) {
								String mimeExtension = config.getProperty(FileUploadConfig.POSTFIX_MIME_EXTENSION);
								if (mimeExtension != null && !"".equals(mimeExtension)) {
									mimeExtension = mimeExtension.replaceAll("\\*", ".*");

									Path secureFilePath = SecurePathUtil.getSecurePath(config.getTempDir(), itemName);
									String securePath = secureFilePath.toString();
									toDir = new File(securePath);

									File upDir = toDir.getParentFile();

									if (!upDir.exists()) {
										SecurePathUtil.createSecureDirectory(config.getTempDir(), upDir.getAbsolutePath());
									}

									fo = new FileOutputStream(toDir);
									Streams.copy(fItem.getInputStream(), fo, true);
									fo.flush();

									Tika tika = new Tika();
									String mType = tika.detect(toDir);
									toDir.delete();

									Pattern p = Pattern.compile(mimeExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
									Matcher m = p.matcher(mType);

									if (!m.matches()) {
										isVaild = false;
										vaildMsg = "File Type Error!  " + itemName + " [" + mType + "]";
									} else {
										isVaild = true;
									}
								}
							}

							if(!isVaild) {
								throw new FileUploadException(vaildMsg);
							}

							Map<String, Object> tsys201Map = new HashMap<String, Object>();

							Map<String, Object> thrm911Map = new HashMap<String, Object>();   //thrm911
							Map<String, Object> empPictureMap = new HashMap<String, Object>(); //EMPLOYEE_PICTURE

							Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");

							Log.Debug("fItem.getInputStream()"+fItem.getInputStream());
							Log.Debug("itemName"+itemName);
							Log.Debug("tsys200Map"+tsys200Map);
							Log.Debug("tsys201Map"+tsys201Map);
							Log.Debug("realCnt"+realCnt);

							Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");

							fileuploadPhoto(fItem.getInputStream(), itemName, tsys200Map, tsys201Map, realCnt);
							tsys201Map.put("fileSeq", fileSeq);
							tsys201List.add(tsys201Map);

							//thrm911 data
							thrm911Map.put("gubun" ,"1");
							thrm911Map.put("fileSeq" ,fileSeq);
							thrm911Map.put("seqNo" ,realCnt);
							thrm911Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
							thrm911Map.put("sabun", tsys201Map.get("pSabun"));
							thrm911Map.put("ssnSabun", session.getAttribute("ssnSabun"));

							thrm911List.add(thrm911Map);

							//picture data  start
							//String path    = request.getSession().getServletContext().getRealPath("/") + "/hrfile/"+session.getAttribute("ssnEnterCd")+"/picture/" + tsys201Map.get("sFileNm");
							// String path = (this.config.getDiskPath().length() == 0 ? ClassPathUtils.getClassPathHrfile() : this.config.getDiskPath() + "/")
							// 		+ session.getAttribute("ssnEnterCd")+"/picture/"+tsys201Map.get("sFileNm");

							Path secureFilePath = null;
							if(this.config.getDiskPath().isEmpty()) {
								secureFilePath = SecurePathUtil.getSecurePath(ClassPathUtils.getClassPathHrfile(), session.getAttribute("ssnEnterCd").toString(), "picture", tsys201Map.get("sFileNm").toString());
							} else {
								secureFilePath = SecurePathUtil.getSecurePath(this.config.getDiskPath(), session.getAttribute("ssnEnterCd").toString(), "picture", tsys201Map.get("sFileNm").toString());
							}

							String securePath = secureFilePath.toString();


							File imgFile =  new  File(securePath);
							FileInputStream ifo = new FileInputStream(imgFile);
							ByteArrayOutputStream baos = new ByteArrayOutputStream();

							byte[] buf = new byte[1024];
							int readlength = 0;
							byte[] imgbuf = null;

							try {
								while( (readlength =ifo.read(buf)) != -1 )
								{
									baos.write(buf,0,readlength);
								}
								imgbuf = baos.toByteArray();
							}finally {
								try {
									baos.close();
								}catch (IOException ie){
									Log.Debug("ByteArrayOutputStream CLOSE FAIL");
								}
								try {
									ifo.close();
								}catch (IOException ie){
									Log.Debug("FileInputStream CLOSE FAIL");
								}
							}

							empPictureMap.put("sabun", tsys201Map.get("pSabun"));
							empPictureMap.put("empPicture", imgbuf);
							empPictureMap.put("empPictureC", Base64.getEncoder().encodeToString(FileUtil.imageToByteArray(imgFile)));

							empPictureList.add(empPictureMap);
							//picture data  end


							JSONObject jsonObject = new JSONObject();
							jsonObject.put("fileSeq", fileSeq);
							jsonObject.put("seqNo", realCnt);
							jsonObject.put("rFileNm", tsys201Map.get("rFileNm"));
							jsonObject.put("sFileNm", tsys201Map.get("sFileNm"));
							jsonObject.put("fileSize", tsys201Map.get("fileSize"));
							jsonArray.put(jsonObject);

							realCnt++;
						}

						boolean result = jFileUploadService.filePhotoStoreSave(tsys200Map, tsys201List, thrm911List,empPictureList);

						if (!result) {
							throw new Exception("fileSave falied");
						}
					}

					return jsonArray;
				} catch(Exception e) {
					e.printStackTrace();
					throw new Exception("Saved Error!");
				} finally {
					try {
						if(fo != null) {
							fo.close();
							fo = null;
						}
					} catch (Exception ee) {}
					try {
						if(toDir != null) {
							toDir.delete();
						}
					} catch (Exception ee) {}

				}
			} else {
				throw new Exception("Error!");
			}
		}

	}


	/**
	 * 기록관리 일괄 파일 업로드
	 * @return
	 * @throws Exception
	 */
	public JSONArray recordFileUpload() throws Exception {

		synchronized (lockObj) {

			Map<String, String[]> ccrParamMap = request.getParameterMap();

			String[] ccrCd 		= ccrParamMap.get("ccrCd");
			String[] ccrYmd 	= ccrParamMap.get("ccrYmd");

			if (ServletFileUpload.isMultipartContent(request)) {
				init();

				DiskFileItemFactory factory = new DiskFileItemFactory();
				factory.setSizeThreshold(DISK_THRESHOLD_SIZE);

				File uploadDir = new File(config.getTempDir());
				if (!uploadDir.exists()) {
					uploadDir.mkdirs();
				}

				factory.setRepository(uploadDir);

				ServletFileUpload sUpload = new ServletFileUpload(factory);
				sUpload.setFileSizeMax(Long.valueOf(config.getProperty(FileUploadConfig.POSTFIX_FILE_SIZE)));

//				List<FileItem> fList = sUpload.parseRequest(request);
				List<MultipartFile> fList = new ArrayList<MultipartFile>();
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
				Iterator<String> it = multipartRequest.getFileNames();
				while(it.hasNext()) {
					List<MultipartFile> list = multipartRequest.getFiles(it.next().toString());
					for(MultipartFile f : list) {
						fList.add(f);
					}
				}

				File toDir = null;
				FileOutputStream fo = null;

				try {
					JSONArray jsonArray = new JSONArray();

					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");
					Iterator<MultipartFile> fIt = fList.iterator();

					String fileCnt = config.getProperty(FileUploadConfig.POSTFIX_FILE_COUNT);
					int totFileCnt = Integer.valueOf(fileCnt != null && !"".equals(fileCnt) ? fileCnt : "0");
					String fileSeq = request.getParameter("fileSeq");
					totFileCnt =100; //지금 picture 업로드popup의 첨부 파일 max 가 1개라서 100개로 임의로 세팅

					if (fIt != null) {
						//int curFileCnt = fList.size();
						int curFileCnt = 0;
						for (MultipartFile item : fList) {
							if (item.getOriginalFilename() != null && !"".equals(item.getOriginalFilename())) {
								curFileCnt++;
							}
						}

						int realCnt = 0;
						Map<String, Object> tsys200Map = null;
						boolean isMaster = false;

						if (fileSeq != null && !"".equals(fileSeq)) {
							Map<String, Object> paramMap = new HashMap<String, Object>();
							paramMap.put("ssnEnterCd", this.enterCd);
							paramMap.put("fileSeq", fileSeq);
							Map<?, ?> map = jFileUploadService.jFileCount(paramMap);

							if (map != null) {
								isMaster = true;
								String cnt = String.valueOf(map.get("cnt"));
								realCnt = Integer.valueOf(cnt != null && !"".equals(cnt) ? cnt : "0");

								if (totFileCnt > 0 && curFileCnt + realCnt > totFileCnt) {
									throw new FileUploadException("File Count Error!");
								}
								String mcnt = String.valueOf(map.get("mcnt"));
								realCnt = Integer.valueOf(mcnt != null && !"".equals(mcnt) ? mcnt : "0");
							}
						} else {
							fileSeq = jFileUploadService.jFileSequence();
						}

						if (!isMaster) {
							tsys200Map = new HashMap<String, Object>();
							tsys200Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
							tsys200Map.put("fileSeq", fileSeq);
							tsys200Map.put("ssnSabun", session.getAttribute("ssnSabun"));
						}

						List<Map<?, ?>> tsys201List = new ArrayList<Map<?, ?>>();
						List<Map<?, ?>> tsys202List = new ArrayList<Map<?, ?>>();

						List<Map<?, ?>> thrm185List = new ArrayList<Map<?, ?>>();  //thrm185


						while (fIt.hasNext()) {
							MultipartFile fItem = fIt.next();

							String itemName = FilenameUtils.getName(fItem.getOriginalFilename());
							itemName = SecurePathUtil.sanitizeFileName(itemName); // 파일명 검증

							boolean isVaild = true;
							String vaildMsg = null;

							String extExtension = config.getProperty(FileUploadConfig.POSTFIX_EXT_EXTENSION);
							if (extExtension != null && !"".equals(extExtension)) {
								String[] arr = itemName.split("\\.");

								if (arr.length == 1) {
									isVaild = false;
									vaildMsg = "File Type Error! " + itemName;
								} else {
									isVaild = true;
								}

								String ext = arr[arr.length - 1];
								Pattern p = Pattern.compile(extExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
								Matcher m = p.matcher(ext);
								if (!m.matches()) {
									isVaild = false;
									vaildMsg = "File Type Error! " + itemName;
								} else {
									isVaild = true;
								}
							}

							if(!isVaild) {
								String mimeExtension = config.getProperty(FileUploadConfig.POSTFIX_MIME_EXTENSION);
								if (mimeExtension != null && !"".equals(mimeExtension)) {
									mimeExtension = mimeExtension.replaceAll("\\*", ".*");

									Path secureFilePath = SecurePathUtil.getSecurePath(config.getTempDir(), itemName);
									String securePath = secureFilePath.toString();
									toDir = new File(securePath);

									File upDir = toDir.getParentFile();

									if (!upDir.exists()) {
										SecurePathUtil.createSecureDirectory(config.getTempDir(), upDir.getAbsolutePath());
									}

									fo = new FileOutputStream(toDir);
									Streams.copy(fItem.getInputStream(), fo, true);
									fo.flush();

									Tika tika = new Tika();
									String mType = tika.detect(toDir);
									toDir.delete();

									Pattern p = Pattern.compile(mimeExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
									Matcher m = p.matcher(mType);

									if (!m.matches()) {
										isVaild = false;
										vaildMsg = "File Type Error!  " + itemName + " [" + mType + "]";
									} else {
										isVaild = true;
									}
								}
							}

							if(!isVaild) {
								throw new FileUploadException(vaildMsg);
							}

							Map<String, Object> tsys201Map = new HashMap<String, Object>();

							Map<String, Object> thrm185Map = new HashMap<String, Object>();   //thrm185
							Map<String, Object> empPictureMap = new HashMap<String, Object>(); //EMPLOYEE_PICTURE

							Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");

							Log.Debug("fItem.getInputStream()"+fItem.getInputStream());
							Log.Debug("itemName"+itemName);
							Log.Debug("tsys200Map"+tsys200Map);
							Log.Debug("tsys201Map"+tsys201Map);
							Log.Debug("realCnt"+realCnt);

							Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");

							fileuploadRecord(fItem.getInputStream(), itemName, tsys200Map, tsys201Map, realCnt);
							tsys201Map.put("fileSeq", fileSeq);
							tsys201List.add(tsys201Map);

							// data THRM181

							String[] arr = itemName.split("\\.");
							String ext = arr[0];

							thrm185Map.put("fileSeq" ,fileSeq);
							thrm185Map.put("ccrYmd" ,ccrYmd[0]);
							thrm185Map.put("ccrCd" ,ccrCd[0]);

							thrm185Map.put("seqNo" ,realCnt);
							thrm185Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
							thrm185Map.put("sabun", ext);
							thrm185Map.put("ssnSabun", session.getAttribute("ssnSabun"));

							thrm185List.add(thrm185Map);

							JSONObject jsonObject = new JSONObject();
							jsonObject.put("fileSeq", fileSeq);
							jsonObject.put("seqNo", realCnt);
							jsonObject.put("rFileNm", tsys201Map.get("rFileNm"));
							jsonObject.put("sFileNm", tsys201Map.get("sFileNm"));
							jsonObject.put("fileSize", tsys201Map.get("fileSize"));
							jsonArray.put(jsonObject);

							realCnt++;
						}

						boolean result = jFileUploadService.fileRecordStoreSave(tsys200Map, tsys201List, thrm185List);

						if (!result) {
							throw new Exception("fileSave falied");
						}
					}

					return jsonArray;
				} catch(Exception e) {
					e.printStackTrace();
					throw new Exception("Saved Error!");
				} finally {
					try {
						if(fo != null) {
							fo.close();
							fo = null;
						}
					} catch (Exception ee) {}
					try {
						if(toDir != null) {
							toDir.delete();
						}
					} catch (Exception ee) {}

				}
			} else {
				throw new Exception("Error!");
			}
		}
	}

	/**
	 * 연말정산 pdf 파일 업로드
	 * @return
	 * @throws Exception
	 */
	public JSONArray yjungsanPdfUpload() throws Exception {

		synchronized (lockObj) {
			if (ServletFileUpload.isMultipartContent(request)) {
				//연말정산 PDF용 초기화
				initYJungsanPdf();

				DiskFileItemFactory factory = new DiskFileItemFactory();

				factory.setSizeThreshold(DISK_THRESHOLD_SIZE);
				File uploadDir = new File(config.getTempDir());

				if (!uploadDir.exists()) {
					uploadDir.mkdirs();
				}

				factory.setRepository(uploadDir);
				ServletFileUpload sUpload = new ServletFileUpload(factory);
				sUpload.setFileSizeMax(Long.valueOf(config.getProperty(FileUploadConfig.POSTFIX_FILE_SIZE)));

				List<FileItem> fList = sUpload.parseRequest(request);
				File toDir = null;
				FileOutputStream fo = null;

				try {
					JSONArray jsonArray = new JSONArray();
					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");
					Iterator<FileItem> fIt = fList.iterator();
					String fileCnt = config.getProperty(FileUploadConfig.POSTFIX_FILE_COUNT);
					if (fIt != null) {
						//int curFileCnt = fList.size();

						int realCnt = 0;
						List<Map<?, ?>> tyea105List = new ArrayList<Map<?, ?>>();
						while (fIt.hasNext()) {

							FileItem fItem = fIt.next();
							String[] arr = null;
							String[] infoArr = null;
							if (fItem.isFormField()) {

							} else {
								String itemName = FilenameUtils.getName(fItem.getName());
								itemName = SecurePathUtil.sanitizeFileName(itemName); // 파일명 검증
								boolean isVaild = true;
								String vaildMsg = null;
								String extExtension = config.getProperty(FileUploadConfig.POSTFIX_EXT_EXTENSION);
								if (extExtension != null && !"".equals(extExtension)) {
									arr = itemName.split("\\.");
									if (arr.length == 1) {
										isVaild = false;
										vaildMsg = "File Type Error! " + itemName;
									} else {
										isVaild = true;
									}
									String ext = arr[arr.length - 1];
									Pattern p = Pattern.compile(extExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
									Matcher m = p.matcher(ext);
									if (!m.matches()) {
										isVaild = false;
										vaildMsg = "File Type Error! " + itemName;
									} else {
										isVaild = true;
									}
								}

								if(!isVaild) {
									String mimeExtension = config.getProperty(FileUploadConfig.POSTFIX_MIME_EXTENSION);
									if (mimeExtension != null && !"".equals(mimeExtension)) {
										mimeExtension = mimeExtension.replaceAll("\\*", ".*");
										String securePath = SecurePathUtil.getSecurePath(config.getTempDir(), itemName).toString();
										toDir = new File(securePath);
										File upDir = toDir.getParentFile();

										if (!upDir.exists()) {
											SecurePathUtil.createSecureDirectory(config.getTempDir(), upDir.getAbsolutePath());
										}
										fo = new FileOutputStream(toDir);
										Streams.copy(fItem.getInputStream(), fo, true);
										fo.flush();
										Tika tika = new Tika();
										String mType = tika.detect(toDir);
										toDir.delete();
										Pattern p = Pattern.compile(mimeExtension.replaceAll(",", "|"), Pattern.CASE_INSENSITIVE);
										Matcher m = p.matcher(mType);
										if (!m.matches()) {
											isVaild = false;
											vaildMsg = "File Type Error!  " + itemName + " [" + mType + "]";
										} else {
											isVaild = true;
										}
									}
								}

								if(!isVaild) {
									throw new FileUploadException(vaildMsg);
								}


								if(arr.length > 1) {

									infoArr = arr[0].split("_"); //[0]:년도, [1]:사번, [2]:성명

									Map<String, Object> tyea105Map = new HashMap<String, Object>();

									tyea105Map.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
									tyea105Map.put("ssnSabun", session.getAttribute("ssnSabun"));

									tyea105Map.put("workYy", infoArr[0]);
									tyea105Map.put("sabun", infoArr[1]);
									fileuploadYJungsanPdf(fItem.getInputStream(), itemName, tyea105Map, realCnt);
									tyea105List.add(tyea105Map);
									JSONObject jsonObject = new JSONObject();
									jsonArray.put(jsonObject);

									realCnt++;
								}

							}
						}
						boolean result = jFileUploadService.yjungsanPdfSave(tyea105List);

						if (!result) {
							throw new Exception("fileSave falied");
						}
					}

					return jsonArray;
				} catch(Exception e) {
					e.printStackTrace();
					throw new Exception("Saved Error!");
				} finally {
					try {
						if(fo != null) {
							fo.close();
							fo = null;
						}
					} catch (Exception ee) {}
					try {
						if(toDir != null) {
							toDir.delete();
						}
					} catch (Exception ee) {}

				}
			} else {
				throw new Exception("Error!");
			}
		}

	}

	public void downloadYJungsanPdf(String[] filePathArr, String[] fileNameArr, String[] attr1Arr) throws Exception {

		synchronized (lockObj) {

			//init();
			//연말정산 PDF용 초기화
			initYJungsanPdf();

			File zipFile 				= null;
			FileOutputStream fos 		= null;
			ZipArchiveOutputStream zos 	= null;
			InputStream in 				= null;
			OutputStream outt 			= null;
			List<Map<?, ?>> outputList 	= null;

			//Log.Debug("=====================================================================================");
			//Log.Debug("=====================AbsFileHandler.downloadYJungsanPdf==============================");
			//Log.Debug("=====================================================================================");
			//Log.Debug("=====================================================================================");

			try {
				if(fileNameArr != null) {
					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

					if(fileNameArr != null && fileNameArr.length > 0) {
						String downloadName = null;

						// 파일이 1개인 경우
						if(fileNameArr.length == 1) {

							Map<String, Object> resultMap = new HashMap<String,Object>();

							resultMap.put("filePath", filePathArr[0]);
							resultMap.put("rFileNm", fileNameArr[0]);
							resultMap.put("sFileNm", attr1Arr[0]);

							downloadName = SecurePathUtil.sanitizeFileName(StringUtil.stringValueOf(resultMap.get("rFileNm")));

							in = filedownloadYJungsanPdf(resultMap);

							// 파일이 여러개인 경우
						} else {
							downloadName = getTimeStemp() + ".zip";
							Path secureZipPath = SecurePathUtil.getSecurePath(config.getTempDir(), downloadName);
							String securePath = secureZipPath.toString();
							zipFile = new File(securePath);

							File upDir = zipFile.getParentFile();

							if(!upDir.isDirectory()) {
								upDir.mkdirs();
							}

							fos = new FileOutputStream(zipFile);
							zos = new ZipArchiveOutputStream(fos);

							for(int i = 0 ; i < fileNameArr.length ; i++) {

								Map<String, Object> resultMap = new HashMap<String,Object>();

								//Log.Debug("=====================================================================================");
								//Log.Debug("=====================================================================================");
								//Log.Debug("========================================AbsFileHandler.fileNameArr[i] : "+fileNameArr[i]);
								//Log.Debug("========================================i : "+i);
								//Log.Debug("========================================fileNameArr.length : "+fileNameArr.length);
								//Log.Debug("=====================================================================================");
								//Log.Debug("=====================================================================================");

								resultMap.put("filePath", filePathArr[i]);
								resultMap.put("rFileNm", fileNameArr[i]);
								resultMap.put("sFileNm", attr1Arr[i]);

								//Log.Debug("=====================================================================================");
								//Log.Debug("========================================AbsFileHandler.resultMap : "+resultMap.toString());
								//Log.Debug("========================================AbsFileHandler.sFileNm : "+resultMap.get("sFileNm"));
								//Log.Debug("=====================================================================================");

								addEntry(zos, filedownloadYJungsanPdf(resultMap), String.valueOf(fileNameArr[i]));
							}

							zos.close();
							zos = null;
							fos.close();
							fos = null;

							in = new FileInputStream(zipFile);
							zipFile.delete();

						}


						if(in == null) {
							throw new Exception("<script>alert('download : The file does not exist.');</script>");
						}

						Tika tika = new Tika();
						String mType = tika.detect(downloadName);

						response.setHeader("Content-Type", "application/octet-stream");
						response.setHeader("Content-Disposition", getEncodedFilename(downloadName, getBrowser(request)));
						response.setContentLength((int) in.available());

						outt = response.getOutputStream();

						byte b[] = new byte[1024];
						int numRead = 0;
						while ((numRead = in.read(b)) != -1) {
							outt.write(b, 0, numRead);
						}

						outt.flush();
						outt.close();
						outt = null;
						in.close();
						in = null;

					}

				}
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			} finally {
				try {
					if(outt != null) {
						outt.close();
					}
				} catch (Exception ee) {}

				try {
					if(in != null) {
						in.close();
					}
				} catch (Exception ee) {}

				try {
					if(fos != null) {
						fos.close();
					}
				} catch (Exception ee) {}

				try {
					if(zos != null) {
						zos.close();
					}
				} catch (Exception ee) {}

				if(zipFile != null && zipFile.exists()) {
					zipFile.delete();
				}
			}
		}

	}

	public void deleteYJungsanPdf() throws Exception {
		synchronized(lockObj) {

			//init();
			//연말정산 PDF용 초기화
			initYJungsanPdf();

			Map<String, String[]> paramMap = request.getParameterMap();

			String[] workYyArr 		= paramMap.get("workYy");
			String[] fileTypeArr 	= paramMap.get("fileType");
			String[] adjustTypeArr 	= paramMap.get("adjustType");
			String[] fileSeqArr 	= paramMap.get("fileSeq");
			//String[] fileNameArr 	= paramMap.get("fileName");
			String[] fileNameArr 	= paramMap.get("attr1");
			String[] sabunArr 		= paramMap.get("sabun");
			String[] filePathArr 	= paramMap.get("filePath");

			try {
				if(fileSeqArr != null) {
					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");

					List<Map<?, ?>> deleteList = new ArrayList<Map<?,?>>();

					for(int i = 0 ; i < fileSeqArr.length ; i++) {
						Map<String, Object> map = new HashMap<String, Object>();
						map.put("ssnEnterCd", this.enterCd);
						map.put("workYy", workYyArr[i]);
						map.put("fileSeq", fileSeqArr[i]);
						map.put("fileType", fileTypeArr[i]);
						map.put("adjustType", adjustTypeArr[i]);
						map.put("sabun", sabunArr[i]);
						map.put("filePath", filePathArr[i]);
						map.put("fileName", fileNameArr[i]);

						deleteList.add((Map<?, ?>) map);

						jFileUploadService.yjungsanPdfDelete(deleteList);
					}

					filedeleteYJungsanPdf(deleteList);
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			}
		}
	}

	public void loadView() throws Exception {
		loadView(false);
	}

	public void loadView(boolean isDirectView) throws Exception {
		Map<String, String[]> paramMap = request.getParameterMap();
		String[] fileSeqArr = paramMap.get("fileSeq");
		String[] seqNoArr = paramMap.get("seqNo");

		download(isDirectView, fileSeqArr, seqNoArr);
	}

	public void loadView(boolean isDirectView, String[] fileSeqArr, String[] seqNoArr) throws Exception {
		synchronized (lockObj) {
			init();

			InputStream in = null;
			OutputStream out = null;

			try {
				if (fileSeqArr != null && fileSeqArr.length > 0) {
					WebApplicationContext webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
					JFileUploadService jFileUploadService = (JFileUploadService) webAppCtxt.getBean("JFileUploadService");
					List<Map<?, ?>> outputList = new ArrayList<>();

					for (int i = 0; i < fileSeqArr.length; i++) {
						String fileSeq = fileSeqArr[i];
						if (fileSeq == null || "".equals(fileSeq)) {
							continue;
						}

						Map<String, Object> map = new HashMap<>();
						map.put("ssnEnterCd", this.enterCd);
						map.put("fileSeq", fileSeq);

						if (seqNoArr == null) {
							Collection<?> resultList = jFileUploadService.fileSearchByFileSeq(map);
							for (Object listItem : resultList) {
								outputList.add((Map<?, ?>) listItem);
							}
						} else {
							String seqNo = seqNoArr[i];
							if (seqNo == null || "".equals(seqNo)) {
								continue;
							}
							map.put("seqNo", seqNo);

							// Ib File Upload 임시저장 상태인 파일 다운로드 시도하는 경우.
							if(seqNo.equals("temp")) {
								Map<String, String[]> paramMap = request.getParameterMap();
								String[] sFileNmArr = paramMap.get("sFileNm");
								String[] rFileNmArr = paramMap.get("rFileNm");
								Map tempFile = new HashMap<>();
								tempFile.put("fileSeq", fileSeq);
								tempFile.put("filePath", "");
								tempFile.put("sFileNm", sFileNmArr[i]);
								tempFile.put("rFileNm", rFileNmArr[i]);
								outputList.add(tempFile);
							} else {
								Map<?, ?> resultMap = jFileUploadService.fileSearchBySeqNo(map);
								if (resultMap != null) {
									outputList.add(resultMap);
								}
							}
						}
					}

					if (outputList.size() == 1) {
						Map<?, ?> resultMap = outputList.get(0);
						String downloadName = SecurePathUtil.sanitizeFileName(StringUtil.stringValueOf(resultMap.get("rFileNm")));
						in = filedownload(resultMap);

						// Determine the file extension and set content type accordingly
						String fileExt = downloadName.substring(downloadName.lastIndexOf('.') + 1).toLowerCase();
						switch (fileExt) {
							case "png":
							case "jpg":
							case "jpeg":
							case "gif":
							case "bmp":
								response.setContentType("image/" + fileExt);
								break;
							case "pdf":
								response.setContentType("application/pdf");
								break;
							default:
								response.setContentType("application/octet-stream");
						}

						// 한글 파일명 인코딩 처리
						String encodedFilename = URLEncoder.encode(downloadName, "UTF-8").replaceAll("\\+", "%20");  // 공백 문자 처리

						// RFC 5987 방식으로 Content-Disposition 헤더 설정
						String contentDisposition = String.format("inline; filename=\"%s\"; filename*=UTF-8''%s",
								downloadName.replaceAll("[^a-zA-Z0-9.-]", "_"),  // fallback 파일명
								encodedFilename);

						response.setHeader("Content-Disposition", "inline; filename=\"" + contentDisposition + "\"");
						response.setContentLength(in.available());

						out = response.getOutputStream();
						byte[] buffer = new byte[1024];
						int numRead;
						while ((numRead = in.read(buffer)) != -1) {
							out.write(buffer, 0, numRead);
						}
						out.flush();
					} else {
						throw new Exception("<script>alert('downloadPdf : The file does not exist.');</script>");
					}
				} else {
					throw new Exception("<script>alert('downloadPdf : The file does not exist.');</script>");
				}
			} catch (Exception e) {
				e.printStackTrace();
				throw e;
			} finally {
				try {
					if (out != null) {
						out.close();
					}
					if (in != null) {
						in.close();
					}
				} catch (Exception ignored) {
				}
			}
		}
	}


}
