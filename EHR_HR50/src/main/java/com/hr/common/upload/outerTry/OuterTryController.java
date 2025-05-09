package com.hr.common.upload.outerTry;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;
import com.hr.common.util.fileupload.impl.FileHandlerFactory;
import com.hr.common.util.fileupload.impl.IFileHandler;

@Controller
public class OuterTryController{
	@Inject
	@Named("OuterTryService")
	private OuterTryService outerTryService;



	@RequestMapping(value="/ImageDownload.do", method=RequestMethod.POST )
	public void ImageDownload(
			HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		//연말정산에서 ImageDownload.do 로 호출하는 화면이 있어서 남겨둠
		EmpPhotoOut(request, response, paramMap );
	}


	@RequestMapping(value="/ImageDownloadTorg903.do", method=RequestMethod.POST )
	public void ImageDownloadTorg903(
			HttpSession session,
			HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		//연말정산에서 /ImageDownloadTorg903.do 로 호출하는 화면이 있어서 남겨둠
		//삭제해야함
		OrgPhotoOut(session, request, response, paramMap );
	}

	@RequestMapping(value="/EmpPhotoOut.do", method=RequestMethod.GET )
	public void EmpPhotoOut(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		String enterCd = (String) paramMap.get("enterCd");
		String searchKeyword = (String) paramMap.get("searchKeyword");
		String type = (String) paramMap.get("type");
		String fileSeq = (String) paramMap.get("fileSeq");
		String seqNo = (String) paramMap.get("seqNo");

		try {
			//

			if(fileSeq == null || "".equals(fileSeq) || seqNo == null || "".equals(seqNo)) {
				if(enterCd == null || "".equals(enterCd)) {
					//if(session != null) {
					//	paramMap.put("enterCd", session.getAttribute("ssnEnterCd"));
					//} else {

					HttpSession session = request.getSession(false);
					paramMap.put("enterCd", StringUtil.stringValueOf((String)session.getAttribute("ssnEnterCd")));

					// Log.Debug("enterCd 값이 없음 == ERROR !!! ");
					//	return;
					//}
				}

				if(searchKeyword == null || "".equals(searchKeyword)) {
					paramMap.put("searchKeyword", paramMap.get("sabun"));
					//if(session != null) {
					//	paramMap.put("searchKeyword", session.getAttribute("ssnSabun"));
					//} else {
						//Log.Debug("searchKeyword 값이 없음 !!! ");
						//return;
					//}
					//throw new NullPointerException("searchKeyword 값이 없습니다.");
				}

				if(type == null || "".equals(type)) {
					paramMap.put("type", "1");
				}

				Log.Debug("paramMap >>> "+ paramMap.toString());
				Map<?, ?> result = outerTryService.getThrm911(paramMap);

				if(result != null) {
					fileSeq = String.valueOf(result.get("fileSeq"));
					seqNo = String.valueOf(result.get("seqNo"));
				}
			}
			Log.Debug("paramMap ))) "+ paramMap.toString());
			//if(fileSeq == null || "".equals(fileSeq) || seqNo == null || "".equals(seqNo)) {
			//	throw new Exception("File Sequence Error!");
			//}

			String[] fileSeqs = { fileSeq };
			String[] seqNos = { seqNo };
			
			//sign 적용안되어 있어서 수정함 -- 2020.06.11
			String uploadType = "pht001";
			if( paramMap.get("type") != null && "2".equals(String.valueOf(paramMap.get("type")))){
				uploadType = "pht002";	
			}

			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(uploadType, request, response);
			fileHandler.setIsDirectDownload(true);
			fileHandler.download(true, fileSeqs, seqNos);
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());


			File imgFile =  ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + "/static" + "/common/images/common/img_photo.gif");
			FileInputStream ifo = null;
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] buf = new byte[1024];
			int readlength = 0;
			byte[] imgbuf = null;

			try{
				ifo = new FileInputStream(imgFile);
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
				if(ifo != null) {
					try {
						ifo.close();
					}catch (IOException ie){
						Log.Debug("FileInputStream CLOSE FAIL");
					}
				}
			}


			int length = imgbuf.length;

			Log.Debug("img.length=> "+ length );

			OutputStream out = response.getOutputStream();
			out.write(imgbuf , 0, length);
			out.close();
