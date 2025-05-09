package com.hr.sys.other.noticeTemplateMgr;

import java.util.*;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 알림서식관리 Controller
 * @author P19246
 *
 */
@Controller
@RequestMapping(value="/NoticeTemplateMgr.do", method=RequestMethod.POST )
public class NoticeTemplateMgrController {
	
	@Inject
	@Named("NoticeTemplateMgrService")
	private NoticeTemplateMgrService noticeTemplateMgrService;

	/**
	 * 알림서식관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewNoticeTemplateMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewNoticeTemplateMgr(
				HttpSession session, HttpServletRequest request,
				@RequestParam Map<String, Object> paramMap) throws Exception {
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/other/noticeTemplateMgr/noticeTemplateMgr");
		return mv;
	
	}

	/**
	 * 서식 저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveNoticeTemplateMgr", method = RequestMethod.POST )
	public ModelAndView saveNoticeTemplateMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		String message = "";
		int resultCnt = -1;
		
		try {

			resultCnt = noticeTemplateMgrService.saveNoticeTemplateMgr(convertMap);
			
			if(resultCnt > 0){
				message="저장되었습니다."; 
			} else{
				message="저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			message="저장에 실패하였습니다.";
			resultCnt = -1;
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
	
	/**
	 * 알림서식편집팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewNoticeTemplateMgrEditPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewNoticeTemplateMgrEditPopup(
				HttpSession session, HttpServletRequest request,
				@RequestParam Map<String, Object> paramMap) throws Exception {
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/other/noticeTemplateMgr/noticeTemplateMgrEditPopup");
		return mv;
	}
	
	@RequestMapping(params="cmd=viewNoticeTemplateMgrEditLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewNoticeTemplateMgrEditLayer() {
		return "sys/other/noticeTemplateMgr/noticeTemplateMgrEditLayer";
	}
	

	/**
	 * 서식 내용 저장
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveNoticeTemplateData", method = RequestMethod.POST )
	public ModelAndView saveNoticeTemplateData(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		String message = "";
		int resultCnt = -1;
		
		try {
			// 에디터로 작성된 내용이 있는 경우 실행
			String usingEditorYn = StringUtils.defaultIfBlank((String) paramMap.get("usingEditorYn"), "N");
			if( "Y".equals(usingEditorYn) ) {
				paramMap.put("templateContent", paramMap.get("content"));
			} else {
				paramMap.put("templateContent", paramMap.get("message"));
			}
			resultCnt = noticeTemplateMgrService.saveNoticeTemplateData(paramMap);
			
			if(resultCnt > 0){
				message="저장되었습니다."; 
			} else{
				message="저장된 내용이 없습니다.";
			}
		} catch (Exception e) {
			message="저장에 실패하였습니다.";
			resultCnt = -1;
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

	/**
	 * 서식 데이터 전체 회사 동일 적용
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveNoticeTemplateDeployAll", method = RequestMethod.POST )
	public ModelAndView saveNoticeTemplateDeployAll(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
		
		String message = "";
		int resultCnt = -1;
		
		try {
			resultCnt = noticeTemplateMgrService.saveNoticeTemplateDeployAll(paramMap);
			
			if(resultCnt > 0){
				message="적용되었습니다."; 
			} else{
				message="적용된 내용이 없습니다.";
			}
		} catch (Exception e) {
			message="적용 실패하였습니다.";
			resultCnt = -1;
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

    @RequestMapping(params="cmd=getNoticeTemplateBizCdList", method = RequestMethod.POST )
    public ModelAndView getNoticeTemplateBizCdList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = noticeTemplateMgrService.getNoticeTemplateBizCdList(paramMap);
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

    @RequestMapping(params="cmd=getNoticeTemplateData", method = RequestMethod.POST )
    public ModelAndView getNoticeTemplateData(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = noticeTemplateMgrService.getNoticeTemplateData(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }
}
