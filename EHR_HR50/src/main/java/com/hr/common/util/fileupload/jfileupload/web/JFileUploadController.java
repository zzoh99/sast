package com.hr.common.util.fileupload.jfileupload.web;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.exception.FileUploadException;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.fileupload.impl.FileHandlerFactory;
import com.hr.common.util.fileupload.impl.IFileHandler;
import com.nhncorp.lucy.security.xss.XssPreventer;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * 파일 업로드가 처리되기 위한 기본적인 환경정보를 처리하는 클래스
 * @author isu system

 */
@Controller("fileuploadJFileUploadController")
@RequestMapping(value="/fileuploadJFileUpload.do", method=RequestMethod.POST )
public class JFileUploadController {

	/**
	 * 서비스
	 */
	@Inject
	@Named("JFileUploadService")
	private JFileUploadService jFileUploadService;

//	@Resource(name="fileupload")
//	private Properties fp;
	
	@Inject
	@Named("SecurityMgrService")
	private SecurityMgrService securityMgrService;
	
	

	/**
	 * file UPLOAD 관리
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=fileMgrPopup", method = RequestMethod.POST )
	public String fileMgrPopup() throws Exception {
		return "common/popup/filePopup";
	}
	
	  /**
     * file UPLOAD 관리
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewFileMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView fileMgrLayer(         
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {

            ModelAndView mv = new ModelAndView();
            mv.setViewName("common/popup/fileLayer");
            mv.addObject("paramMap", paramMap);

        return mv;
    }


	/**
	 * ib file UPLOAD 관리
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIbFileMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewIbFileMgrLayer(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/ibFileLayer");
		mv.addObject("paramMap", paramMap);

		return mv;
	}
	
	@RequestMapping(params="cmd=upload", method = RequestMethod.POST )
	public void upload(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws FileUploadException, JSONException, IOException {
		Log.DebugStart();
		
		JSONObject jsonObject = new JSONObject();
		response.setContentType("text/plain");
		response.setCharacterEncoding("utf-8");

		Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");
		for( Enumeration<String> enumeration = request.getParameterNames(); enumeration.hasMoreElements();) {
	         Object obj = enumeration.nextElement();
	         String s = request.getParameterValues((String)obj)[0];
	         Log.Debug( "Parameter name ="+ obj.toString() + ", Parameter value =["+s+"]" );
		}
		Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");
		
		try {
			String ssnEnterCd 	= session.getAttribute("ssnEnterCd").toString();

			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			Log.Debug("fileHandler >>> "+ fileHandler);
			JSONArray oldJsonArray = fileHandler.upload();
			JSONArray newJsonArray = new JSONArray();

			String enckey = securityMgrService.getEncryptKey(ssnEnterCd);
			for (int i=0; i<oldJsonArray.length(); i++) {
				Object item = oldJsonArray.get(i);
				if (item instanceof JSONObject) {
					String strObject = item.toString();
					JSONObject json = CryptoUtil.cryptoParameter(strObject, "E", enckey, request);
					newJsonArray.put(json);
				}
				//기본 STRING 배열일 경우 추가
				else if (item instanceof String) {
					newJsonArray.put(item);
				}
			}

			jsonObject.put("code", "success");
			jsonObject.put("data", newJsonArray);
			
			response.getWriter().write(jsonObject.toString());
		} catch(FileUploadException fue) {
//			fue.printStackTrace();
			Log.Error(fue.getLocalizedMessage());
			jsonObject.put("code", "error");
			jsonObject.put("msg", "알 수 없는 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
			response.getWriter().write(jsonObject.toString());
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			jsonObject.put("code", "error");
			jsonObject.put("msg", "알 수 없는 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
			response.getWriter().write(jsonObject.toString());
//			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, jsonObject.toString());
		}
		
		Log.DebugEnd();
	}
	
	@RequestMapping(params="cmd=delete", method = RequestMethod.POST )
	public ModelAndView delete(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// comment 시작
		Log.DebugStart();

		String message = "";
		String code = "success";
		
		try{
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			fileHandler.delete();
		}catch(Exception e){
			Log.Debug(e.getLocalizedMessage());
			message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
			code = "error";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("code", code);
		resultMap.put("message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=ibFileDelete", method = RequestMethod.POST )
	public ModelAndView ibFileDelete(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// comment 시작
		Log.DebugStart();

		String message = "";
		String code = "success";

		try{
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			fileHandler.ibDelete();
		}catch(Exception e){
			Log.Debug(e.getLocalizedMessage());
			message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
			code = "error";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("code", code);
		resultMap.put("message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=download", method = RequestMethod.POST )
	public void download( HttpServletRequest request,HttpServletResponse response) throws Exception {
		Log.DebugStart();
		
		IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
		fileHandler.download();
		
		Log.DebugEnd();
	}
	
	@RequestMapping(params="cmd=jFileList", method = RequestMethod.POST )
	public ModelAndView jFileList(HttpSession session,  HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
//		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
//		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
		List<?> list =  jFileUploadService.jFileList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=downloadPdf", method = RequestMethod.POST )
	public void downloadPdf( HttpServletRequest request,HttpServletResponse response) throws Exception {
		Log.DebugStart();
		
		String filePath =  request.getParameter("filePath");
		String fileName =  request.getParameter("fileName");
		
		IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
		if (fileName != null && fileHandler != null) {
			fileName = fileName.replaceAll("[/\\\\]", "");
			fileHandler.downloadPdf(filePath,fileName);
		}
		Log.DebugEnd();
	}
	
	@RequestMapping(params="cmd=jIbFileList", method = RequestMethod.POST )
	public ModelAndView jIbFileList(HttpSession session,  HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
//		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
//		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));

		List<?> list =  jFileUploadService.jIbFileList(paramMap);
		ModelAndView mv = new ModelAndView();
	    Log.Debug(">>>>>>>>>>jFileList<<<<<<<<<<");
	    Log.Debug(paramMap.toString());
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=ibupload", method = RequestMethod.POST )
	public void ibupload(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws FileUploadException, JSONException, IOException {
		Log.DebugStart();
		
		String ssnEnterCd 	= session.getAttribute("ssnEnterCd").toString();
		
		JSONObject jsonObject = new JSONObject();
		response.setContentType("text/plain");
		response.setCharacterEncoding("utf-8");

		Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");
		for( Enumeration<String> enumeration = request.getParameterNames(); enumeration.hasMoreElements();) {
	         Object obj = enumeration.nextElement();
	         String s = request.getParameterValues((String)obj)[0];
	         Log.Debug( "Parameter name ="+ obj.toString() + ", Parameter value =["+s+"]" );
		}
		Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");
		
		try {
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			JSONArray oldJsonArray = fileHandler.ibupload("ibupload", null);
			JSONArray newJsonArray = new JSONArray();
			
			String enckey = securityMgrService.getEncryptKey(ssnEnterCd);
			for (int i=0; i<oldJsonArray.length(); i++) {
				Object item = oldJsonArray.get(i);
				if (item instanceof JSONObject) {
					String strObject = item.toString();
					JSONObject json = CryptoUtil.cryptoParameter(strObject, "E", enckey, request);
					newJsonArray.put(json);
				} 
				//기본 STRING 배열일 경우 추가
				else if (item instanceof String) {
					newJsonArray.put(item);
				}
			}
			jsonObject.put("code", "success");
			jsonObject.put("data", newJsonArray);
			response.getWriter().write(jsonObject.toString());
		} catch(FileUploadException fue) {
			fue.printStackTrace();
			jsonObject.put("code", "error");
			jsonObject.put("msg", fue.getMessage());
			response.getWriter().write(jsonObject.toString());
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());
			jsonObject.put("code", "error");
			jsonObject.put("msg", e.getMessage());
			response.getWriter().write(jsonObject.toString());
		}
		
		Log.DebugEnd();
	}

	@RequestMapping(params="cmd=ibFileUpload", method = RequestMethod.POST )
	public void ibFileUpload(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws FileUploadException, JSONException, IOException {
		Log.DebugStart();

		String ssnEnterCd 	= session.getAttribute("ssnEnterCd").toString();

		JSONObject jsonObject = new JSONObject();
		response.setContentType("text/plain");
		response.setCharacterEncoding("utf-8");

		Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");
		for( Enumeration<String> enumeration = request.getParameterNames(); enumeration.hasMoreElements();) {
			Object obj = enumeration.nextElement();
			String s = request.getParameterValues((String)obj)[0];
			Log.Debug( "Parameter name ="+ obj.toString() + ", Parameter value =["+s+"]" );
		}
		Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");

		try {
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);

			// 파일 리스트 JSON 문자열을 List<Map<String, Object>>로 변환
			String ibFileListStr = XssPreventer.unescape(request.getParameter("fileInfo"));
			ObjectMapper objectMapper = new ObjectMapper();
			List<Map<String, Object>> ibFileList = null;
			if (!ibFileListStr.isEmpty()) {
				// JSON 문자열을 List<Map<String, Object>>로 변환
				ibFileList = objectMapper.readValue(ibFileListStr, new TypeReference<List<Map<String, Object>>>() {});
			}
			JSONArray oldJsonArray = fileHandler.ibupload("ibFileUpload", ibFileList);
			JSONArray newJsonArray = new JSONArray();

			String enckey = securityMgrService.getEncryptKey(ssnEnterCd);
			for (int i=0; i<oldJsonArray.length(); i++) {
				Object item = oldJsonArray.get(i);
				if (item instanceof JSONObject) {
					String strObject = item.toString();
					JSONObject json = CryptoUtil.cryptoParameter(strObject, "E", enckey, request);
					newJsonArray.put(json);
				}
				//기본 STRING 배열일 경우 추가
				else if (item instanceof String) {
					newJsonArray.put(item);
				}
			}
			jsonObject.put("code", "success");
			jsonObject.put("data", newJsonArray);
			response.getWriter().write(jsonObject.toString());
		} catch(FileUploadException fue) {
			fue.printStackTrace();
			jsonObject.put("code", "error");
			jsonObject.put("msg", fue.getMessage());
			response.getWriter().write(jsonObject.toString());
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());
			jsonObject.put("code", "error");
			jsonObject.put("msg", e.getMessage());
			response.getWriter().write(jsonObject.toString());
		}

		Log.DebugEnd();
	}

	@RequestMapping(params="cmd=ibPhotoupload", method = RequestMethod.POST )
	public void ibPhotoupload(HttpServletRequest request, HttpServletResponse response) throws FileUploadException, JSONException, IOException {
		Log.DebugStart();

		JSONObject jsonObject = new JSONObject();
		response.setContentType("text/plain");
		response.setCharacterEncoding("utf-8");

		Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");
		for( Enumeration enumeration = request.getParameterNames(); enumeration.hasMoreElements();) {
			Object obj = enumeration.nextElement();
			String s = request.getParameterValues((String)obj)[0];
			Log.Debug( "Parameter name ="+ obj.toString() + ", Parameter value =["+s+"]" );
		}
		Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");

		try {
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			JSONArray jsonArray = fileHandler.photoFileUpload();

			jsonObject.put("code", "success");
			jsonObject.put("data", jsonArray);

			response.getWriter().write(jsonObject.toString());
		} catch(FileUploadException fue) {
			fue.printStackTrace();
			jsonObject.put("code", "error");
			jsonObject.put("msg", fue.getMessage());
			response.getWriter().write(jsonObject.toString());
		} catch(Exception e) {
			e.printStackTrace();
			jsonObject.put("code", "error");
			jsonObject.put("msg", e.getMessage());
			response.getWriter().write(jsonObject.toString());
		}

		Log.DebugEnd();
	}


	@RequestMapping(params="cmd=ibRecordupload", method = RequestMethod.POST )
	public void ibRecordupload(HttpServletRequest request, HttpServletResponse response) throws FileUploadException, JSONException, IOException {
		Log.DebugStart();

		JSONObject jsonObject = new JSONObject();
		response.setContentType("text/plain");
		response.setCharacterEncoding("utf-8");

		Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");
		for( Enumeration enumeration = request.getParameterNames(); enumeration.hasMoreElements();) {
			Object obj = enumeration.nextElement();
			String s = request.getParameterValues((String)obj)[0];
			Log.Debug( "Parameter name ="+ obj.toString() + ", Parameter value =["+s+"]" );
		}
		Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");

		try {
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			JSONArray jsonArray = fileHandler.recordFileUpload();

			jsonObject.put("code", "success");
			jsonObject.put("data", jsonArray);

			response.getWriter().write(jsonObject.toString());
		} catch(FileUploadException fue) {
			fue.printStackTrace();
			jsonObject.put("code", "error");
			jsonObject.put("msg", fue.getMessage());
			response.getWriter().write(jsonObject.toString());
		} catch(Exception e) {
			e.printStackTrace();
			jsonObject.put("code", "error");
			jsonObject.put("msg", e.getMessage());
			response.getWriter().write(jsonObject.toString());
		}

		Log.DebugEnd();
	}

	@RequestMapping(params="cmd=yjungsanPdfUpload", method = RequestMethod.POST )
	public void yjungsanPdfUpload(HttpServletRequest request, HttpServletResponse response) throws FileUploadException, JSONException, IOException {
		Log.DebugStart();

		JSONObject jsonObject = new JSONObject();
		response.setContentType("text/plain");
		response.setCharacterEncoding("utf-8");

		Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");
		for( Enumeration enumeration = request.getParameterNames(); enumeration.hasMoreElements();) {
			Object obj = enumeration.nextElement();
			String s = request.getParameterValues((String)obj)[0];
			Log.Debug( "Parameter name ="+ obj.toString() + ", Parameter value =["+s+"]" );
		}
		Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");

		try {
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			JSONArray jsonArray = fileHandler.yjungsanPdfUpload();

			jsonObject.put("code", "success");
			jsonObject.put("data", jsonArray);

			response.getWriter().write(jsonObject.toString());
		} catch(FileUploadException fue) {
			fue.printStackTrace();
			jsonObject.put("code", "error");
			jsonObject.put("msg", fue.getMessage());
			response.getWriter().write(jsonObject.toString());
		} catch(Exception e) {
			e.printStackTrace();
			jsonObject.put("code", "error");
			jsonObject.put("msg", e.getMessage());
			response.getWriter().write(jsonObject.toString());
		}

		Log.DebugEnd();
	}


	@RequestMapping(params="cmd=deleteYJungsanPdf", method = RequestMethod.POST )
	public ModelAndView deleteYJungsanPdf(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// comment 시작
		Log.DebugStart();

		String message = "";
		String code = "success";

		try{
			IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
			fileHandler.deleteYJungsanPdf();
		}catch(Exception e){
			e.printStackTrace();
			message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
			code = "error";
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("code", code);
		resultMap.put("message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 파일 시퀀스 데이터 생성 반환
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFileSeq", method = RequestMethod.POST )
	public ModelAndView getFileSeq(HttpSession session,  HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
//		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
//		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));

		String seq =  jFileUploadService.jFileSequence();
		// seq 값 암호화 처리
		String encKey = securityMgrService.getEncryptKey(session.getAttribute("ssnEnterCd").toString());
		seq = CryptoUtil.encrypt(encKey, seq);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", seq);
		Log.DebugEnd();
		return mv;
	}
}
