package com.hr.tra.requestApproval.eduCancelApp;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 교육취소 신청 Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/EduCancelApp.do", method=RequestMethod.POST )
public class EduCancelAppController extends ComController {

	/**
	 * 교육취소신청 서비스
	 */
	@Inject
	@Named("EduCancelAppService")
	private EduCancelAppService eduCancelAppService;

	/**
	 * 교육취소신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewEduCancelApp", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewEduCancelApp() throws Exception {
		return "tra/requestApproval/eduCancelApp/eduCancelApp";
	}

	/**
	 * 교육취소신청 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getEduCancelAppList", method = RequestMethod.POST )
	public ModelAndView getEduCancelAppList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	/**
	 * 교육취소신청  임시저장 삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteEduCancelApp", method = RequestMethod.POST )
	public ModelAndView deleteEduCancelApp(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = eduCancelAppService.deleteEduCancelApp(convertMap);
			if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
