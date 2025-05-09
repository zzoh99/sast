package com.hr.hrm.empRcmd.aiEmpRcmdMgr;

import com.hr.common.com.ComController;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AI인재추천 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/AiEmpRcmdMgr.do", method=RequestMethod.POST )
public class AiEmpRcmdMgrController extends ComController {

	/**
	 * AI인재추천 서비스
	 */
	@Inject
	@Named("AiEmpRcmdMgrService")
	private AiEmpRcmdMgrService aiEmpRcmdMgrService;

	/**
	 * viewAiEmpRcmdMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAiEmpRcmdMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAiEmpRcmdMgr() throws Exception {
		return "hrm/empRcmd/aiEmpRcmdMgr/aiEmpRcmdMgr";
	}

	/**
	 * 추천구분 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAiEmpRcmdMgrType", method = RequestMethod.POST )
	public ModelAndView getAiEmpRcmdMgrType(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = aiEmpRcmdMgrService.getAiEmpRcmdMgrType(paramMap);
		}catch(Exception e){
			Log.Debug(e.getMessage());
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
	 * 추천구분 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAiEmpRcmdMgrTypeMap", method = RequestMethod.POST )
	public ModelAndView getAccRatioMgrMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = aiEmpRcmdMgrService.getAiEmpRcmdMgrTypeMap(paramMap);
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


	/**
	 * saveAiEmpRcmdMgrType 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAiEmpRcmdMgrType", method = RequestMethod.POST )
	public ModelAndView saveAiEmpRcmdMgrType(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Log.Debug(paramMap.toString());

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =aiEmpRcmdMgrService.saveAiEmpRcmdMgrType(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * saveAiEmpRcmdMgrPrompt 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAiEmpRcmdMgrPrompt", method = RequestMethod.POST )
	public ModelAndView saveAiEmpRcmdMgrPrompt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Log.Debug(paramMap.toString());

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =aiEmpRcmdMgrService.saveAiEmpRcmdMgrPrompt(paramMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 점수화정보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAiEmpRcmdMgrScoreInfo", method = RequestMethod.POST )
	public ModelAndView getAiEmpRcmdMgrScoreInfo(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = aiEmpRcmdMgrService.getAiEmpRcmdMgrScoreInfo(paramMap);
		}catch(Exception e){
			Log.Debug(e.getMessage());
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
	 * saveAiEmpRcmdMgrScoreInfo 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAiEmpRcmdMgrScoreInfo", method = RequestMethod.POST )
	public ModelAndView saveAiEmpRcmdMgrScoreInfo(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Log.Debug("saveAiEmpRcmdMgrScoreInfo ====");
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		Log.Debug(convertMap.toString());
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		Log.Debug(convertMap.toString());
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = aiEmpRcmdMgrService.saveAiEmpRcmdMgrScoreInfo(convertMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else{
				message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다.");
			}
		}catch(Exception e){
			resultCnt = -1;
			message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 프롬프트 입력 ViewLayer
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAiEmpRcmdMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAiEmpRcmdMgrLayer() throws Exception {
		return "hrm/empRcmd/aiEmpRcmdMgr/aiEmpRcmdMgrLayer";
	}
}
