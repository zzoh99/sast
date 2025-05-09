package com.hr.common.upload.imageUpload;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
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
import org.springframework.web.servlet.ModelAndView;

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
public class ImageUploadController{
	@Inject
	@Named("ImageUploadService")
	private ImageUploadService imageUploadService;


	/**
	 * BLOB Image UpLoad, DownLoad 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSampleBLOBImage", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSampleBLOBImage() throws Exception {
		return "sample/sampleBLOBImage";
	}

	/**
	 * BLOB Image UpLoad, DownLoad 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/Down2Image.do", method=RequestMethod.POST )
	public String Down2Image() throws Exception {
		return "common/ibsheet/down2Image";
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
	@RequestMapping(value="/ImageUpLoad.do", method=RequestMethod.POST )
	public void ImageUpLoad(
			HttpSession session,  HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));

		String basePath = PropertyResourceUtil.getHrfilePath(request);
		String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
		
		// 안전한 경로 생성
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "picture");
		String path = securePath.toString();
		
		Log.Debug("File Upload Path : " + path);
		
		// 안전한 디렉토리 생성
		SecurePathUtil.createSecureDirectory(basePath, path);

		MultipartRequest req = new MultipartRequest(request, path, 50*1024*1024, "utf-8", new DefaultFileRenamePolicy());

		String fname = (String)(req.getFileNames().nextElement());
		String _tempFileName = (req.getFile(fname)).getName();
		String sabun = req.getParameter("sabun");
		String enterCd = req.getParameter("enterCd");
		
		// 파일명 검증
		_tempFileName = SecurePathUtil.sanitizeFileName(_tempFileName);
		String gubun = _tempFileName.substring(_tempFileName.lastIndexOf(".") + 1).toUpperCase();
		Log.Debug("gubun=====>" + gubun);

		if("JPG".equals(gubun) || "PNG".equals(gubun) || "GIF".equals(gubun)) {
			int width = 80;
			int height = 101;

			try {
				Path originalPath = SecurePathUtil.getSecurePath(path, _tempFileName);
				File file = new File(originalPath.toString());
				BufferedImage image = ImageIO.read(file);

				BufferedImage destImg = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR);
				Graphics2D g = destImg.createGraphics();
				g.drawImage(image, 0, 0, width, height, null);

				// 썸네일 디렉토리 생성
				Path thumbPath = SecurePathUtil.getSecurePath(path, "Thum");
				SecurePathUtil.createSecureDirectory(path, "Thum");

				Map<String, Object> uMap = new HashMap<String, Object>();
				uMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
				uMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
				uMap.put("enterCd", enterCd);
				uMap.put("sabun", sabun);
				uMap.put("gubun", gubun);
				uMap.put("orgFileNm", _tempFileName);

				imageUploadService.thrm911ImageInsert(uMap);
			} catch(Exception e) {
				Log.Debug(e.getLocalizedMessage());
			}
		}
		Log.DebugEnd();
	}

	/**
	 * 사원 이미지 UpLoad : 무조건 사번으로저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/ImageUpLoadEmp.do", method=RequestMethod.POST )
	public void ImageUpLoadEmp(
			HttpSession session,  HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		String basePath = PropertyResourceUtil.getHrfilePath(request);
		String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
		
		// 안전한 경로 생성
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "picture");
		String path = securePath.toString();
		
		Log.Debug("File Upload Path : " + path);
		
		// 안전한 디렉토리 생성
		SecurePathUtil.createSecureDirectory(basePath, path);

		Map<?, ?> stdCdValueMap = imageUploadService.getEmpImgStdCdValue(paramMap);
		String imgThumYn = "";
		int imgLimitSize = 0;
		if(stdCdValueMap != null) {
			imgThumYn = (String)stdCdValueMap.get("imgThumYn");
			imgLimitSize = Integer.parseInt((String)stdCdValueMap.get("imgLimitSize"));
		}

		MultipartRequest req = new MultipartRequest(request, path, imgLimitSize*1024, "utf-8", new DefaultFileRenamePolicy());

		String fname = (String)(req.getFileNames().nextElement());
		String _tempFileName = (req.getFile(fname)).getName();
		String sabun = req.getParameter("sabun");
		String enterCd = req.getParameter("enterCd");
		String signYn = req.getParameter("signYn");

		// 파일명 검증
		_tempFileName = SecurePathUtil.sanitizeFileName(_tempFileName);
		sabun = SecurePathUtil.sanitizeFileName(sabun);
		String gubun = _tempFileName.substring(_tempFileName.lastIndexOf(".") + 1).toUpperCase();

		if("JPG".equals(gubun) || "PNG".equals(gubun) || "GIF".equals(gubun)) {
			int width = 80;
			int height = 101;
			
			FileInputStream fis = null;
			FileOutputStream fos = null;

			try {
				Path originalPath = SecurePathUtil.getSecurePath(path, _tempFileName);
				File file = new File(originalPath.toString());
				BufferedImage image = ImageIO.read(file);

				BufferedImage destImg = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR);
				Graphics2D g = destImg.createGraphics();
				g.drawImage(image, 0, 0, width, height, null);

				// 썸네일 디렉토리 생성
				Path thumbPath = SecurePathUtil.getSecurePath(path, "Thum");
				SecurePathUtil.createSecureDirectory(path, "Thum");

				// 썸네일 파일 저장
				String thumbFileName;
				if(signYn != null && "Y".equals(signYn)) {
					thumbFileName = sabun + "_sign." + gubun;
				} else {
					thumbFileName = sabun + "." + gubun;
				}
				
				Path thumbFilePath = SecurePathUtil.getSecurePath(thumbPath.toString(), thumbFileName);
				File thumbFile = new File(thumbFilePath.toString());

				if("Y".equals(imgThumYn)) {
					ImageIO.write(destImg, "jpeg", thumbFile);
				} else {
					fis = new FileInputStream(file);
					fos = new FileOutputStream(thumbFile);

					FileChannel isbc = fis.getChannel();
					FileChannel ogbc = fos.getChannel();
					ByteBuffer buf = ByteBuffer.allocateDirect(1024);

					while (isbc.read(buf) != -1) {
						buf.flip();
						ogbc.write(buf);
						buf.clear();
					}

					isbc.close();
					ogbc.close();
				}

				Map<String, Object> uMap = new HashMap<String, Object>();
				uMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
				uMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
				uMap.put("enterCd", enterCd);
				uMap.put("sabun", sabun);
				uMap.put("gubun", gubun);
				uMap.put("orgFileNm", sabun + "." + gubun);
				uMap.put("signFileNm", sabun + "_sign." + gubun);

				if(signYn != null && "Y".equals(signYn)) {
					imageUploadService.thrm911SignImageInsert(uMap);
				} else {
					imageUploadService.thrm911ImageInsert(uMap);
				}
			} catch(Exception e) {
				Log.Debug(e.getLocalizedMessage());
			} finally {
				if (fis != null) fis.close();
				if (fos != null) fos.close();
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
	@RequestMapping(value="/ImageDownload.do", method=RequestMethod.POST )
	public void ImageDownload(
			HttpSession session,  HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		String sabun = SecurePathUtil.sanitizeFileName(paramMap.get("sabun").toString());
		String signYn = request.getParameter("signYn");

		Log.DebugStart();

		String basePath = PropertyResourceUtil.getHrfilePath(request);
		String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
		
		// 안전한 경로 생성
		Path securePath = SecurePathUtil.getSecurePath(basePath, ssnEnterCd, "picture");
		String path = securePath.toString();
		
		String imgtype = null;

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		FileInputStream ifo = null;
		
		Map<?, ?> img = imageUploadService.thrm911ImageSelect(paramMap);
		try {
			File imgFile = null;
			if(img != null) {
				String imageType = img.get("imageType") != null ? img.get("imageType").toString() : "png";
				imgtype = "." + imageType;
				
				Path thumbPath = SecurePathUtil.getSecurePath(path, "Thum");
				if(signYn != null && "Y".equals(signYn)) {
					Path signPath = SecurePathUtil.getSecurePath(thumbPath.toString(), img.get("sign").toString());
					imgFile = new File(signPath.toString());
				} else {
					Path imagePath = SecurePathUtil.getSecurePath(thumbPath.toString(), sabun + imgtype);
					imgFile = new File(imagePath.toString());
				}
				
				ifo = new FileInputStream(imgFile);
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				byte[] buf = new byte[1024];
				int readlength = 0;
				while((readlength = ifo.read(buf)) != -1) {
					baos.write(buf, 0, readlength);
				}
				byte[] imgbuf = baos.toByteArray();
				baos.close();
				ifo.close();

				int length = imgbuf.length;
				OutputStream out = response.getOutputStream();
				out.write(imgbuf, 0, length);
				out.close();
			} else {
				String defaultImgPath = Paths.get(request.getSession().getServletContext().getRealPath("/"), "common/images/common/img_photo.gif").toString();
				imgFile = new File(defaultImgPath);
			}
		} catch (Exception e) {
			Log.Debug("ImageUploadController.ImageDownload :" + e.getMessage());
		} finally {
			if (ifo != null) ifo.close();
		}
		Log.DebugEnd();
	}



	/**
	 * BLOB Image UpLoad, DownLoad 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSampleConvCamel", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSampleConvCamel() throws Exception {
		return "sample/sampleConvCamel";
	}


	/**
	 * 메뉴명 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/ImageExistYn.do", method=RequestMethod.POST )
	public ModelAndView getTemplateMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		Map<?, ?> map = imageUploadService.imageExistYn(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 서명사진 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/imageSignExistYn.do", method=RequestMethod.POST )
	public ModelAndView imageSignExistYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		Map<?, ?> map = imageUploadService.imageSignExistYn(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}

}