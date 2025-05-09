package com.hr.wtm.config.wtmHolidayMgr;

import com.hr.common.com.ComController;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 휴일관리 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/WtmHolidayMgr.do", method=RequestMethod.POST )
public class WtmHolidayMgrController extends ComController {

	/**
	 * 휴일관리 서비스
	 */
	@Autowired
	private WtmHolidayMgrService wtmHolidayMgrService;

	/**
	 * 휴일관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmHolidayMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmHolidayMgr() throws Exception {
		return "wtm/config/wtmHolidayMgr/wtmHolidayMgr";
	}

	@RequestMapping(params="cmd=viewWtmHolidayDeleteLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmHolidayDeleteLayer() throws Exception {
		return "wtm/config/wtmHolidayMgr/wtmHolidayDeleteLayer";
	}

	@RequestMapping(params="cmd=viewWtmHolidayCreateLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmHolidayCreateLayer() throws Exception {
		return "wtm/config/wtmHolidayMgr/wtmHolidayCreateLayer";
	}

	/**
	 * 휴일관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmHolidayMgrList", method = RequestMethod.POST )
	public ModelAndView getHolidayMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, List<WtmHolidayDTO>> result  = new HashMap<>();
		String Message = "";
		try {
			result = (Map<String, List<WtmHolidayDTO>>) wtmHolidayMgrService.getWtmHolidayMgrList(paramMap);

		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			Message = e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			Message = "조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 휴일관리 Id로 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmHolidayMgrById", method = RequestMethod.POST )
	public ModelAndView getWtmHolidayMgrById(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<?> result  = new ArrayList<>();
		String Message = "";
		try{
			result = wtmHolidayMgrService.getWtmHolidayMgrById(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 휴일관리 count
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmHolidayMgrCnt", method = RequestMethod.POST )
	public ModelAndView getWtmHolidayMgrCnt(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String Message = "";
		List<?> result  = new ArrayList<>();

		try{
			result = wtmHolidayMgrService.getWtmHolidayMgrCnt(paramMap);
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 휴일관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmHolidayMgr", method = RequestMethod.POST )
	public ModelAndView saveWtmHolidayMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<>();
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		convertMap.putAll(paramMap);
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmHolidayMgrService.saveWtmHolidayMgr(convertMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			message = e.getLocalizedMessage();
		} catch(Exception e){
			e.printStackTrace();
			Log.Error(e.getLocalizedMessage());
			message="저장에 실패 하였습니다.";
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
	 * 휴일관리 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteWtmHolidayMgr", method = RequestMethod.POST )
	public ModelAndView deleteWtmHolidayMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<String, Object>();
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.putAll(paramMap);

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmHolidayMgrService.deleteWtmHolidayMgr(convertMap);
			if (resultCnt > 0) {
				message="삭제 되었습니다.";
			} else {
				message="삭제된 내용이 없습니다.";
			}
		} catch(HrException e) {
			message = e.getLocalizedMessage();
		} catch(Exception e) {
			message = "삭제에 실패 하였습니다.";
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
	 * 한국 공휴일 생성
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=excWtmHolidayMgrKoreanHolidays", method = RequestMethod.POST )
	public ModelAndView excWtmHolidayMgrKoreanHolidays(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		int code = -1;
		String message = "";
		Map<String, List<WtmHolidayDTO>> result = new HashMap<>();
		try {
			code =  wtmHolidayMgrService.excWtmHolidayMgrKoreanHolidays(paramMap);
			if (code <= 0) {
				message = "생성에 실패하였습니다.";
			} else {
				message = "정상적으로 생성되었습니다.";
				result = (Map<String, List<WtmHolidayDTO>>) wtmHolidayMgrService.getWtmHolidayMgrList(paramMap);
			}
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			message = e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message = "생성에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("code", code);
		mv.addObject("message", message);
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 공휴일관리 삭제 시 타입 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmHolidayDeleteLayerDeleteType", method = RequestMethod.POST )
	public ModelAndView getWtmHolidayDeleteLayerDeleteType(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String Message = "";
		Map<String, Object> result = new HashMap<>();

		try {
			result = wtmHolidayMgrService.getWtmHolidayDeleteLayerDeleteType(paramMap);
		} catch(Exception e) {
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 등록 가능 최대 일자 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmHolidayMgrMaxDate", method = RequestMethod.POST )
	public ModelAndView getWtmHolidayMgrMaxDate(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		String Message = "";
		Map<String, Object> result = new HashMap<>();

		try {
			result = wtmHolidayMgrService.getWtmHolidayMgrMaxDate(paramMap);
		} catch(Exception e) {
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


}
