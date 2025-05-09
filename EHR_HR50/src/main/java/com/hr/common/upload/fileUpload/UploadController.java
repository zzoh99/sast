package com.hr.common.upload.fileUpload;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.common.util.FileControl;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import com.hr.common.util.securePath.SecurePathUtil;
import java.nio.file.Path;


/**
 * 공통 업로드
 * @author ParkMoohun
 */

@Controller
@RequestMapping(value="/Upload.do", method=RequestMethod.POST )
public class UploadController {

	@Inject
	@Named("UploadService")
	private UploadService uploadService;

	/**
	 * UPLOAD 관리 UploadMgr POPUP
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=uploadMgrPopup", method = RequestMethod.POST )
	public String uploadMgrPopup() throws Exception {
		return "common/popup/uploadMgrPopup";
	}


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
	 * file uploadMgrForm
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=uploadMgrForm", method = RequestMethod.POST )
	public ModelAndView uploadMgrForm(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/uploadMgrIframe");
		mv.addObject("param", paramMap);
		return mv;
	}

	/**
	 * file uploadMgrForm
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIbUploadMgrIframe", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewIbUploadMgrIframe(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("common/popup/ibUploadMgrIframe");
		mv.addObject("param", paramMap);
		return mv;
	}

    /**
     * file UPLOAD 관리
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewFileMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView fileMgrLayer(HttpSession session, @RequestParam Map<String, Object> paramMap, HttpServletRequest request
            ) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("common/popup/fileLayer");
        mv.addObject("paramMap", paramMap);
        return mv;
    }
    
	/**
	 * UPLOAD 관리 UploadMgr 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getFileList", method = RequestMethod.POST )
	public ModelAndView getFileList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));

		List<?> list =  uploadService.getFileList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("data", list);
		Log.DebugEnd();
		return mv;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=uploadAction", method = RequestMethod.POST )
	public void uploadAction(HttpServletRequest request,
							HttpServletResponse response,
							HttpSession session,
							@RequestParam Map<String, Object> paramMap) throws ServletException, IOException
	{
		String workFolder = paramMap.get("work").toString();
		String work = workFolder + DateUtil.getCurrentDay("yyyyMM");
		String basePath = request.getSession().getServletContext().getRealPath("");
		
		// SecurePathUtil을 사용하여 안전한 작업 경로 생성
		Path workPath = SecurePathUtil.getSecurePath(basePath, work);
		
		Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ workPath : " + workPath.toString());
		Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");
		Log.Debug("request.getContextPath(): " + request.getContextPath());
		Log.Debug("request.getRealPath('') : " + basePath);
		Log.Debug("File Upload Path        : " + workPath.toString());
		Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");

		PrintWriter out = null;
		String rtnStr = "";
		FileControl fc = null;

		// 안전한 디렉토리 생성
		try {
			SecurePathUtil.createSecureDirectory(basePath, work);
		} catch (Exception e) {
			Log.Debug("Directory creation failed: " + e.getMessage());
			throw new ServletException("Failed to create upload directory", e);
		}

		try {
			request.setCharacterEncoding("utf-8");

			//파일 컨트롤 생성
			fc = new FileControl(workPath.toString());
			//파일저장,삭제,다운로드 (request,response,파일명 변경 여부)
			String str = fc.fileWork(request, response, session, true);

			Log.Debug("fc.fileWork : "+str);
			if(!"".equals(str)){
				//파일 삭제나 다운로드의 경우
				if("DELETE".equals(str)){
					Log.Debug("### DELETE ###");
					rtnStr = fc.getSheetReturnXml();

					//삭제된 파일 정보를 디비에 저장
//					setFileData(request, response, session, (ArrayList)session.getAttribute("FileList"));
					Log.Debug("삭제DB 처리"+rtnStr);
					String getParamNames = "sNo,sStatus,fileSeq,seqNo";
					Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML( request, getParamNames, "");
					//Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

					convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
					convertMap.put("ssnLocaleCd",session.getAttribute("ssnLocaleCd"));
					convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
					int cnt = uploadService.deleteFile(convertMap);
					Log.Debug("삭제 파일수 : "+cnt);
				}else if("DOWNLOAD".equals(str)){
					Log.Debug("### DOWNLOAD ###");
					rtnStr = fc.getSheetReturnXml();
				}else{
					Log.Debug("### UPLOAD ###");
					//파일이 업로드의 경우
					if("true".equals((String)session.getAttribute("FinalFinish"))){
						Log.Debug("모든 파일이 전송 되었습니다!!!!");

						//세션에 들어간 내용 확인하기(그냥확인 용도)
						fc.sessionCheck(session);

						/*
						* 파일 정보를 디비에 저장한다면 여기서 저장해야 함.
						* to do.....
						*/
						//파일 정보에  문서번호(contentNo)를 같이 넣어 저장로직으로 전달하자.
						//String contentNo = request.getParameter("contentNo");
						List<Map<? ,?>> li  = (List<Map<? ,?>>) session.getAttribute("FileList");
						//List<Map<? ,?>> rt = new ArrayList<>();
						//저장
//						setFileData(request, response, session, rt);
						Map<String, Object> uMap  = new HashMap<>();
						uMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
						uMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
						uMap.put("ssnSabun", session.getAttribute("ssnSabun"));
//						uMap.put("fileSeq",uploadService.getFileSequence());
						uMap.put("fileSeq", request.getParameter("fileSeq"));
						uMap.put("upFile", li);


						int cnt = uploadService.insertUpload(uMap);
						Log.Debug("저장 파일 수 :"+cnt);
						//세션에 설정된 파일 정보를 ETCDATA에 추가한다.
						//fc.setEtcData(session);
						//반드시 세션을 초기화 해줘야 함.
						fc.sessionClear(session);
					}
					rtnStr = fc.getReturnXml();
				}
			}else{
				Log.Debug("Else");
			}
		}catch(Exception ex){
			Log.Debug("ERROR~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			//ex.printStackTrace();
			if(fc != null) fc.sessionClear(session);
			Object fileSeq = paramMap.get("fileSeq");

			if(fileSeq==null){
				rtnStr = fc.getReturnXml();
			}else{
				rtnStr = ex.getMessage();
			}
		}
		try{

			response.setContentType("text/xml");
			response.setCharacterEncoding("utf-8");
			out = response.getWriter();
			//최종 결과 xml을 전송한다.
			out.print(rtnStr);
		} catch(Exception e){ Log.Debug(e.getLocalizedMessage()); }
	}

	/**
	 * 첨부파일 미리보기 팝업
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=uploadMgrViewPopup", method = RequestMethod.POST )
	public String uploadMgrViewPopup(HttpSession session,
									 @RequestParam Map<String, Object> paramMap,
									 HttpServletRequest request, Model model) throws Exception {
		Log.DebugStart();
		model.addAttribute("fileURL", paramMap.get("fileURL"));
		model.addAttribute("fileExt", paramMap.get("fileExt"));
		return "common/popup/uploadMgrViewPopup";
	}

}