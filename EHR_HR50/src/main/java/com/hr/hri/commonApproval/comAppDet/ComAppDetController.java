package com.hr.hri.commonApproval.comAppDet;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 공통신청 세부내역 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping({"/ComAppDet.do", "/ComApp.do"})
public class ComAppDetController extends ComController {

	@Inject
	@Named("ComAppDetService")
	private ComAppDetService comAppDetService;

	/**
	 * 공통신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewComAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewComAppDet( HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		String viewName = "hri/commonApproval/comAppDet/comAppDetHtml";
		Map<?, ?> map = null;
		try{
			map = comAppDetService.getComAppDetAppType(paramMap);
			String applTypeCd = "";
			if(map != null) {
				applTypeCd = String.valueOf(map.get("applTypeCd"));
			}
			
			if("HTML".equals(applTypeCd)) {
				viewName = "hri/commonApproval/comAppDet/comAppDetHtml";
			} else if("DATA".equals(applTypeCd)) {
				viewName = "hri/commonApproval/comAppDet/comAppDetData";
			} else if("SHEET".equals(applTypeCd)) {
				viewName = "hri/commonApproval/comAppDet/comAppDetSheet";
			}
		} catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());
		}
		return viewName;
	}
	
	/**
	 * 공통신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppDet", method = RequestMethod.POST )
	public ModelAndView getComAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}
	
	/**
	 * 공통신청 상세 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getComAppDetData", method = RequestMethod.POST )
	public ModelAndView getComAppDetData(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("seqList", comAppDetService.getSeqList(paramMap));
		return getDataList(session, request, paramMap);
	}

	/**
	 * 공통신청  저장 ( HTML )
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveComAppDet", method = RequestMethod.POST )
	public ModelAndView saveComAppDet(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = comAppDetService.saveComAppDet(paramMap);
			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			
		}catch(Exception e){
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 공통신청  저장 ( DATA )
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveComAppDetData", method = RequestMethod.POST )
	public ModelAndView saveComAppDetData(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		return saveData(session, request, paramMap);
	}
}