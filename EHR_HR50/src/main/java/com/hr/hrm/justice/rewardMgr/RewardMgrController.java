package com.hr.hrm.justice.rewardMgr;

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

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 포상내역관리 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/RewardMgr.do", method=RequestMethod.POST )
public class RewardMgrController {

	/**
	 * 포상내역관리 서비스
	 */
	@Inject
	@Named("RewardMgrService")
	private RewardMgrService rewardMgrService;

	/**
	 * viewRewardMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewRewardMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewRewardMgr() throws Exception {
		return "hrm/justice/rewardMgr/rewardMgr";
	}
	
	/**
	 * 포상내역관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getRewardMgrList", method = RequestMethod.POST )
	public ModelAndView getRewardMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

		Map<String, String> listCnt = new HashMap<String, String>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		String Message = "";
		try{

			listCnt = rewardMgrService.getRewardMgrListCnt(paramMap);
			list = rewardMgrService.getRewardMgrList(paramMap);

		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("TOTAL", listCnt.get("cnt") ) ;
		mv.addObject("Botal","");
		mv.addObject("Message", Message);
		mv.addObject("DATA", list);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * saveRewardMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveRewardMgr", method = RequestMethod.POST )
	public ModelAndView saveRewardMgr(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt =rewardMgrService.saveRewardMgr(convertMap);
			if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
