package com.hr.common.util.fileupload.jfileupload.imageUpload;

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.FileUtil;
import com.hr.common.util.classPath.ClassPathUtils;
import com.hr.common.util.fileupload.impl.FileUploadConfig;
import com.hr.common.util.securePath.SecurePathUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.ImageIO;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Path;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;


/**
 * 샘플 Controller
 *
 * @author ParkMoohun
 *
 */
@Controller
public class ImageUploadController{
	@Inject
	@Named("ImageUploadService")
	private ImageUploadService imageUploadService;


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

	@RequestMapping(value="/EmployeePhotoSave.do", method=RequestMethod.POST )
	public ModelAndView employeePhotoSave(HttpServletRequest request, HttpServletResponse response, @RequestParam Map paramMap, HttpSession session) throws Exception {
		Log.DebugStart();
		Log.Debug(paramMap.toString());

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Map resultMap = new HashMap();
		try {
			int result = imageUploadService.employeePhotoSave(paramMap);


			if(result == -1) {
				resultMap.put("code","error");
				resultMap.put("message", LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다."));
			} else {
				//사원사진 -> BLOB 저장 로직 추가
				if(paramMap.get("sFileNm") != null) {
					// 파일 저장 기본 위치 정보 조회 및 삽입
					FileUploadConfig config = new FileUploadConfig("pht001");
					String localRootPath = config.getDiskPath();
					String storePath = config.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
					
					// 안전한 파일명 생성
					String safeFileName = SecurePathUtil.sanitizeFileName((String)paramMap.get("sFileNm"));
					
					// 안전한 경로 생성
					Path safePath = SecurePathUtil.getSecurePath(localRootPath, session.getAttribute("ssnEnterCd") + storePath);
					Path safeFilePath = SecurePathUtil.getSecurePath(safePath.toString(), safeFileName);
					
					// 이미지 파일
					File imgFile = new File(safeFilePath.toString());
					Log.Debug(imgFile.getAbsolutePath());

					FileInputStream ifo = new FileInputStream(imgFile);
					ByteArrayOutputStream baos = new ByteArrayOutputStream();

					byte[] buf = new byte[1024];
					int readlength = 0;
					while( (readlength =ifo.read(buf)) != -1 )
					{
						baos.write(buf,0,readlength);
					}

					byte[] imgbuf = null;
					imgbuf = baos.toByteArray();
					baos.close();
					ifo.close();

					paramMap.put("empPicture", imgbuf);
					paramMap.put("empPictureC", Base64.getEncoder().encodeToString(FileUtil.imageToByteArray(imgFile)));

					int resultBlod = imageUploadService.employeePhotoClobUpdate(paramMap);

					if(resultBlod == -1) {
						resultMap.put("code","error");
						resultMap.put("message", "EMP_PICTURE_BLOB_SAVE_FAIL");
					}
				}

				resultMap.put("code","success");
				resultMap.put("message", "");
			}
		} catch (Exception e) {
			Log.Error(e.getLocalizedMessage());
			resultMap.put("code","error");
			resultMap.put("message", "알 수 없는 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);

		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(value="/CompanyPhotoSave.do", method=RequestMethod.POST )
	public ModelAndView companyPhotoSave(HttpServletRequest request, HttpServletResponse response, @RequestParam Map paramMap, HttpSession session) throws Exception {
		Log.DebugStart();
		Log.Debug(paramMap.toString());
		
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		Map resultMap = new HashMap();
		try {
			int result = imageUploadService.companyPhotoSave(paramMap);
			
			
			if(result == -1) {
				resultMap.put("code","error");
				resultMap.put("message", LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다."));
			} else {
				resultMap.put("code","success");
				resultMap.put("message", "");
			}
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			resultMap.put("code","error");
			resultMap.put("message", e.getMessage());
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		
		Log.DebugEnd();
		return mv;
	}
	 
	//사업장 관리 첨부파일 등록
	@RequestMapping(value="/BusinessPlaceSave.do", method=RequestMethod.POST )
	public ModelAndView businessPlaceSave(HttpServletRequest request, HttpServletResponse response, @RequestParam Map paramMap, HttpSession session) throws Exception {
		Log.DebugStart();
		Log.Debug(paramMap.toString());
		
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		Map resultMap = new HashMap();
		try {
			int result = imageUploadService.businessPlaceSave(paramMap);
			
			
			if(result == -1) {
				resultMap.put("code","error");
				resultMap.put("message", LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다."));
			} else {
				resultMap.put("code","success");
				resultMap.put("message", "");
			}
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			resultMap.put("code","error");
			resultMap.put("message", e.getMessage());
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		
		Log.DebugEnd();
		return mv;
	}
	
	
	/**
	 * 사진/서명 이미지 삭제 
	 */
	@RequestMapping(value="/EmployeePhotoDelete.do", method=RequestMethod.POST )
	public ModelAndView employeePhotoDelete(HttpServletRequest request, HttpServletResponse response, @RequestParam Map paramMap, HttpSession session) throws Exception {
		Log.DebugStart();
		Log.Debug(paramMap.toString());
		
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		Map resultMap = new HashMap();
		try {
			int result = imageUploadService.employeePhotoDelete(paramMap);
			
			
			if(result == -1) {
				resultMap.put("code","error");
				resultMap.put("message", LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다."));
			} else {
				resultMap.put("code","success");
				resultMap.put("message", "");
			}
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			resultMap.put("code","error");
			resultMap.put("message", e.getMessage());
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 직원 사진 리사이징
	 * @param request
	 * @param response
	 * @param paramMap
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/EmployeePhotoResize.do", method=RequestMethod.POST )
	public ModelAndView employeePhotoResize(HttpServletRequest request, HttpServletResponse response
			, @RequestParam Map<String, Object> paramMap, HttpSession session) throws Exception {
		Log.DebugStart();
		Log.Debug(paramMap.toString());
		
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		Image image = null;
		
		int stdWidth = 180;
		int imageWidth = 0;
		int imageHeight = 0;
		double ratio = 0;
		int w = 0;
		int h = 0;
		
		try {
			Map<?, ?> map = imageUploadService.getEmployeePhotoInfoMap(paramMap);
			
			if( map != null ) {
				FileUploadConfig config = new FileUploadConfig("pht001");
				
				// 실제 파일 기본 경로
				String realPath = (config.getDiskPath().length()==0 ) ? ClassPathUtils.getClassPathHrfile() : config.getDiskPath();
				
				// 안전한 파일명 생성
				String safeFileName = SecurePathUtil.sanitizeFileName((String)map.get("sFileNm"));
				
				// 안전한 경로 생성
				Path safePath = SecurePathUtil.getSecurePath(realPath, (String)map.get("enterCd") + File.separator + (String)map.get("filePath"));
				Path safeFilePath = SecurePathUtil.getSecurePath(safePath.toString(), safeFileName);
				
				// 이미지 파일
				File imgFile = new File(safeFilePath.toString());
				Log.Debug(imgFile.getAbsolutePath());
				
				if( imgFile != null && imgFile.exists() ) {
					image = ImageIO.read(imgFile);
					if (image != null) {
						// 원본 이미지 사이즈 가져오기
						imageWidth = image.getWidth(null);
						imageHeight = image.getHeight(null);
						
						// 비율 계산
						ratio = (double) stdWidth / (double) imageWidth;
						w = (int)(imageWidth * ratio);
						h = (int)(imageHeight * ratio);
						
						Image resizeImage = image.getScaledInstance(w, h, Image.SCALE_SMOOTH);
						
						// 새 이미지  저장하기 (기존 이미지에 덮어쓰기함)
						BufferedImage newImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
						Graphics g = newImage.getGraphics();
						g.drawImage(resizeImage, 0, 0, null);
						g.dispose();
						
						// 새 이미지 저장 시 안전한 파일명 사용
						String newFileName = SecurePathUtil.sanitizeFileName(String.format("%s.jpg", paramMap.get("searchKeyword")));
						Path newFilePath = SecurePathUtil.getSecurePath(safePath.toString(), newFileName);
						ImageIO.write(newImage, "jpg", new File(newFilePath.toString()));
					}
				}
				
				resultMap.put("code","success");
				resultMap.put("message", "선택하신 사진의 크기가 조정되어 저장되었습니다.");
			} else {
				resultMap.put("code","error");
				resultMap.put("message", LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다."));
			}
			
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			resultMap.put("code","error");
			resultMap.put("message", e.getMessage());
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		
		Log.DebugEnd();
		return mv;
	}
}