package com.hr.main.link;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.util.PropertyResourceUtil;
import com.hr.common.util.securePath.SecurePathUtil;

/**
 *  로그인
 * 
 * @author ParkMoohun
 * 
 */
@Controller

public class LinkController {

	@Inject
	@Named("LinkService")
	private LinkService linkService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	
	/**
	 *링크연결 화면 
	 * 
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	//@RequestMapping(params="cmd=viewLogin", method = {RequestMethod.POST, RequestMethod.GET} )
	
	@RequestMapping(value="/Link.do", method=RequestMethod.POST )
	public ModelAndView viewLogin(HttpSession session,
			@RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		String deLinkStr = "";
		
		if (null == session.getAttribute("ssnSabun")) {
			return new ModelAndView( "redirect:/Login.do?link="+ paramMap.get("link"));
		}
		
		try{
			paramMap.put("data1",	paramMap.get("link"));
			Map<?, ?> deEncLink = otherService.getBase64De(paramMap);
			deLinkStr = deEncLink != null && deEncLink.get("code") != null ? deEncLink.get("code").toString():"";
		}catch(Exception e){
			Log.Debug("=====>"+ e);
			return new ModelAndView( "redirect:/Main.do");
		}		
		
		paramMap.put("prgCd",	deLinkStr);
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
	
		Map<?, ?> map = linkService.getDirectLinkMap(paramMap);
		mv.setViewName("main/link/link");
		mv.addObject("map", map);
		Log.DebugEnd();
		
		return mv;		
		
	}
	
	/**
	 * 조회 이미지 
	 *
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/ComFaceImageLoad.do", method=RequestMethod.POST )
	public void ComFaceImageLoad(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

        String enterCd			= paramMap.get("enterCd").toString();
        String sabun			= paramMap.get("sabun").toString();
        
        Log.DebugStart();
        
        // 기본 경로 설정
        String basePath = PropertyResourceUtil.getHrfilePath(request);
        
        // SecurePathUtil을 사용하여 안전한 경로 생성
        Path imagePath = SecurePathUtil.getSecurePath(basePath, enterCd, "picture");
        
		Map<?, ?> img = linkService.ComFaceImageLoad(paramMap);
		String imgtype = null;

		if(img != null){
			Log.Debug("img.get=> "+ img.get("imageType"));
			imgtype = "."+ img.get("imageType").toString();
		}
		
		// 썸네일 경로 생성
		Path thumbPath = SecurePathUtil.getSecurePath(imagePath.toString(), "Thum");
		Path imageFile = SecurePathUtil.getSecurePath(thumbPath.toString(), sabun + imgtype);
       
 	    File imgFile = imageFile.toFile();
 	    
 	    // 파일 미 존재시 기본 이미지 사용
 	    if (!imgFile.isFile()){ 
 	        String defaultImagePath = request.getSession().getServletContext().getRealPath("/") + "/common/images/common/img_photo.gif";
 	        imgFile = new File(defaultImagePath);
 	    }
 	   
 	    FileInputStream ifo = null;
 	    ByteArrayOutputStream baos = null;
 	    OutputStream out = null;
 	    try {
 	        ifo = new FileInputStream(imgFile);
 	        baos = new ByteArrayOutputStream();
 	        
 	        byte[] buf = new byte[1024];
 	        int readlength = 0;
 	        while( (readlength = ifo.read(buf)) != -1 ){
 	            baos.write(buf, 0, readlength);
 	        }
 	            
 	        byte[] imgbuf = baos.toByteArray();
 	            
 	        int length = imgbuf.length;   
 	        out = response.getOutputStream();    
 	        out.write(imgbuf, 0, length);
 	    } catch (IOException e) {
 	        Log.Debug(e.getLocalizedMessage());
 	    } finally {
 	        if (out != null) out.close();
 	        if (baos != null) baos.close();
 	        if (ifo != null) ifo.close();
 	    }
 	    Log.DebugEnd();
	}
	


}