//			throw e;
		}

		Log.DebugEnd();
	}

	@RequestMapping(value="/OrgPhotoOut.do", method=RequestMethod.GET )
	public void OrgPhotoOut(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		String enterCd = (String) paramMap.get("enterCd");
		String logoCd = (String) paramMap.get("logoCd");
		String orgCd = (String) paramMap.get("orgCd");
		String fileSeq = (String) paramMap.get("fileSeq");
		String seqNo = (String) paramMap.get("seqNo");

		try {
			//HttpSession session = request.getSession(false);

			if(fileSeq == null || "".equals(fileSeq) || seqNo == null || "".equals(seqNo)) {
				if(enterCd == null || "".equals(enterCd)) {
					paramMap.put("enterCd", StringUtil.stringValueOf((String)session.getAttribute("ssnEnterCd")));
				}

				if(logoCd == null || "".equals(logoCd)) {
					Log.Debug("logoCd 값이 없음 == ERROR !!! ");
					return;
				}

				if(orgCd == null || "".equals(orgCd)) {
					paramMap.put("orgCd", "0");
				}

				Map<?, ?> result = outerTryService.getTorg903(paramMap);

				if(result != null) {
					fileSeq = String.valueOf(result.get("fileSeq"));
					seqNo = String.valueOf(result.get("seqNo"));
				}
			}

			if(fileSeq == null || "".equals(fileSeq) || seqNo == null || "".equals(seqNo)) {
				Log.Debug("=======================================================");
				Log.Debug("fileSeq : " + fileSeq);
				Log.Debug("seqNo : " + seqNo);
				Log.Debug("=======================================================");
				throw new Exception("File Sequence Error!");
			}

			String[] fileSeqs = { fileSeq };
			String[] seqNos = { seqNo };

			IFileHandler fileHandler = FileHandlerFactory.getFileHandler("company", request, response);
			fileHandler.setIsDirectDownload(true);
			fileHandler.download(true, fileSeqs, seqNos);
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());
			File imgFile =  new  File(System.getProperty("java.class.path") + "/common/images/common/img_photo.gif");
			FileInputStream ifo = null;
			ByteArrayOutputStream baos = null;
			OutputStream out = null;
			try {
				ifo = new FileInputStream(imgFile);
				baos = new ByteArrayOutputStream();
				byte[] buf = new byte[1024];
				int readlength = 0;
				while( (readlength =ifo.read(buf)) != -1 ){
					baos.write(buf,0,readlength);
				}
				byte[] imgbuf = baos.toByteArray();

				int length = imgbuf.length;

				Log.Debug("img.length=> "+ length );

				out = response.getOutputStream();
				out.write(imgbuf , 0, length);
			} catch (IOException ioe) {
				Log.Debug(ioe.getLocalizedMessage());
			} finally {
				if (out != null) {
					try {
						out.close();
					}catch (IOException ie){
						Log.Debug("OutputStream CLOSE FAIL");
					}
				}
				if (baos != null) {
					try {
						baos.close();
					}catch (IOException ie){
						Log.Debug("ByteArrayOutputStream CLOSE FAIL");
					}
				}
				if (ifo != null) {
					try {
						ifo.close();
					}catch (IOException ie){
						Log.Debug("FileInputStream CLOSE FAIL");
					}
				}
			} 
		}

		Log.DebugEnd();
	}

	@RequestMapping(value="/SignPhotoOut.do", method=RequestMethod.POST )
	public void SignPhotoOut(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		String enterCd = (String) paramMap.get("enterCd");
		//String searchKeyword = (String) paramMap.get("searchKeyword");
		//String type = (String) paramMap.get("type");
		String fileSeq = (String) paramMap.get("fileSeq");
		//String seqNo = (String) paramMap.get("seqNo");
		String seqNo = "0";

		try {
			
			if(enterCd == null || "".equals(enterCd)) {
				HttpSession session = request.getSession(false);
				paramMap.put("enterCd", StringUtil.stringValueOf((String)session.getAttribute("ssnEnterCd")));
			}

		
			String[] fileSeqs = { fileSeq };
			String[] seqNos = { seqNo };
			
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler("pht002", request, response);
			fileHandler.setIsDirectDownload(true);
			fileHandler.download(true, fileSeqs, seqNos);
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());

			File imgFile = ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + "/static" + "/common/images/common/img_photo.gif");
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
				if(baos != null){
					try {
						baos.close();
					}catch (IOException ie){
						Log.Debug("ByteArrayOutputStream CLOSE FAIL");
					}
				}
				if(ifo != null) {
					try {
						ifo.close();
					} catch (IOException ie) {
						Log.Debug("FileInputStream CLOSE FAIL");
					}
				}
			}

			int length = imgbuf.length;

			Log.Debug("img.length=> "+ length );

			OutputStream out = response.getOutputStream();
			out.write(imgbuf , 0, length);
			out.close();
