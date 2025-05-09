package com.hr.hrm.psnalInfo.psnalSchoolMgr;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 개인별학력사항관리 Controller
 *
 * @author jy
 *
 */
@Controller
@RequestMapping(value="/PsnalSchoolMgr.do", method=RequestMethod.POST )
public class PsnalSchoolMgrController extends ComController {

	/**
	 * PsnalSchoolMgr 서비스
	 */
	@Inject
	@Named("PsnalSchoolMgrService")
	private PsnalSchoolMgrService psnalSchoolMgrService;
	
	/**
	 * viewPsnalSchoolMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPsnalSchoolMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewPsnalSchoolMgr() throws Exception {
		return "hrm/psnalInfo/psnalSchoolMgr/psnalSchoolMgr";
	}
	
	/**
	 * PsnalSchoolMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPsnalSchoolMgrList", method = RequestMethod.POST )
	public ModelAndView getPsnalSchoolMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}
	
	/**
	 * 개인별학력사항관리 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=savePsnalSchoolMgr", method = RequestMethod.POST )
	public ModelAndView savePsnalSchoolMgr(
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
			resultCnt =psnalSchoolMgrService.savePsnalSchoolMgr(convertMap);
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