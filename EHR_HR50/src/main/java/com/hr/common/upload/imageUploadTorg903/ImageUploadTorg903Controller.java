package com.hr.common.upload.imageUploadTorg903;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.hr.common.logger.Log;
import com.hr.common.util.PropertyResourceUtil;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.hr.common.util.securePath.SecurePathUtil;
import java.nio.file.Path;


/**
 * 샘플 Controller
 *
 * @author ParkMoohun
 *
 */
public class ImageUploadTorg903Controller{
	@Inject
	@Named("ImageUploadTorg903Service")
	private ImageUploadTorg903Service imageUploadTorg903Service;


	/**
	 * BLOB Image UpLoad, DownLoad 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCorpImgReg", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCorpImgReg() throws Exception {
		return "org/organization/corpImgReg/corpImgReg";

	}


	public static void removeDIR(String source){
		File[] listFile = new File(source).listFiles();
		try{
			if(listFile != null && listFile.length > 0){
				for(int i = 0 ; i < listFile.length ; i++){
					if(listFile[i].isFile()){
						listFile[i].delete();
					}
					listFile[i].delete();
				}
			}
		}catch(Exception e){
			Log.Debug( e.getMessage() );
		}
	}



	/**
	 * 이미지 UpLoad
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/ImageUpLoadTorg903.do", method=RequestMethod.POST )
	public void ImageUploadTorg903(
			HttpSession session,  HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		String basePath = PropertyResourceUtil.getHrfilePath(request);
		String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
		
		// 안전한 경로 생성
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "company");
		String path = securePath.toString();

		Log.Debug("File Upload Path : " + path);
		
		// 안전한 디렉토리 생성
		SecurePathUtil.createSecureDirectory(basePath, path);

		try {
			File df = new File(path);
			File[] destroy = df.listFiles();
			if (destroy != null) {
				for(File des : destroy) {
					Log.Debug("Delete File Name : " + des.getPath());
				}
			}
		} catch(Exception e) {
			Log.Debug(e.getMessage());
		}

		MultipartRequest req = new MultipartRequest(request, path, 50*1024*1024, "utf-8", new DefaultFileRenamePolicy());

		String fname = (String)(req.getFileNames().nextElement());
		String _tempFileName = (req.getFile(fname)).getName();
		String logoCd = (String)req.getParameter("logoCd");
		String orgCd = (String)req.getParameter("orgCd");
		
		// 파일명 검증
		_tempFileName = SecurePathUtil.sanitizeFileName(_tempFileName);
		logoCd = SecurePathUtil.sanitizeFileName(logoCd);
		orgCd = SecurePathUtil.sanitizeFileName(orgCd);

		Log.Debug("#########################################");
		Log.Debug("logoCd : " + logoCd);
		Log.Debug("orgCd : " + orgCd);
		Log.Debug("#########################################");
		
		String gubun = _tempFileName.substring(_tempFileName.lastIndexOf(".") + 1).toUpperCase();
		Log.Debug("gubun=====>" + gubun);

		if("JPG".equals(gubun) || "PNG".equals(gubun) || "GIF".equals(gubun)) {
			try {
				File file = new File(SecurePathUtil.getSecurePath(path, _tempFileName).toString());
				BufferedImage image = ImageIO.read(file);	//메소드를 사용하여 이미지를 BufferedImage에 저장한다

				if (image != null) {
					int owidth = image.getWidth();
					int oheight = image.getHeight();

					BufferedImage destImg = new BufferedImage(owidth, oheight, BufferedImage.TYPE_3BYTE_BGR);
					Graphics2D g = destImg.createGraphics();
					g.drawImage(image, 0, 0, owidth, oheight, null);

					// 썸네일 디렉토리 생성
					Path thumbPath = SecurePathUtil.getSecurePath(path, "Thum");
					SecurePathUtil.createSecureDirectory(path, "Thum");
					
					// 썸네일 파일 저장
					String thumbFileName = logoCd + "$" + orgCd + "." + gubun;
					Path thumbFilePath = SecurePathUtil.getSecurePath(thumbPath.toString(), thumbFileName);
					File thumbFile = new File(thumbFilePath.toString());
					ImageIO.write(destImg, "jpeg", thumbFile);

					Map<String, Object> uMap = new HashMap<String, Object>();
					uMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
					uMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
					uMap.put("ssnSabun", session.getAttribute("ssnSabun"));
					uMap.put("logoCd", logoCd);
					uMap.put("orgCd", orgCd);
					uMap.put("orgFileNm", _tempFileName);
				}
			} catch(Exception e) {
				Log.Debug(e.getLocalizedMessage());
			}
		}
		Log.DebugEnd();
	}





	/**
	 * 조회 BLOB
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/ImageDownloadTorg903.do", method=RequestMethod.POST )
	public void ImageDownload(HttpSession session, HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		String logoCd = SecurePathUtil.sanitizeFileName(paramMap.get("logoCd").toString());
		String orgCd = "$" + SecurePathUtil.sanitizeFileName(paramMap.get("orgCd").toString());

		Log.Debug("paramMap==========> {}", paramMap);
		Log.DebugStart();

		String basePath = PropertyResourceUtil.getHrfilePath(request);
		String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "company");
		String path = securePath.toString();
		
		String imgtype = null;

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		Map<?, ?> img = imageUploadTorg903Service.torg903ImageSelect(paramMap);

		if(img != null) {
			String filename = img.get("filename") != null ? img.get("filename").toString() : "";
			imgtype = filename.substring(filename.lastIndexOf(".") + 1).toUpperCase();
		}
		
		// 안전한 경로로 이미지 파일 접근
		Path thumbPath = SecurePathUtil.getSecurePath(path, "Thum");
		Path imgPath = SecurePathUtil.getSecurePath(thumbPath.toString(), logoCd + orgCd + "." + imgtype);
		File imgFile = new File(imgPath.toString());
		
		// 파일 미 존재시
		if (!imgFile.isFile()) {
			String defaultImgPath = Paths.get(request.getSession().getServletContext().getRealPath("/"), "common/images/common/img_photo.gif").toString();
			imgFile = new File(defaultImgPath);
		}
		
		FileInputStream ifo = null;
		ByteArrayOutputStream baos = null;
		OutputStream out = null;
		try {
			ifo = new FileInputStream(imgFile);
			baos = new ByteArrayOutputStream();
			byte[] buf = new byte[1024];
			int readlength = 0;
			while( (readlength =ifo.read(buf)) != -1 ) {
				baos.write(buf,0,readlength);
			}
			
			byte[] imgbuf = baos.toByteArray();
			int length = imgbuf.length;
			out = response.getOutputStream();
			out.write(imgbuf , 0, length);
		} catch (IOException e) {
			Log.Debug(e.getLocalizedMessage());
		} finally {
			if (ifo != null) ifo.close();
			if (baos != null) baos.close();
			if (out != null) out.close();
		}
		
		Log.DebugEnd();
	}
}