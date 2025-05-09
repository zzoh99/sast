package com.hr.wtm.count.wtmDailyCount;

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;


/**
 * 일근태/근무집계 Controllerl
 */
@Controller
@RequestMapping(value="/WtmDailyCount.do", method=RequestMethod.POST )
public class WtmDailyCountController {

	/**
	 * 일근태/근무집계 서비스
	 */
	@Inject
	@Named("WtmDailyCountService")
	private WtmDailyCountService wtmDailyCountService;

	/**
	 * wtmDailyCount View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmDailyCount", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmDailyCount() throws Exception {
		return "wtm/count/wtmDailyCount/wtmDailyCount";
	}
	
	/**
	 * 일근태/근무집계(마감) 수정
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateWtmDailyCountEndYn", method = RequestMethod.POST )
	public ModelAndView updateWtmDailyCountEndYn(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmDailyCountService.updateWtmDailyCountEndYn(paramMap);
			if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 일근태/근무집계 처리
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcWtmDailyCount", method = RequestMethod.POST )
	public ModelAndView prcWtmDailyCount(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("enterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmDailyCountService.prcWtmDailyCount(paramMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(Exception e) {
			Log.Error("저장에 실패 하였습니다. " + e.getLocalizedMessage());
			message = "저장에 실패 하였습니다.";
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

	@RequestMapping(params="cmd=prcWtmDailyCountTest", method = RequestMethod.POST )
	public ModelAndView prcWtmDailyCountTest(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		String message = "";
		int resultCnt = -1;
		try {
			paramMap.put("enterCd", paramMap.get("testEnterCd"));
			paramMap.put("sabun", paramMap.get("testSabun"));
			resultCnt = wtmDailyCountService.prcWtmDailyCount(paramMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else if (resultCnt == 0) {
				message = "저장된 데이터가 없습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(Exception e) {
			Log.Error("저장에 실패 하였습니다. " + e.getLocalizedMessage());
			message = "저장에 실패 하였습니다.";
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
	 * 작업 도중 로그 파일 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteTSYS906ForWtmDailyCount", method = RequestMethod.POST )
	public ModelAndView deleteTSYS904ForPayCalcCre(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		// 파싱할 항목을 , 로 구분하여 스트링형태로 생성
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = 0;

		try{
			resultCnt = wtmDailyCountService.deleteTSYS906ForWtmDailyCount(paramMap);
			if(resultCnt > 0){
				message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다.");
			} else {
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
	 * wtmDailyCount 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmDailyCount", method = RequestMethod.POST )
	public ModelAndView getWtmDailyCount(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = wtmDailyCountService.getWtmDailyCount(paramMap);
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
	 * wtmDailyCount 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getTimWorkEndYn", method = RequestMethod.POST )
	public ModelAndView getTimWorkEndYn(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = wtmDailyCountService.getTimWorkEndYn(paramMap);
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
