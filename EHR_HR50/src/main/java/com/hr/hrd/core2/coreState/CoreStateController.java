package com.hr.hrd.core2.coreState;

import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;


/**
 * 
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/CoreState.do", method=RequestMethod.POST )
public class CoreStateController {

	@Inject
	@Named("CoreStateService")
	private CoreStateService coreStateService;
	
	/**
	 * 핵심인재현황 화면
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCoreState", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCoreState() throws Exception {
		Log.Debug();
		return "hrd/core2/coreState/coreState";
	}
	
	/**
	 * 핵심인재현황 총 인원
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreStateCnt", method = RequestMethod.POST )
	public ModelAndView getCoreStateCnt(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			mv.addObject("DATA", coreStateService.getCoreStateCnt(paramMap));
			mv.addObject("Message", "");
		} catch(Exception e) {
			mv.addObject("DATA", null);
			mv.addObject("Message", "조회에 실패하였습니다.");
		}
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 핵심인재현황 조직 list
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreStateOrgList", method = RequestMethod.POST )
	public ModelAndView getCoreStateOrgList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			mv.addObject("DATA", coreStateService.getCoreStateOrgList(paramMap));
			mv.addObject("Message", "");
		} catch(Exception e) {
			mv.addObject("DATA", null);
			mv.addObject("Message", "조회에 실패하였습니다.");
		}
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 핵심인재현황 조직별 핵심인재인원 list
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCoreStatsOrgMemberList", method = RequestMethod.POST )
	public ModelAndView getCoreStatsOrgMemberList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try {
			mv.addObject("DATA", coreStateService.getCoreStatsOrgMemberList(paramMap));
			mv.addObject("Message", "");
		} catch (Exception e) {
			mv.addObject("DATA", null);
			mv.addObject("Message", "조회에 실패하였습니다.");
		}
		Log.DebugEnd();
		return mv;
	}

}