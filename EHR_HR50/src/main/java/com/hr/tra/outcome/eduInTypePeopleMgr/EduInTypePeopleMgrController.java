package com.hr.tra.outcome.eduInTypePeopleMgr;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import com.hr.common.exception.HrException;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 교육일괄신청 Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/EduInTypePeopleMgr.do", method=RequestMethod.POST )
public class EduInTypePeopleMgrController extends ComController {
	/**
	 * 교육일괄신청 서비스
	 */
	@Inject
	@Named("EduInTypePeopleMgrService")
	private EduInTypePeopleMgrService eduInTypePeopleMgrService;
	
	/**
	 * 교육일괄신청 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduInTypePeopleMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduInTypePeopleMgr() throws Exception {
		return "tra/outcome/eduInTypePeopleMgr/eduInTypePeopleMgr";
	}
	
	/**
	 * 교육일괄신청 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduInTypePeopleMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduInTypePeopleMgrPop() throws Exception {
		return "tra/outcome/eduInTypePeopleMgr/eduInTypePeopleMgrPop";
	}
	
	/**
	 * 교육일괄신청 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduInTypePeopleMgrList", method = RequestMethod.POST )
	public ModelAndView getEduInTypePeopleMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 교육일괄신청팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduInTypePeopleMgrPopList", method = RequestMethod.POST )
	public ModelAndView getEduInTypePeopleMgrPopList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 엑셀업로드 후 기신청검사
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduInTypePeopleMgrChk", method = RequestMethod.POST )
	public ModelAndView getEduInTypePeopleMgrChk(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = eduInTypePeopleMgrService.getEduInTypePeopleMgrChk(convertMap);
		}catch(HrException he){
			Message= he.getMessage();
		}catch(Exception e){
			Message=LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다.");
			Log.Debug(e.getLocalizedMessage());
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 교육일괄신청 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveEduInTypePeopleMgr", method = RequestMethod.POST )
	public ModelAndView saveEduInTypePeopleMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();  
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{

			resultCnt = eduInTypePeopleMgrService.saveEduInTypePeopleMgr(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else {
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); 
			}
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.") +"\n("+e.getMessage()+")";
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
