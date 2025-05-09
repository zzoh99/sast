package com.hr.common.util.ftp;

import com.hr.common.logger.Log;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.springframework.beans.factory.annotation.Value;

import java.io.*;

public class FtpUtil {
	
	@Value("${rec.ftp_url}") private static String REC_FTP_URL;
	@Value("${rec.ftp_id}") private static String REC_FTP_ID;
	@Value("${rec.ftp_pwd}") private static String REC_FTP_PWD;
	@Value("${rec.ftp_port}") private static String REC_FTP_PORT;
	
	public static int download(String filePath, String fileName, String downloadPath) throws Exception {

		FTPClient client = null;
		BufferedOutputStream bos = null;
		File fPath = null;
		File fDir = null;
		File f = null;
		
		int result = -1;

		try {
			// download 경로에 해당하는 디렉토리 생성
			fPath = new File(downloadPath);
			fDir = fPath;
			fDir.mkdirs();

			f = new File(downloadPath, fileName);

			client = new FTPClient();
			client.setControlEncoding("UTF-8");
			client.connect(REC_FTP_URL, Integer.parseInt(REC_FTP_PORT));

			int resultCode = client.getReplyCode();

			if (FTPReply.isPositiveCompletion(resultCode) == false) {
				client.disconnect();
				throw new Exception("FTP 서버에 연결할 수 없습니다.");
			} else {
				client.setSoTimeout(5000);
				boolean isLogin = client.login(REC_FTP_ID, REC_FTP_PWD);

				if (isLogin == false) {
					throw new Exception("FTP 서버에 로그인 할 수 없습니다.");
				}

				client.setFileType(FTP.BINARY_FILE_TYPE);
				client.changeWorkingDirectory(filePath);

				bos = new BufferedOutputStream(new FileOutputStream(f));
				boolean isSuccess = client.retrieveFile(fileName, bos);

				if (isSuccess) {
					result = 1; // 성공
				} else {
					throw new Exception("파일 다운로드를 할 수 없습니다.");
				}

				client.logout();
			} // if ~ else
		} catch (Exception e) {
			throw new Exception("FTP Exception : " + e);
		} finally {
			if (bos != null)
				try {
					bos.close();
				} catch (Exception e) {
				}
			if (client != null && client.isConnected())
				try {
					client.disconnect();
				} catch (Exception e) { Log.Debug(e.getLocalizedMessage()); }
		} // try ~ catch ~ finally
		return result;
	} // download()
	
	
	public static int upload(String localFilePath, String remoteFilePath, String fileName) throws Exception {
		FTPClient ftp = null; // FTP Client 객체
		FileInputStream fis = null; // File Input Stream
		File uploadfile = new File(localFilePath+fileName); // File 객체
		
		int result = -1;

		try {
			ftp = new FTPClient(); // FTP Client 객체 생성
			ftp.setControlEncoding("UTF-8"); // 문자 코드를 UTF-8로 인코딩
			ftp.connect(REC_FTP_URL, Integer.parseInt(REC_FTP_PORT)); // 서버접속 " "안에 서버 주소 입력 또는
														// "서버주소", 포트번호
			ftp.login(REC_FTP_ID, REC_FTP_PWD); // FTP 로그인 ID, PASSWORLD 입력
			ftp.enterLocalPassiveMode(); // Passive Mode 접속일때
			//ftp.makeDirectory(remoteFilePath);
			ftp.changeWorkingDirectory(remoteFilePath); // 작업 디렉토리 변경
			ftp.setFileType(FTP.BINARY_FILE_TYPE); // 업로드 파일 타입 셋팅

			try {
				fis = new FileInputStream(uploadfile); // 업로드할 File 생성
				boolean isSuccess = ftp.storeFile(fileName, fis); // File 업로드
				if (isSuccess) {
					result = 1; // 성공
				} else {
					throw new Exception("파일 업로드를 할 수 없습니다.");
				}
			} catch (IOException ex) {
				Log.Debug("IO Exception : " + ex.getMessage());
			} finally {
				if (fis != null) {
					try {
						fis.close(); // Stream 닫기
						return result;

					} catch (IOException ex) {
						Log.Debug("IO Exception : " + ex.getMessage());
					}
				}
			}
			ftp.logout(); // FTP Log Out
		} catch (IOException e) {
			Log.Debug("IO:" + e.getMessage());
		} finally {
			if (ftp != null && ftp.isConnected()) {
				try {
					ftp.disconnect(); // 접속 끊기
					return result;
				} catch (IOException e) {
					Log.Debug("IO Exception : " + e.getMessage());
				}
			}
		}
		return result;
	}
	
	public static int delete(String localFilePath, String remoteFilePath, String fileName) throws Exception {
		  
		FTPClient ftp = null; // FTP Client 객체
		FileInputStream fis = null; // File Input Stream
		
		int result = -1;

		try {
			ftp = new FTPClient(); // FTP Client 객체 생성
			ftp.setControlEncoding("UTF-8"); // 문자 코드를 UTF-8로 인코딩
			ftp.connect(REC_FTP_URL, Integer.parseInt(REC_FTP_PORT)); // 서버접속 " "안에 서버 주소 입력 또는
														// "서버주소", 포트번호
			ftp.login(REC_FTP_ID, REC_FTP_PWD); // FTP 로그인 ID, PASSWORLD 입력
			ftp.enterLocalPassiveMode(); // Passive Mode 접속일때
			ftp.changeWorkingDirectory(remoteFilePath); // 작업 디렉토리 변경
			ftp.setFileType(FTP.BINARY_FILE_TYPE); // 업로드 파일 타입 셋팅

			try {
				boolean isSuccess = ftp.deleteFile(fileName);// 파일삭제

				if (isSuccess) {
					result = 1; // 성공
				} else {
					throw new Exception("파일을 삭제 할 수 없습니다.");
				}
			} catch (IOException ex) {
				Log.Debug("IO Exception : " + ex.getMessage());
			} finally {
				if (fis != null) {
					try {
						fis.close(); // Stream 닫기
						return result;

					} catch (IOException ex) {
						Log.Debug("IO Exception : " + ex.getMessage());
					}
				}
			}
			ftp.logout(); // FTP Log Out
		} catch (IOException e) {
			Log.Debug("IO:" + e.getMessage());
		} finally {
			if (ftp != null && ftp.isConnected()) {
				try {
					ftp.disconnect(); // 접속 끊기
					return result;
				} catch (IOException e) {
					Log.Debug("IO Exception : " + e.getMessage());
				}
			}
		}
		return result;
	}

	
}
