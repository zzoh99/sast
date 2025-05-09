package com.hr.sys.research.researchMgr;

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

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.util.ParamUtils;

/**
 * 설문 조사 관리
 * 
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/ResearchMgr.do", method=RequestMethod.POST )
public class ResearchMgrController {

	@Inject
	@Named("ResearchMgrService")
	private ResearchMgrService researchMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	@Inject
	@Named("OtherService")
	private OtherService otherService;
	
	/**
	 * 설문 조사 관리 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResearchMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResearchMgr() throws Exception {
		Log.Debug("ResearchMgrController.viewResearchMgr");
		return "sys/research/researchMgr/researchMgr";
	}
	
	/**
	 * 설문 조사 관리 세부정보 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResearchMgrDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResearchMgrDetailPopup() throws Exception {
		Log.Debug("ResearchMgrController.viewResearchMgrDetailPopup");
		return "sys/research/researchMgr/researchMgrDetailPopup";
	}
	
	/**
	 * 설문 조사 관리 설명 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewResearchMgrDescPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewResearchMgrDescPopup() throws Exception {
		Log.Debug("ResearchMgrController.viewResearchMgrDescPopup");
		return "sys/research/researchMgr/researchMgrDescPopup";
	}
	
	/**
	 * 설문 조사 관리 Master 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchMgrOrgList", method = RequestMethod.POST )
	public ModelAndView getResearchMgrOrgList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = researchMgrService.getResearchMgrOrgList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 Master 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchMgrList", method = RequestMethod.POST )
	public ModelAndView getResearchMgrList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = researchMgrService.getResearchMgrList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 Detail 팝업 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=researchMgrDetailPopup", method = RequestMethod.POST )
	public String researchDetailMgrPopup() throws Exception {
		Log.Debug("ApprovalMgrController.researchMgrDetailPopup");
		return "sys/research/researchMgr/researchMgrDetailPopup";
	}

	@RequestMapping(params="cmd=researchMgrDetailLayer", method = RequestMethod.POST )
	public String researchMgrDetailLayer() throws Exception {
		Log.Debug("ApprovalMgrController.researchMgrDetailLayer");
		return "sys/research/researchMgr/researchMgrDetailLayer";
	}

	/**
	 * 설문 조사 관리 설명 팝업 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=researchMgrDescPopup", method = RequestMethod.POST )
	public String viewResearchDetailMgrDescPopup() throws Exception {
		Log.Debug("ApprovalMgrController.researchMgrDescPopup");
		return "sys/research/researchMgr/researchMgrDescPopup";
	}

	@RequestMapping(params="cmd=researchMgrDescLayer", method = RequestMethod.POST )
	public String viewResearchDetailMgrDescLayer() throws Exception {
		Log.Debug("ApprovalMgrController.researchMgrDescLayer");
		return "sys/research/researchMgr/researchMgrDescLayer";
	}
	/**
	 * 설문 조사 관리 상세 타입 팝업 화면
	 * 
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=researchMgrDetailTypePopup", method = RequestMethod.POST )
	public String researchMgrDetailTypePopup() throws Exception {
		Log.Debug("ApprovalMgrController.researchMgrDetailTypePopup");
		return "sys/research/researchMgr/researchMgrDetailTypePopup";
	}

	@RequestMapping(params="cmd=researchMgrDetailTypeLayer", method = RequestMethod.POST )
	public String researchMgrDetailTypeLayer() throws Exception {
		Log.Debug("ApprovalMgrController.researchMgrDetailTypeLayer");
		return "sys/research/researchMgr/researchMgrDetailTypeLayer";
	}

	/**
	 * 설문 조사 관리 Detail 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchMgrDetailList", method = RequestMethod.POST )
	public ModelAndView getResearchMgrDetailList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = researchMgrService.getResearchMgrDetailList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 세부내역 직급 직책 직위 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchMgrNoticeLvl", method = RequestMethod.POST )
	public ModelAndView getResearchMgrNoticeLvl(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = researchMgrService.getResearchMgrNoticeLvl(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 세부내역 직급 직책 직위 해당 리스트 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchMgrNoticeLvlList", method = RequestMethod.POST )
	public ModelAndView getResearchMgrNoticeLvlList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = researchMgrService.getResearchMgrNoticeLvlList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 Detail 조회
	 * 
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getResearchMgrDetailTypeList", method = RequestMethod.POST )
	public ModelAndView getResearchMgrDetailTypeList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = researchMgrService.getResearchMgrDetailTypeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 설문 조사 관리 Master 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResearchMgr", method = RequestMethod.POST )
	public ModelAndView saveResearchMgr(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = researchMgrService.saveResearchMgr(convertMap);
			if (cnt > 0) { message="저장 되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 Master 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResearchMgrNotice", method = RequestMethod.POST )
	public ModelAndView saveResearchMgrNotice(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = researchMgrService.saveResearchMgrNotice(convertMap);
			if (cnt > 0) { message="저장 되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 Master 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResearchMgrDetail", method = RequestMethod.POST )
	public ModelAndView saveResearchMgrDetail(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = researchMgrService.saveResearchMgrDetail(convertMap);
		if (cnt > 0) { message="저장 되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 Master 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertResearchMgrNotice", method = RequestMethod.POST )
	public ModelAndView insertResearchMgrNotice(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		String getParamNames = "";
		String noticeLvl = paramMap.get("noticeLvl").toString();
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = researchMgrService.insertResearchMgrNotice(convertMap);
			if (cnt > 0) { message="저장 되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 설문 조사 관리 Master 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveResearchMgrDetailType", method = RequestMethod.POST )
	public ModelAndView saveResearchMgrDetailType(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 		session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = 0; 
		try{ cnt = researchMgrService.saveResearchMgrDetailType(convertMap);
			if (cnt > 0) { message="저장 되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
}