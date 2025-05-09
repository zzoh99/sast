package com.hr.hrm.appmt.timeOffPatAppmtFamMgr;

import java.util.HashMap;
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
 * 육아휴직 대상자녀 관리 Controller
 * @author P19246
 *
 */
@Controller
@RequestMapping(value="/TimeOffPatAppmtFamMgr.do", method=RequestMethod.POST )
public class TimeOffPatAppmtFamMgrController {
	
	/** 육아휴직 대상자녀 관리 서비스 */
	@Inject
	@Named("TimeOffPatAppmtFamMgrService")
	private TimeOffPatAppmtFamMgrService timeOffPatAppmtFamMgrService;

	/**
	 * 육아휴직 대상자녀 관리 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveTimeOffPatAppmtFamMgr", method = RequestMethod.POST )
	public ModelAndView saveTimeOffPatAppmtFamMgr(
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
			resultCnt =timeOffPatAppmtFamMgrService.saveTimeOffPatAppmtFamMgr(convertMap);
			if(resultCnt > 0) { message="저장되었습니다.";} else if(resultCnt == 0) {message="저장된 내용이 없습니다.";}
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패하였습니다.";
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
