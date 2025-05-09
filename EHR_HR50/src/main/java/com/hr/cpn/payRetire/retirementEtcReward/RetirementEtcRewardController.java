package com.hr.cpn.payRetire.retirementEtcReward;

import java.util.Map;

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
 * 퇴직기타수당/공제 Controller
 *
 */
@Controller
@RequestMapping(value="/RetirementEtcReward.do", method=RequestMethod.POST )
public class RetirementEtcRewardController extends ComController {

	/**
	 * 퇴직기타수당/공제 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRetirementEtcReward", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRetirementEtcReward() throws Exception {
		return "cpn/payRetire/retirementEtcReward/retirementEtcReward";
	}

	/**
	 * 퇴직기타수당/공제 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRetirementEtcRewardList", method = RequestMethod.POST )
	public ModelAndView getRetirementEtcRewardList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 * 퇴직기타수당/공제 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRetirementEtcReward", method = RequestMethod.POST )
	public ModelAndView saveRetirementEtcReward(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

	/**
	 * 퇴직기타수당/공제 코드 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getDayLatestCodePopup", method = RequestMethod.POST )
	public ModelAndView getDayLatestCodePopup(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
}