//			throw e;
		}

		Log.DebugEnd();
	}

	@RequestMapping(value="/LayoutPhotoOut.do", method=RequestMethod.POST )
	public void LayoutPhotoOut(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		String enterCd = (String) paramMap.get("enterCd");
		String fileSeq = (String) paramMap.get("fileSeq");
		String seqNo = (String) paramMap.get("seqNo");

		try {
			String[] fileSeqs = { fileSeq };
			String[] seqNos = { seqNo };

			String uploadType = "layout";

			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(uploadType, request, response);
			fileHandler.setIsDirectDownload(true);
			fileHandler.download(true, fileSeqs, seqNos);
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());


			File imgFile =  ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + "/static" + "/common/images/common/img_photo.gif");
			FileInputStream ifo = null;
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] buf = new byte[1024];
			int readlength = 0;
			byte[] imgbuf = null;

			try{
				ifo = new FileInputStream(imgFile);
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
				if(ifo != null) {
					try {
						ifo.close();
					}catch (IOException ie){
						Log.Debug("FileInputStream CLOSE FAIL");
					}
				}
			}

			int length = imgbuf.length;

			Log.Debug("img.length=> "+ length );

			OutputStream out = response.getOutputStream();
			out.write(imgbuf , 0, length);
			out.close();
//			throw e;
		}

		Log.DebugEnd();
	}

	@RequestMapping(value="/LayoutThumbnail.do", method=RequestMethod.GET )
	public void LayoutThumbnail(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		try {

			String template = (String) paramMap.getOrDefault("template", "");
			if(template != null && !template.isEmpty()) {
				File imgFile =  ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + "/static" + "/common/images/common/layout_" + template + ".png");
				FileInputStream ifo = null;
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				byte[] buf = new byte[1024];
				int readlength = 0;
				byte[] imgbuf = null;

				try{
					ifo = new FileInputStream(imgFile);
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
					if(ifo != null) {
						try {
							ifo.close();
						}catch (IOException ie){
							Log.Debug("FileInputStream CLOSE FAIL");
						}
					}
				}

				int length = imgbuf.length;

				Log.Debug("img.length=> "+ length );

				OutputStream out = response.getOutputStream();
				out.write(imgbuf , 0, length);
				out.close();

			} else {
				Map<?, ?> result = outerTryService.getLayoutThumbnail(paramMap);

				String fileSeq = "";
				String seqNo = "";
				if(result != null) {
					fileSeq = String.valueOf(result.get("fileSeq"));
					seqNo = String.valueOf(result.get("seqNo"));
				}

				String[] fileSeqs = { fileSeq };
				String[] seqNos = { seqNo };

				String uploadType = "layout";

				IFileHandler fileHandler = FileHandlerFactory.getFileHandler(uploadType, request, response);
				fileHandler.setIsDirectDownload(true);
				fileHandler.download(true, fileSeqs, seqNos);
			}

		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());


			File imgFile =  ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + "/static" + "/common/images/common/img_photo.gif");
			FileInputStream ifo = null;
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] buf = new byte[1024];
			int readlength = 0;
			byte[] imgbuf = null;

			try{
				ifo = new FileInputStream(imgFile);
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
				if(ifo != null) {
					try {
						ifo.close();
					}catch (IOException ie){
						Log.Debug("FileInputStream CLOSE FAIL");
					}
				}
			}

			int length = imgbuf.length;

			Log.Debug("img.length=> "+ length );

			OutputStream out = response.getOutputStream();
			out.write(imgbuf , 0, length);
			out.close();
//			throw e;
		}

		Log.DebugEnd();
	}

	@RequestMapping(value="/AttachFileView.do", method=RequestMethod.POST )
	public void attachFileView(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> paramMap) throws Exception {
		String enterCd = (String) paramMap.get("enterCd");
		String reqSeq = (String) paramMap.get("reqSeq");
		String fileSeq = (String) paramMap.get("fileSeq");

		try {
			if (fileSeq == null || fileSeq.isEmpty() || reqSeq == null || reqSeq.isEmpty()) {
				if (enterCd == null || enterCd.isEmpty()) {
					HttpSession session = request.getSession(false);
					enterCd = (String) session.getAttribute("ssnEnterCd");
					paramMap.put("enterCd", enterCd);
				}
			}

			// 파일을 스트리밍할 준비
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			fileHandler.loadView(true, new String[] { fileSeq }, new String[] { reqSeq });

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}

		Log.DebugEnd();
	}
}