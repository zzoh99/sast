package com.hr.hrm.job.jobPsnalAssuranceMgr;
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

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * jobPsnalAssuranceMgr Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/JobPsnalAssuranceMgr.do", method=RequestMethod.POST )
public class JobPsnalAssuranceMgrController {
	/**
	 * jobPsnalAssuranceMgr 서비스
	 */
	@Inject
	@Named("JobPsnalAssuranceMgrService")
	private JobPsnalAssuranceMgrService jobPsnalAssuranceMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;	

	/**
	 * jobPsnalAssuranceMgr View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJobPsnalAssuranceMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJobPsnalAssuranceMgr() throws Exception {
		return "hrm/job/jobPsnalAssuranceMgr/jobPsnalAssuranceMgr";
	}

	/**
	 * jobPsnalAssuranceMgr(세부내역) 팝업 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJobPsnalAssuranceMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewJobPsnalAssuranceMgrPop() throws Exception {
		return "hrm/job/jobPsnalAssuranceMgr/jobPsnalAssuranceMgrPop";
	}

	/**
	 * jobPsnalAssuranceMgr 다건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobPsnalAssuranceMgrList", method = RequestMethod.POST )
	public ModelAndView getJobPsnalAssuranceMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));

		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
			if(query != null) {
				Log.Debug("query.get=> "+ query.get("query"));
				paramMap.put("query",query.get("query"));
				
				list = jobPsnalAssuranceMgrService.getJobPsnalAssuranceMgrList(paramMap);
			} else {
				Message="조회에 실패 하였습니다.";
			}
		}catch(Exception e){
			Message="조회에 실패 하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * jobPsnalAssuranceMgr 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveJobPsnalAssuranceMgr", method = RequestMethod.POST )
	public ModelAndView saveJobPsnalAssuranceMgr(
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
			resultCnt =jobPsnalAssuranceMgrService.saveJobPsnalAssuranceMgr(convertMap);
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
	/**
	 * jobPsnalAssuranceMgr 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobPsnalAssuranceMgrMap", method = RequestMethod.POST )
	public ModelAndView getJobPsnalAssuranceMgrMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
	
		Map<?, ?> map = null;
		String Message = "";
	
		try{
			map = jobPsnalAssuranceMgrService.getJobPsnalAssuranceMgrMap(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
	
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", map);
		mv.addObject("Message", Message);
	
		Log.DebugEnd();
		return mv;
	}
}
