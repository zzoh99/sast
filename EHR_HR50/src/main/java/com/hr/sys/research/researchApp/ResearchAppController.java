package com.hr.sys.research.researchApp;

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

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 설문 조사 참여
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/ResearchApp.do", method=RequestMethod.POST )
public class ResearchAppController {

	@Inject
	@Named("ResearchAppService")
	private ResearchAppService researchAppService;
	
	/**
	 * 설문 조사 참여 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResearchApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResearchApp() throws Exception {
		Log.Debug("ResearchAppController.viewResearchApp");
		return "sys/research/researchApp/researchApp";
	}
	/**
	 * 설문 조사 참여 팝업 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=researchAppWriteLayer", method = RequestMethod.POST )
	public String researchAppWriteLayer() throws Exception {
		Log.Debug("ResearchAppController.researchAppWriteLayer");
		return "sys/research/researchApp/researchAppWriteLayer";
	}

	@RequestMapping(params="cmd=researchAppWriteFormLayer", method = RequestMethod.POST )
	public String researchAppWriteFormLayer() throws Exception {
		Log.Debug("ResearchAppController.researchAppWriteLayer");
		return "sys/research/researchApp/researchAppWriteFormLayer";
	}
	/**
	 * 설문 조사 결과 팝업 화면
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=researchAppResultLayer", method = RequestMethod.POST )
	public String researchAppResultLayer() throws Exception {
		Log.Debug("ResearchAppController.researchAppResultLayer");
		return "sys/research/researchApp/researchAppResultLayer";
	}

	/**
	 * 설문 조사 참여 Master 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchAppList", method = RequestMethod.POST )
	public ModelAndView getResearchAppList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> result = researchAppService.getResearchAppList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 참여 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchAppQuestionList", method = RequestMethod.POST )
	public ModelAndView getResearchAppQuestionList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> result = researchAppService.getResearchAppQuestionList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 설문 조사 참여 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchAppQuestionFormList", method = RequestMethod.POST )
	public ModelAndView getResearchAppQuestionFormList(HttpSession session,
												   @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> result = researchAppService.getResearchAppQuestionFormList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 설문 조사 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchAppWriteList", method = RequestMethod.POST )
	public ModelAndView getResearchAppWriteList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> result = researchAppService.getResearchAppWriteList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 설문 조사 참여 선택 중복 결과 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchAppQuestionResultList", method = RequestMethod.POST )
	public ModelAndView getResearchAppQuestionResultList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> result = researchAppService.getResearchAppQuestionResultList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 참여 서술 결과 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchAppQuestionResultDescList", method = RequestMethod.POST )
	public ModelAndView getResearchAppQuestionResultDescList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = researchAppService.getResearchAppQuestionResultDescList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 참여 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResearchAppWrite", method = RequestMethod.POST )
	public ModelAndView saveResearchAppWrite(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = researchAppService.saveResearchAppWrite (convertMap);
			if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 설문 조사 참여 저장 - Form 형
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */

	@RequestMapping(params="cmd=saveResearchAppWriteForm", method = RequestMethod.POST )
	public ModelAndView saveResearchAppWriteForm(HttpSession session,
											 HttpServletRequest request,
											 @RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		String questionStr 		= paramMap.get("sendData").toString();
		String[] questionStrArr = questionStr.split("@");

		List insertRows 		= new ArrayList();
		Map  answerMap			= null;
		String[] answerArr 		= null;

		for(int i=0; i<questionStrArr.length; i++){
			answerArr = questionStrArr[i].split(",");
			answerMap = new HashMap();
			// answerARr
			//[0]itemCd
			//[1]researchSeq
			//[2]questionSeq
			//[3]itemSeq
			//[4]itemNm
			answerMap.put("researchSeq",answerArr[1]);
			answerMap.put("questionSeq",answerArr[2]);
			answerMap.put("answerSeq",	answerArr[3]);
			answerMap.put("answer",		answerArr[4]);
			insertRows.add(answerMap);
		}
		paramMap.put("mergeRows",insertRows);

		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0;
		try{ cnt = researchAppService.saveResearchAppWriteForm (paramMap);
			if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

}