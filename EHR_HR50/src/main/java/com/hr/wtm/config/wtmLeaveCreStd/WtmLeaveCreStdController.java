package com.hr.wtm.config.wtmLeaveCreStd;

import com.hr.common.com.ComController;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 휴가생성기준 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/WtmLeaveCreStd.do", method=RequestMethod.POST )
public class WtmLeaveCreStdController extends ComController {

	/**
	 * 휴가생성기준 서비스
	 */
	@Autowired
	private WtmLeaveCreStdService wtmLeaveCreStdService;

	/**
	 * 휴가생성기준 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmLeaveCreStd", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmLeaveCreStd() throws Exception {
		return "wtm/config/wtmLeaveCreStd/wtmLeaveCreStd";
	}

	/**
	 * 휴가생성기준_연차코드 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmLeaveCreStdLeaveCdMap", method = RequestMethod.POST )
	public ModelAndView getWtmLeaveCreStdLeaveCdMap(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, Object> result  = new HashMap<>();
		String Message = "";
		try {
			result = wtmLeaveCreStdService.getWtmLeaveCreStdLeaveCdMap(paramMap);
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			Message = "조회에 실패 하였습니다." + e.getLocalizedMessage();
		} catch(Exception e) {
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
	 * 휴가생성기준_대상자조건검색 리스트 조회 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmLeaveCreStdSearchSeqList", method = RequestMethod.POST )
	public ModelAndView getWtmLeaveCreStdSearchSeqList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<Map<String, Object>> result = new ArrayList<>();
		String Message = "";
		try {
			result = wtmLeaveCreStdService.getWtmLeaveCreStdSearchSeqList(paramMap);
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			Message = "조회에 실패 하였습니다." + e.getLocalizedMessage();
		} catch(Exception e) {
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
	 * 휴가생성기준 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmLeaveCreStdMap", method = RequestMethod.POST )
	public ModelAndView getWtmLeaveCreStdMap(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, Object> result  = new HashMap<>();
		String Message = "";
		try {
			result = wtmLeaveCreStdService.getWtmLeaveCreStdMap(paramMap);
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			Message = "조회에 실패 하였습니다." + e.getLocalizedMessage();
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
	 * 휴가생성기준 저장
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmLeaveCreStd", method = RequestMethod.POST )
	public ModelAndView saveWtmLeaveCreStd(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<>();
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		convertMap.putAll(paramMap);
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmLeaveCreStdService.saveWtmLeaveCreStd(convertMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			message = "저장에 실패 하였습니다." + e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
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
	 * 휴가생성기준 조건검색 저장
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmLeaveCreStdAddSearchSeq", method = RequestMethod.POST )
	public ModelAndView saveWtmLeaveCreStdAddSearchSeq(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		Map<String, Object> resultMap = new HashMap<>();
		try{
			resultCnt = wtmLeaveCreStdService.saveWtmLeaveCreStdAddSearchSeq(paramMap);

			if (resultCnt > 0) {
				message = "저장 되었습니다.";
			} else {
				message = "저장에 실패 하였습니다.";
			}
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			message = "저장에 실패 하였습니다." + e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message = "저장에 실패 하였습니다.";
		}

		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 휴가생성기준 조건검색 저장
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmLeaveCreStdModifySearchSeq", method = RequestMethod.POST )
	public ModelAndView saveWtmLeaveCreStdModifySearchSeq(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = new HashMap<>();
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		convertMap.putAll(paramMap);
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = wtmLeaveCreStdService.saveWtmLeaveCreStdModifySearchSeq(convertMap);

			if (resultCnt > 0) {
				message = "수정되었습니다.";
			} else {
				message = "수정에 실패 하였습니다.";
			}
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			message = "수정에 실패 하였습니다." + e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			message = "수정에 실패 하였습니다.";
		}

		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 휴가생성기준_연차부여 예상 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmLeaveCreStdSimulationList", method = RequestMethod.POST )
	public ModelAndView getWtmLeaveCreStdSimulationList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, List<WtmLeaveCreSimulationDTO>> result = new HashMap<>();
		String Message = "";
		try {
			result = wtmLeaveCreStdService.getWtmLeaveCreStdSimulationMap(paramMap);
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			Message = "조회에 실패 하였습니다. " + e.getLocalizedMessage();
		} catch(Exception e) {
			Log.Error(e.getLocalizedMessage());
			e.printStackTrace();
			Message = "조회에 실패 하였습니다. 관리자에게 문의 바랍니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
}
