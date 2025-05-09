package com.hr.sys.pwrSrch.pwrSrchVwMgr;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import com.hr.common.util.ParamUtils;
import com.hr.common.logger.Log;

/**
 * 조건검색View관리
 * 
 * @author ParkMoohun
 * 
 */
@Controller
@RequestMapping(value="/PwrSrchVwMgr.do", method=RequestMethod.POST )
public class PwrSrchVwMgrController {

	@Inject
	@Named("PwrSrchVwMgrService")
	private PwrSrchVwMgrService pwrSrchVwMgrService;

	/**
	 * 조건검색View관리 화면
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPwrSrchVwMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPwrSrchVwMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("PwrSrchVwMgrController.viewPwrSrchVwMgr");
		return "sys/pwrSrch/pwrSrchVwMgr/pwrSrchVwMgr";
	}

	/**
	 * 조건검색View관리 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPwrSrchVwMgrList", method = RequestMethod.POST )
	public ModelAndView getPwrSrchVwMgrMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = pwrSrchVwMgrService.getPwrSrchVwMgrList(paramMap);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 조건검색View관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePwrSrchVwMgr", method = RequestMethod.POST )
	public ModelAndView savePwrSrchVwMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		// List result = sysPwrSchViewService.getPwrSch(paramMap);
		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해
		// 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		int	result = -1;
		Map<String, Object> resultMap= new HashMap<String, Object>();
		String message = "";
		try{
			result = pwrSrchVwMgrService.savePwrSrchVwMgr(convertMap);
			if (result > 0) { message="저장되었습니다."; } 
			else { message="저장 실퍠 하였습니다."; }
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
		}catch(Exception e){
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	"저장 실패하였습니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", 	resultMap);

		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
}
