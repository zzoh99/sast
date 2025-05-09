package com.hr.tus;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.BadRequestException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hr.TusConfig;
import com.hr.common.util.StringUtil;

import me.desair.tus.server.TusFileUploadService;
import me.desair.tus.server.upload.UploadInfo;


/**
 * 샘플 Service
 *
 * @author ParkMoohun
 *
 */

@Service("FileUploadService")
public class FileUploadService {

	@Autowired
	private TusConfig config;

	@Autowired
	private Bucket bucket;


	@FunctionalInterface
	interface TusOnUpload {
		void call(UploadInfo uploadInfo);
	}


	public UploadInfo uploadUseCallback(HttpServletRequest request, HttpServletResponse response,TusOnUpload onUpload)throws Exception {
		TusFileUploadService tusFileUploadService = config.tus();
		
			tusFileUploadService.process(request, response);
			UploadInfo uploadInfo = tusFileUploadService.getUploadInfo(request.getRequestURI());
			// uploadInfo == null 맨처음 파일업로드 요청한 상태.
			// uploadInfo.isUploadInProgress()  업로드 중인 상태
			// !uploadInfo.isUploadInProgress()  업로드 완료
			if (uploadInfo != null && !uploadInfo.isUploadInProgress()){
				onUpload.call(uploadInfo);
				//  tus uploads 디스크에서 해당 파일 업로드 정보 삭제
				tusFileUploadService.deleteUpload(request.getRequestURI());
			}
			return uploadInfo;
	}

	// 기본 저장 Function   Bucket 에 저장 후  tus uploads 디스크 clean
	public void uploadFile(HttpServletRequest request, HttpServletResponse response,String path)throws Exception {
		TusFileUploadService tusFileUploadService = config.tus();
		if(StringUtil.isEmpty(path)) throw new BadRequestException("파일 경로를 지정해야합니다.");
		this.uploadUseCallback(request,response,(uploadInfo) -> {
			try {
				//  bucket 에 저장
				bucket.upload(tusFileUploadService.getUploadedBytes(request.getRequestURI()),path,uploadInfo.getFileName());
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		});
	}
	public void upload(HttpServletRequest request, HttpServletResponse response,String path)throws Exception {
		TusFileUploadService tusFileUploadService = config.tus();
		if(StringUtil.isEmpty(path)) throw new BadRequestException("파일 경로를 지정해야합니다.");
		this.uploadUseCallback(request,response,(uploadInfo) -> {
			try {

				//  bucket 에 저장
				if(uploadInfo.getFileMimeType().contains("zip"))
					bucket.uploadAndUnzip(tusFileUploadService.getUploadedBytes(request.getRequestURI()),path);
				else
					bucket.upload(tusFileUploadService.getUploadedBytes(request.getRequestURI()),path,uploadInfo.getFileName());
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		});
	}

	//  zip 풀고 파일 각각 저장
	public void uploadAndUnzip(HttpServletRequest request, HttpServletResponse response,String path)throws Exception {
		TusFileUploadService tusFileUploadService = config.tus();
		if(StringUtil.isEmpty(path)) throw new BadRequestException("파일 경로를 지정해야합니다.");
		this.uploadUseCallback(request,response,(uploadInfo) -> {
			if(!uploadInfo.getFileMimeType().contains("zip")) throw new RuntimeException("file is not zip");
			try {
				bucket.uploadAndUnzip(tusFileUploadService.getUploadedBytes(request.getRequestURI()),path);
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		});
	}

}
