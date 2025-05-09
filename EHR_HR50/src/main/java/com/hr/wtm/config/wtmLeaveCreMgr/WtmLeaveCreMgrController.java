package com.hr.wtm.config.wtmLeaveCreMgr;

import com.hr.common.com.ComController;
import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
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
 * 휴가생성 Controller
 *
 * @author kwook
 *
 */
@Controller
@RequestMapping(value="/WtmLeaveCreMgr.do", method=RequestMethod.POST )
public class WtmLeaveCreMgrController extends ComController {

	/**
	 * 휴가생성 서비스
	 */
	@Autowired
	private WtmLeaveCreMgrService wtmLeaveCreMgrService;

	/**
	 * 휴가생성 View
	 *
	 * @return String
     */
	@RequestMapping(params="cmd=viewWtmLeaveCreMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmLeaveCreMgr() {
		return "wtm/config/wtmLeaveCreMgr/wtmLeaveCreMgr";
	}

	/**
	 * 휴가생성_레이어 View
	 *
	 * @return String
     */
	@RequestMapping(params="cmd=viewWtmLeaveCreMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewWtmLeaveCreMgrLayer() {
		return "wtm/config/wtmLeaveCreMgr/wtmLeaveCreMgrLayer";
	}

	/**
	 * 휴가생성 리스트 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWtmLeaveCreMgrList", method = RequestMethod.POST )
	public ModelAndView getWtmLeaveCreMgrList(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		List<Map<String, Object>> result  = new ArrayList<>();
		String Message = "";
		try {
			result = wtmLeaveCreMgrService.getWtmLeaveCreMgrList(paramMap);
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
	 * 휴가생성 저장
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWtmLeaveCreMgr", method = RequestMethod.POST )
	public ModelAndView saveWtmLeaveCreMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		convertMap.putAll(paramMap);
		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmLeaveCreMgrService.saveWtmLeaveCreMgr(convertMap);

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

	/**
	 * 휴가생성 저장
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=excCreateWtmLeaves", method = RequestMethod.POST )
	public ModelAndView excCreateWtmLeaves(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType", session.getAttribute("ssnSearchType"));
		paramMap.put("ssnGrpCd", session.getAttribute("ssnGrpCd"));
		paramMap.put("ssnBaseDate", session.getAttribute("ssnBaseDate"));
		paramMap.put("srchSeq", paramMap.get("searchSeq"));

		String message = "";
		int resultCnt = -1;
		try {
			resultCnt = wtmLeaveCreMgrService.excCreateWtmLeaves(paramMap);

			if (resultCnt > 0) {
				message = "휴가생성이 완료되었습니다.";
			} else {
				message = "휴가생성에 실패 하였습니다.";
			}
		} catch(Exception e) {
			e.printStackTrace();
			Log.Error("휴가생성에 실패 하였습니다. " + e.getLocalizedMessage());
			message = "휴가생성에 실패 하였습니다.";
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
	 * 휴가생성_레이어 휴가생성 정보 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
     */
	@RequestMapping(params="cmd=getWtmLeaveCreMgrLayerStdInfo", method = RequestMethod.POST )
	public ModelAndView getWtmLeaveCreMgrLayerStdInfo(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) {

		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, Object> result  = new HashMap<>();
		String Message = "";
		try {
			result = wtmLeaveCreMgrService.getWtmLeaveCreMgrLayerStdInfo(paramMap);
		} catch(HrException e) {
			Log.Error(e.getLocalizedMessage());
			Message = "조회에 실패 하였습니다." + e.getLocalizedMessage();
		} catch(Exception e) {
			e.printStackTrace();
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
}
