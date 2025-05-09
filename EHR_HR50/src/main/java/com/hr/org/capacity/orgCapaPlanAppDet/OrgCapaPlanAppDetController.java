package com.hr.org.capacity.orgCapaPlanAppDet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.code.CommonCodeService;
import com.hr.common.util.ParamUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.hri.applyApproval.approvalMgr.ApprovalMgrService;

/**
 * 인력충원요청신청 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/OrgCapaPlanApp.do","/OrgCapaPlanAppDet.do"})
public class OrgCapaPlanAppDetController {

	/**
	 * 인력충원요청신청 서비스
	 */
	@Inject
	@Named("OrgCapaPlanAppDetService")
	private OrgCapaPlanAppDetService orgCapaPlanAppDetService;

	/**
	 * 서비스
	 */
	@Inject
	@Named("ApprovalMgrService")
	private ApprovalMgrService approvalMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 인력충원요청신청 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewOrgCapaPlanAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewOrgCapaPlanAppDet(HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnOrgCd", session.getAttribute("ssnOrgCd"));

		Map<String, Object> codeParamMap = new HashMap<String, Object>();
		codeParamMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List codeList = null;

		//요청이유_구분(H33010)
		codeParamMap.put("grpCd","H33010");
		codeList = commonCodeService.getCommonCodeList(codeParamMap);
		mv.addObject("rsnGubunList", codeList);

		//학력코드(H33020)
		codeParamMap.put("grpCd","H33020");
		codeList = commonCodeService.getCommonCodeList(codeParamMap);
		mv.addObject("acaCdList", codeList);
		//직급코드(H33030)
		codeParamMap.put("grpCd","H33030");
		codeList = commonCodeService.getCommonCodeList(codeParamMap);
		mv.addObject("jikgubCdList", codeList);
		//경력코드(H33040)
		codeParamMap.put("grpCd","H33040");
		codeList = commonCodeService.getCommonCodeList(codeParamMap);
		mv.addObject("careerCdList", codeList);


		//조직에 Mapping된 직무
		codeParamMap.put("searchOrgCd",paramMap.get("searchOrgCd"));
		codeParamMap.put("searchApplSabun",paramMap.get("searchApplSabun"));
		codeParamMap.put("searchApplYmd",paramMap.get("searchApplYmd"));
		codeList = orgCapaPlanAppDetService.getjobCodeList(codeParamMap);
		mv.addObject("jobCdList", codeList);

		mv.setViewName("org/capacity/orgCapaPlanAppDet/orgCapaPlanAppDet");
		return mv;
	}
	
	/**
	 * 인력충원요청신청 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgCapaPlanAppDetMap", method = RequestMethod.POST )
	public ModelAndView getOrgCapaPlanAppDetMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

		try{
			map = orgCapaPlanAppDetService.getOrgCapaPlanAppDetMap(paramMap);
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

	/**
	 *  인력충원요청신청  저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgCapaPlanAppDet", method = RequestMethod.POST )
	public ModelAndView saveOrgCapaPlanAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			
			resultCnt = orgCapaPlanAppDetService.saveOrgCapaPlanAppDet(paramMap);
			
			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			
		}catch(Exception e){
			
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
	 * 인력충원요청신청(현재인원) 단건 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgCntMap", method = RequestMethod.POST )
	public ModelAndView getOrgCntMap(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<?, ?> map = null;
		String Message = "";

		try{
			map = orgCapaPlanAppDetService.getOrgCntMap(paramMap);
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

	/* 인력충원요청 삭제 HR 4.0 이관 START */
	/**
	 *  인력충원요청신청  저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgCapaPlanAppDet1", method = RequestMethod.POST )
	public ModelAndView saveOrgCapaPlanAppDet1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = orgCapaPlanAppDetService.saveOrgCapaPlanAppDet1(convertMap);

			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }

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

	/**
	 *  인력충원요청신청  저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveOrgCapaPlanAppDet2", method = RequestMethod.POST )
	public ModelAndView saveOrgCapaPlanAppDet2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = orgCapaPlanAppDetService.saveOrgCapaPlanAppDet2(convertMap);

			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }

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
	/* 인력충원요청 삭제 HR 4.0 이관 END */
}
