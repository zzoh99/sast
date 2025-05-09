package com.hr.common.other;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.security.PrivateKey;
import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hr.common.exception.HrException;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.RSA;
import com.hr.hrm.appmtBasic.appmtItemMapMgr.AppmtItemMapMgrService;
import org.apache.commons.net.util.Base64;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.PropertyResourceUtil;
import com.hr.common.util.StringUtil;
import com.hr.common.util.securePath.SecurePathUtil;
import java.nio.file.Path;

/**
 * 공통모음
 * @author ParkMoohun
 */
@Controller
public class OtherController {

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	@Autowired
	private AppmtItemMapMgrService appmtItemMapMgrService;

	/*
	 * Sequence 반환
	 */
	//@RequestMapping(params="cmd=getSequence", method = RequestMethod.POST )
	@RequestMapping(value="/Sequence.do", method=RequestMethod.POST )
	public ModelAndView getSequence(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {


		paramMap.put("seqId",		paramMap.get("seqId").toString());
		Map<?, ?> seqNum = otherService.getSequence(paramMap);
		Map<String, String> map = new HashMap<String, String>();
		if(seqNum != null) {
			Log.Debug("seqNum.get=> "+ seqNum.get("getSeq"));
			//paramMap.put("seqNum",seqNum.get("getSeq"));
			
			map.put("seqNum", (String) seqNum.get("getSeq"));
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		return mv;
	}

	/**
	 * POPUP 호출
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/Pop.do", method=RequestMethod.POST )
	public String comPopup() throws Exception {
		return "common/popup/popup";
	}

	/**
	 * POPUP 호출
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/Popg.do", method=RequestMethod.POST )
	public String comPopgup() throws Exception {
		return "common/popup/popupg";
	}


	/**
	 * Image 출력 test
	 *
	 * @param session
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value="/Image.do", method=RequestMethod.POST )
	public void getImagePrint(HttpSession session,HttpServletRequest request,
			HttpServletResponse response,@RequestParam("imgId")String imgId) throws Exception {
		Log.DebugStart();
		String path    = request.getSession().getServletContext().getRealPath("/");
		String enterCd = session.getAttribute("ssnEnterCd").toString();
		String sabun   = session.getAttribute("ssnSabun").toString();

		imgId = StringUtil.replaceAll(imgId,"[ENTER_CD]",enterCd);
		imgId = StringUtil.replaceAll(imgId,"[SABUN]",sabun);
		
		// 파일명만 추출하여 안전하게 처리
		String safeFileName = FilenameUtils.getName(imgId);
		
		// 안전한 경로 생성
		Path securePath = SecurePathUtil.getSecurePath(path, "common", "images", safeFileName);
		File imgFile = securePath.toFile();

		// 파일 미 존재시
		if (!imgFile.isFile()){
			Path secureDefaultPath = SecurePathUtil.getSecurePath(path, "common", "images", "common", "blank.gif");
			imgFile = secureDefaultPath.toFile();
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
				baos.write(buf, 0, readlength);
			}
			byte[] imgbuf = null;
			imgbuf = baos.toByteArray();
			
			int length = imgbuf.length;
			out = response.getOutputStream();
			out.write(imgbuf , 0, length);
		} catch (IOException e) {
			Log.Debug("EXCEPTION: {}", e.getLocalizedMessage());
		} finally {
			if (ifo != null) ifo.close();
			if (baos != null) baos.close();
			if (out != null) out.close();
		}
	}
	
    @RequestMapping(value="/ImageCreate.do", method=RequestMethod.POST )
    public ModelAndView createImage (HttpServletRequest request) throws Exception{
        
        String binaryData = request.getParameter("imgSrc");
        FileOutputStream stream = null;
        ModelAndView mav = new ModelAndView();
        mav.setViewName("jsonView");        
        try{
            if(binaryData == null || "".equals(binaryData)) {
                throw new Exception();    
            }
            
            binaryData = binaryData.replaceAll("data:image/png;base64,", "");
            byte[] file = Base64.decodeBase64(binaryData);
            String fileName = UUID.randomUUID().toString() + ".png";
            
            // 안전한 경로 생성
            Path securePath = SecurePathUtil.getSecurePath(PropertyResourceUtil.getHrfilePath(request), "imagecreate", fileName);
            stream = new FileOutputStream(securePath.toString());
            stream.write(file);
            stream.close();
            mav.addObject("msg","ok");
            
        }catch(Exception e){
            Log.Debug("파일이 정상적으로 넘어오지 않았습니다");
            mav.addObject("msg","no");
            return mav;
        } finally{
        	if (stream != null) stream.close();
        }
        return mav;
        
    }

	@RequestMapping(value="/OrdBatch.do", method=RequestMethod.POST )
	public ModelAndView OrdBatch(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));
			paramMap.put("searchUseYn", "Y");

			resultCnt = otherService.OrdBatch(paramMap, convertMap);
			if(resultCnt > 0){
				message="저장 되었습니다.";
			} else{
				message = "저장된 내용이 없습니다.";
			}
		} catch (HrException he) {
			resultCnt = -1;
			message=he.getMessage();
		} catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

}