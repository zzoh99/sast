package com.hr.common.aop;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.DateUtil;
import com.hr.common.util.SessionUtil;
import com.hr.common.util.StringUtil;
import com.hr.common.util.classPath.ClassPathUtils;
import com.hr.common.util.fileupload.impl.FileUploadConfig;
import com.hr.common.util.fileupload.jfileupload.web.JFileUploadService;
import com.nhncorp.lucy.security.xss.XssPreventer;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Aspect
public class FileUploadAspect {

	private final String FILE_LIST_ARR_NAME = "ibFileListArr"; // 탐색할 filInfo Parameter name

	private FileUploadConfig config;

	@Inject
	@Named("JFileUploadService")
	private JFileUploadService jFileUploadService;

	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;

	@Autowired
	private HttpServletRequest request;

	@Around("execution(* com.hr..*Controller.*(..))")
	public Object copyToWorkDir(ProceedingJoinPoint joinPoint) throws Throwable {

		for (Object arg : joinPoint.getArgs()) {
			if (arg instanceof Map) {

				Map<?, ?> mapArg = (Map<?, ?>) arg;
				boolean containsFileList = false;
				String msg = "";
				int code = 0;

				for (Object key : mapArg.keySet()) {
					if (key instanceof String) {
						// 맵의 키 이름에 FILE_SEQ_ARR_NAME, FILE_PATH_ARR_NAME 값이 포함되어 있으면 file copy 작업 실행
						containsFileList = key.toString().equals(FILE_LIST_ARR_NAME);

						if(containsFileList) {
							Log.Debug("Start copy file temp to work directory !");
							String ibFileListStr = XssPreventer.unescape(mapArg.get(FILE_LIST_ARR_NAME).toString());
							ObjectMapper objectMapper = new ObjectMapper();
							try {
								if (!ibFileListStr.isEmpty()) {
									// JSON 문자열을 List<Map<String, Object>>로 변환
									List<Map<String, Object>> paramList = objectMapper.readValue(ibFileListStr, new TypeReference<List<Map<String, Object>>>() {
									});

									// 변환된 객체 출력 (혹은 다른 로직 수행)
									for (Map<String, Object> param : paramList) {
										String fileSeq = param.get("fileSeq").toString();
										String uploadType = param.get("uploadType").toString();

										if (!fileSeq.isEmpty()) {
											config = new FileUploadConfig(uploadType);
											try {
												// fileSeq 복호화
												String enterCd = SessionUtil.getRequestAttribute("ssnEnterCd").toString();
												String ssnSabun = SessionUtil.getRequestAttribute("ssnSabun").toString();
												String encryptKey = securityMgrService.getEncryptKey(enterCd);
												fileSeq = CryptoUtil.decrypt(encryptKey, fileSeq);

												// tempPath\fileSeq 경로 가져오기
												String tempPath = config.getTempDir();
												String sourcePath = StringUtil.replaceAll(tempPath + "/" + fileSeq, "//", "/");
												Path source = Paths.get(sourcePath);

												// 복사 대상 경로 가져오기.
												// storePath\fileSeq 경로
												String targetPath = getUploadPath(enterCd, fileSeq);
												//String targetPath = StringUtil.replaceAll(diskPath + "/" + enterCd + "/" + storePath + "/" + fileSeq, "//", "/");
												Path target = Paths.get(targetPath);

												// file list 가져오기

												List<Map<String, Object>> fileList = (List<Map<String, Object>>) param.get("fileList");

												// temp 폴더 경로 있을 때만 복사 작업 시작
												if (Files.exists(source)) {
													// temp -> target으로 파일 이동
													Files.createDirectories(target);
													Files.walkFileTree(source, new SimpleFileVisitor<Path>() {
														@Override
														public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
															// fileList에 있는 파일만 이동
															boolean shouldMove = fileList.stream()
																	.anyMatch(fileMap -> file.getFileName().toString().equals(fileMap.get("savedName")));

															if (shouldMove) {
																Path targetFile = target.resolve(source.relativize(file));
																Files.move(file, targetFile, StandardCopyOption.REPLACE_EXISTING);
															} else {
																// 이동하지 않는 파일은 삭제
																Files.delete(file);
															}
															return FileVisitResult.CONTINUE;
														}

														@Override
														public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
															Path targetDirPath = target.resolve(source.relativize(dir));
															if (!Files.exists(targetDirPath)) {
																Files.createDirectory(targetDirPath);
															}
															return FileVisitResult.CONTINUE;
														}

														@Override
														public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
															Files.delete(dir);
															return FileVisitResult.CONTINUE;
														}
													});
												}

												// seqNo 구하기
												Map paramMap = new HashMap();
												paramMap.put("ssnEnterCd", enterCd);
												paramMap.put("fileSeq", fileSeq);
												Map<?, ?> seqNoMap = jFileUploadService.jFileCount(paramMap);

												// 새로 추가한 파일 목록 가져와서 DB Insert 작업 수행
												if(seqNoMap != null) {
													String cnt = String.valueOf(seqNoMap.get("mcnt"));
													int seqNo = Integer.valueOf(cnt != null && !"".equals(cnt) ? cnt : "0");
													
													List<Map<?, ?>> insFileList = new ArrayList<>();
													
													// 신규 입력 file list 가져오기
													for (Map<?, ?> file : fileList) {
														if ("I".equals(file.get("status"))) {
															Map<String, Object> newFile = new HashMap<>();
															newFile.put("ssnEnterCd", file.get("enterCd"));
															if (file.containsKey("fileSeq")) {
																newFile.put("fileSeq", CryptoUtil.decrypt(encryptKey, file.get("fileSeq").toString()));
															}
															newFile.put("seqNo", seqNo++);
															newFile.put("sFileNm", file.get("savedName"));
															newFile.put("rFileNm", file.get("name"));
															newFile.put("fileSize", file.get("size"));
															newFile.put("ssnSabun", ssnSabun);

															insFileList.add(newFile);
														}
													}

													// file list 정보 DB Insert 작업
													if (!jFileUploadService.fileStoreSave(null, insFileList, null)) {
														Log.Debug("save data error!");

														msg = "파일업로드 오류! 데이터 입력에 실패했습니다.";
														code = -1;
														ModelAndView mv = new ModelAndView();
														mv.setViewName("jsonView");
														mv.addObject("Code", code);
														mv.addObject("Message", msg);
														return mv;
													}
												}

												// file list 에 존재 하지 않는 파일 삭제 처리.
												List<Map<?, ?>> delFileList
														= fileList.stream()
														.filter(file -> "D".equals(file.get("status")))
														.map(file -> {
															if (file.containsKey("url")) {
																file.put("seqNo", file.get("url"));
															}
															if (file.containsKey("fileSeq")) {
																file.put("fileSeq", CryptoUtil.decrypt(encryptKey, file.get("fileSeq").toString()));
															}
															return file;
														})
														.collect(Collectors.toList());

												// 삭제 해야 할 파일 목록이 있는 경우 작업
												if (!delFileList.isEmpty()) {
													if (!jFileUploadService.fileStoreDelete(delFileList, false)) {
														Log.Debug("delete data error!");

														msg = "파일업로드 오류! 데이터 삭제에 실패했습니다.";
														code = -1;
														ModelAndView mv = new ModelAndView();
														mv.setViewName("jsonView");
														mv.addObject("Code", code);
														mv.addObject("Message", msg);
														return mv;
													}

													for (Map<?, ?> delFile : delFileList) {
														String delTargetPath = getTargetPath(enterCd);
														// 삭제시 DB에 실제 저장된 경로의 파일을 삭제하도록 한다.
														delTargetPath = StringUtil.replaceAll(delTargetPath + "/" + delFile.get("filePath").toString() + "/" , "//", "/");
														File targetFolder = new File(delTargetPath);
														if (targetFolder.exists() && targetFolder.isDirectory()) {
															File[] files = targetFolder.listFiles();
															if (files != null) {
																for (File file : files) {
																	if (file.getName().equals(delFile.get("savedName"))) {
																		// 파일을 찾았을 경우 삭제.
																		if (file.delete()) {
																			Log.Debug(delFile.get("savedName") + " 파일이 삭제되었습니다.");
																		} else {
																			Log.Debug(delFile.get("savedName") + " 파일 삭제에 실패했습니다.");
																		}
																		break;
																	}
																}
															}
														}
													}
												}

												// 대상 폴더에 파일이 하나도 없는 경우 폴더 삭제
												File targetFolder = new File(targetPath);
												if (targetFolder.exists() && targetFolder.isDirectory()) {
													try (DirectoryStream<Path> directoryStream = Files.newDirectoryStream(target)) {
														if (!directoryStream.iterator().hasNext()) {
															// 폴더가 비어있으면 삭제
															Files.delete(target);
														}
													}
												}
											} catch (Exception e) {
												Log.Debug("temp file copy error!");
												Log.Debug(e.toString());

												msg = "파일업로드 오류! 파일이동에 실패했습니다.";
												code = -1;
												ModelAndView mv = new ModelAndView();
												mv.setViewName("jsonView");
												mv.addObject("Code", code);
												mv.addObject("Message", msg);
												return mv;
											}
										}
									}
								}
							} catch (Exception e) {
								Log.Debug(e.toString());
							}
						}
					}
				}
			}
		}
		return joinPoint.proceed();
	}

	public String getUploadPath(String enterCd, String fileSeq) {
		String targetPath = getTargetPath(enterCd);
		String tmp = this.config.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
		tmp = tmp == null ? "" : tmp;

		Pattern p = Pattern.compile("@([\\w]*)@");
		Matcher m = p.matcher(tmp);

		while (m.find()) {
			if (m.groupCount() > 0) {
				String replaceKey = m.group(0);
				String patternKey = m.group(1);

				try {
					tmp = tmp.replace(replaceKey, DateUtil.getCurrentDay(patternKey));
				} catch (Exception e) { Log.Debug(e.getLocalizedMessage()); }
			}
		}

		String workDir = StringUtil.replaceAll(tmp, "//", "/");

		// TSYS200에 이미 저장된 filePath 가 있는 경우, workDir 경로 변경
		// -> 신청서에서 202409월에 파일첨부하여 임시저장한 후 동일한 신청서에 202410월에 새로 파일을 추가한 경우,
		//     TSYS200의 filePath는 /appl/202409 이나, 신규 파일이 저장되는 경로는 /appl/202410 이다.
		//     따라서 해당 이슈를 해결하기 위해 TSYS200의 filePath를 조회하여 workDir를 변경하는 로직을 추가 함
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ssnEnterCd", enterCd);
		paramMap.put("fileSeq", fileSeq);
        try {
            Map<?, ?> map = jFileUploadService.jFileCount(paramMap);
			if (map != null) {
				workDir = map.get("filePath").toString();
				return StringUtil.replaceAll(targetPath + "/" + workDir + "/", "//", "/");
			}
        } catch (Exception e) {
			Log.Debug("jFileCount error!");
            throw new RuntimeException(e);
        }

        return StringUtil.replaceAll(targetPath + "/" + workDir + "/"  + fileSeq, "//", "/");
	}

	public String getTargetPath(String enterCd) {
		String realPath = (this.config.getDiskPath().isEmpty()) ? ClassPathUtils.getClassPathHrfile() : this.config.getDiskPath();
		return StringUtil.replaceAll(realPath + "/" + enterCd, "//", "/");
	}
}
