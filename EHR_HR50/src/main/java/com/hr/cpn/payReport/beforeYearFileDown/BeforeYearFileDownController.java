package com.hr.cpn.payReport.beforeYearFileDown;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.nio.file.Path;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jazzlib.ZipEntry;
import net.sf.jazzlib.ZipOutputStream;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.PropertyResourceUtil;
import com.hr.common.util.securePath.SecurePathUtil;

/**
 * 원천징수영수증파일다운 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/BeforeYearFileDown.do", method=RequestMethod.POST )
public class BeforeYearFileDownController {
	/**
	 * 원천징수영수증파일다운 서비스
	 */
	@Inject
	@Named("BeforeYearFileDownService")
	private BeforeYearFileDownService beforeYearFileDownService;

	/**
	 * 원천징수영수증파일다운 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewBeforeYearFileDown", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewBeforeYearFileDown() throws Exception {
		return "cpn/payReport/beforeYearFileDown/beforeYearFileDown";
	}

	/**
	 * 원천징수영수증파일다운 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getBeforeYearFileDownList", method = RequestMethod.POST )
	public ModelAndView getBeforeYearFileDownList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = beforeYearFileDownService.getBeforeYearFileDownList(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
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
	@RequestMapping(params="cmd=getBeforeYearZipFileDown", method = RequestMethod.POST )
	public void ImageZipDownload(
			HttpSession session,  HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		Log.Debug("BeforeYearFileDown.ImageZipDownload Start");

		String str = (String)paramMap.get("imgName");
		String yyyy = (String)paramMap.get("yyyy");
		String adjustTypeNm = "";

		if ( "1".equals((String)paramMap.get("adjustType")) ){
			adjustTypeNm = "근로소득원천징수영수증";
		}else if ( "3".equals((String)paramMap.get("adjustType")) ){
			adjustTypeNm = "퇴직소득원천징수영수증";
		}

		String[] imgName = str.split(",");
		
		// 기본 경로 설정
		String basePath = PropertyResourceUtil.getHrfilePath(request);
		
		// SecurePathUtil을 사용하여 안전한 경로 생성
		Path workPath = SecurePathUtil.getSecurePath(basePath, 
			session.getAttribute("ssnEnterCd").toString(),
			"workcerti",
			adjustTypeNm,
			yyyy);

		java.util.Date d = new java.util.Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String toDay = df.format(d);

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		FileInputStream in  = null;
		ZipOutputStream out = null;
		BufferedInputStream bis = null;

		try{
			if(str != null){
				int size = 1024;
				byte[] buf = new byte[size];

				Path zipPath = SecurePathUtil.getSecurePath(workPath.toString(), toDay + ".zip");
				String zipName = zipPath.toString();

				out = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(zipName)));

				//파일 압축
				for (int i=0; i<imgName.length; i++) {
					// 파일명 검증 및 안전한 처리
					String imgFileName = SecurePathUtil.sanitizeFileName(imgName[i]);
					if (imgFileName == null || imgFileName.isEmpty()) {
						continue;
					}
					
					Path imgPath = SecurePathUtil.getSecurePath(workPath.toString(), imgFileName);
					in = new FileInputStream(imgPath.toFile());
					bis = new BufferedInputStream(in, size);
					
					out.putNextEntry(new ZipEntry(imgFileName));
					
					int len;
					while ((len = in.read(buf,0,size)) > 0) {
						out.write(buf, 0, len);
					}

					out.closeEntry();
					bis.close();
					in.close();
				}

				out.flush();
				out.close();

				download(request, response, zipName);
			}
		}catch (Exception e) {
			Log.Debug("ImageUploadController.ImageDownload :"+e.getMessage());
		}finally{

			try{
				if ( in != null ){
					in.close();
				}
			}catch (Exception e) {
				Log.Debug("ImageUploadController.ImageDownload :"+e.getMessage());
			}
			try{
				if ( bis != null ){
					bis.close();
				}
			}catch (Exception e) {
				Log.Debug("ImageUploadController.ImageDownload :"+e.getMessage());
			}
			try{
				if ( out != null ){
					out.close();
				}
			}catch (Exception e) {
				Log.Debug("ImageUploadController.ImageDownload :"+e.getMessage());
			}
		}

		Log.Debug("BeforeYearFileDown.ImageZipDownload End");
	}

	public void download(HttpServletRequest request, HttpServletResponse response, String filePath) throws Exception {


		File downfile = new File(filePath);

		String browserName = getBrowser(request);

		if ("Opera".equals(browserName)){
			response.setHeader("Content-Type", "application/octet-stream;charset=UTF-8");
		} else {
			response.setHeader("Content-Type", "application/octet-stream");
		}

		if(!downfile.exists()) {
			throw new Exception("<script>alert('파일이 존재하지 않습니다');</script>");
		}

		OutputStream outStream = null;
		InputStream inputStream = null;

		try {
			inputStream = new FileInputStream(downfile);

			//Setting Resqponse Header
			response.reset() ;
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Description", "JSP Generated Data");

			response.setHeader("Content-Disposition","attachment;filename=\""+downfile.getName()+"\"");

			//Writing InputStream to OutputStream
			byte b[] = new byte[1024];
			int numRead = 0;
			outStream = response.getOutputStream();
			while ((numRead = inputStream.read(b)) != -1) {
				outStream.write(b, 0, numRead);
			}
			inputStream.close();
			outStream.close();
		} catch (Exception e) {
			throw new IOException();
		} finally {
			if(inputStream != null) inputStream.close();
			if(outStream != null) outStream.close();
			downfile.delete();
		}
	}

	private String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1) {
			return "MSIE";
		} else if (header.indexOf("Chrome") > -1) {
			return "Chrome";
		} else if (header.indexOf("Opera") > -1) {
			return "Opera";
		} else if (header.indexOf("Safari") > -1) {
			return "Safari";
		}
		return "Firefox";
	}
}

