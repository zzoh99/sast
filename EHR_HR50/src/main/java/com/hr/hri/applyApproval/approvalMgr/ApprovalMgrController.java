package com.hr.hri.applyApproval.approvalMgr;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.appPush.PushServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.notification.NotificationService;
import com.hr.common.other.OtherService;
import com.hr.common.util.StringUtil;

/**
 * 신청서 결재 관리
 *
 * @author ParkMoohun
 */
@Controller
@SuppressWarnings("unchecked")
@RequestMapping(value="/ApprovalMgr.do", method=RequestMethod.POST )
public class ApprovalMgrController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Inject
	@Named("ApprovalMgrService")
	private ApprovalMgrService approvalMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;
	
	@Inject
	@Named("NotificationService")
	private NotificationService notificationService;

	@Autowired
	private PushServiceImpl pushService;

//	@Autowired
//	private CommonMailController commonMailController;
	
	/**
	 * 신청서 결재 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewApprovalMgr(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("ApprovalMgrController.viewApprovalMgr");
		ModelAndView mv = new ModelAndView();
		//session.removeAttribute("ssnSabun");
		//session.setAttribute("ssnSabun", "P10062");
		paramMap.put("ssnSabun",		session.getAttribute("ssnSabun")		);
		paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd")		);
		paramMap.put("ssnLocaleCd", 	session.getAttribute("ssnLocaleCd"));
		String searchApplSabun  = paramMap.get("searchApplSabun").toString();
		String searchApplSeq   	= paramMap.get("searchApplSeq").toString();
		String searchApplCd   	= paramMap.get("searchApplCd").toString();
		String adminYn			= paramMap.get("adminYn").toString();
		String authPg   		= paramMap.get("authPg").toString();
		String searchApplYmd   	= paramMap.get("searchApplYmd").toString();
		String searchSabun  	= paramMap.get("searchSabun").toString();
		String etc01  			= (String)paramMap.get("etc01");
		String etc02  			= (String)paramMap.get("etc02");
		String etc03  			= (String)paramMap.get("etc03");
		String reUseYn          = (String)paramMap.get("reUseYn");	//재사용여부
		String reApplSeq 	= "";		//재사용시 새로운 문서 SEQ
		String applSeqExist 	= "Y";
		//getSequence
		if(null == paramMap.get("searchApplSeq")|| paramMap.get("searchApplSeq").toString().equals("")) {
			paramMap.put("seqId","APPL");
			Map<?, ?> sequenceMap = (Map<?, ?>)otherService.getSequence(paramMap);
			
			searchApplSeq = String.valueOf(sequenceMap.get("getSeq"));
			if("null".equals(searchApplSeq)) {
				searchApplSeq = "";
			}
			
			applSeqExist = "N";
			Log.Debug("SEQ NULL");
		}

		if ("Y".equals(reUseYn)) {
		    paramMap.put("seqId", "APPL");
		    Map<?, ?> sequenceMap = (Map<?, ?>) otherService.getSequence(paramMap);
		    reApplSeq = String.valueOf(sequenceMap.get("getSeq"));
		    if ("null".equals(reApplSeq)) {
		        reApplSeq = "";
		    }
		}
		
		Log.Debug(applSeqExist);
		Map<String, Object> uiInfo = (Map<String, Object>) approvalMgrService.getUiInfo(paramMap);
		if(uiInfo != null) {
			String uiInfoValue = String.valueOf(uiInfo.get("etcNote"));
			if(!"".equals(uiInfoValue) && !"null".equals(uiInfoValue)) {
				uiInfoValue = uiInfoValue.replace("\n", "<br>");
			}
			uiInfo.put("etcNote", uiInfoValue);
		}

		Map<?, ?> userInfo 	= (Map<?, ?>)approvalMgrService.getApprovalMgrUserInfoMap(paramMap);
		Map<?, ?> orgLvl 		= (Map<?, ?>)approvalMgrService.getApprovalMgrApplOrgLvl(paramMap);
		
		request.setAttribute("TEST21", searchApplSeq);
		mv.setViewName("hri/applyApproval/approvalMgr/approvalMgr");
		mv.addObject("searchApplSabun", searchApplSabun);
		mv.addObject("searchApplSeq", 	searchApplSeq);
		mv.addObject("searchApplCd", 	searchApplCd);
		mv.addObject("adminYn", 		adminYn);
		mv.addObject("authPg", 			authPg);
		mv.addObject("searchApplYmd", 	searchApplYmd);
		mv.addObject("searchSabun", 	searchSabun);
		mv.addObject("applSeqExist", 	applSeqExist);
		mv.addObject("uiInfo", 			uiInfo);
		mv.addObject("userInfo", 		userInfo);
		mv.addObject("orgLvl", 			orgLvl);
		mv.addObject("etc01", 			etc01);
		mv.addObject("etc02", 			etc02);
		mv.addObject("etc03", 			etc03);
		mv.addObject("reApplSeq", 			reApplSeq);
		return mv;
	}
	
	@RequestMapping(params="cmd=viewApprovalMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewApprovalMgrLayer(HttpSession session
										   , @RequestParam Map<String, Object> params
										   , HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		params.put("ssnSabun", session.getAttribute("ssnSabun"));
		params.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		params.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		String searchApplSabun  = (String) params.get("searchApplSabun");
		String searchApplSeq   	= (String) params.get("searchApplSeq");
		String searchApplCd   	= (String) params.get("searchApplCd");
		String adminYn			= (String) params.get("adminYn");
		String authPg   		= (String) params.get("authPg");
		String searchApplYmd   	= (String) params.get("searchApplYmd");
		String searchSabun  	= (String) params.get("searchSabun");
		String etc01  			= (String) params.get("etc01");
		String etc02  			= (String) params.get("etc02");
		String etc03  			= (String) params.get("etc03");
		String reUseYn          = (String) params.get("reUseYn");	//재사용여부
		String reApplSeq 		= "";		//재사용시 새로운 문서 SEQ
		String applSeqExist 	= "Y";
		
		if(StringUtils.isEmpty(searchApplSeq)) {
			params.put("seqId", "APPL");
			Map<?, ?> sequenceMap = (Map<?, ?>)otherService.getSequence(params);
			
			searchApplSeq = String.valueOf(sequenceMap.get("getSeq"));
			if("null".equals(searchApplSeq)) {
				searchApplSeq = "";
			}
			applSeqExist = "N"; 
			Log.Debug("APPL SEQ IS NOT EXISTS");
		} else {
			Log.Debug("SEARCH_APPL_SEQ IS {}", searchApplSeq);
		}
		
		if("Y".equals(reUseYn)) {
			params.put("seqId","APPL");
			Map<?, ?> sequenceMap = (Map<?, ?>) otherService.getSequence(params);
		    reApplSeq = String.valueOf(sequenceMap.get("getSeq"));
		    if ("null".equals(reApplSeq)) {
		        reApplSeq = "";
		    }
		}
		
		Map<String, Object> uiInfo = (Map<String, Object>) approvalMgrService.getUiInfo(params);
		if(uiInfo != null) {
			String uiInfoValue = String.valueOf(uiInfo.get("etcNote"));
			if(!"".equals(uiInfoValue) && !"null".equals(uiInfoValue)) {
				uiInfoValue = uiInfoValue.replace("\n", "<br>");
			}
			uiInfo.put("etcNote", uiInfoValue);

			// 결재선변경 보여주기 이면서 결재선레벨 보여주기 이고
			boolean isShowAppLineChangeBtn = true;
			if ("Y".equals(uiInfo.get("appPathYn")))
				isShowAppLineChangeBtn = true;
			if ("Y".equals(uiInfo.get("appPathYn")) && !"Y".equals(uiInfo.get("orgLevelYn")))
				isShowAppLineChangeBtn = false;
			if ("N".equals(uiInfo.get("agreeYn")) && "N".equals(uiInfo.get("recevYn")))
				isShowAppLineChangeBtn = false;
			uiInfo.put("showAppLineChangeBtn", isShowAppLineChangeBtn ? "Y" : "N");
		}
		
		Map<?, ?> userInfo 	= (Map<?, ?>) approvalMgrService.getApprovalMgrUserInfoMap(params);
		Map<?, ?> orgLvl 	= (Map<?, ?>) approvalMgrService.getApprovalMgrApplOrgLvl(params);
		
		request.setAttribute("TEST21", searchApplSeq);
		
		mv.setViewName("hri/applyApproval/approvalMgr/approvalMgrLayer");
		mv.addObject("searchApplSabun", searchApplSabun);
		mv.addObject("searchApplSeq", 	searchApplSeq);
		mv.addObject("searchApplCd", 	searchApplCd);
		mv.addObject("adminYn", 		adminYn);
		mv.addObject("authPg", 		authPg);
		mv.addObject("searchApplYmd", 	searchApplYmd);
		mv.addObject("searchSabun", 	searchSabun);
		mv.addObject("applSeqExist", 	applSeqExist);
		mv.addObject("uiInfo", 		uiInfo);
		mv.addObject("userInfo", 		userInfo);
		mv.addObject("orgLvl", 		orgLvl);
		mv.addObject("etc01", 			etc01);
		mv.addObject("etc02", 			etc02);
		mv.addObject("etc03", 			etc03);
		mv.addObject("reApplSeq", 		reApplSeq);

		Log.Debug("approvalMgrLayer =====");
		Log.Debug(mv.toString());

		return mv;
	}

	/**
	 * 근태신청 레이어 > 신청일자 이슈로 분기처리
	 * @param session
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrWorkdayLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewApprovalMgrWorkdayLayer(HttpSession session
			, @RequestParam Map<String, Object> params
			, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		params.put("ssnSabun", session.getAttribute("ssnSabun"));
		params.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		params.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		String searchApplSabun  = (String) params.get("searchApplSabun");
		String searchApplSeq   	= (String) params.get("searchApplSeq");
		String searchApplCd   	= (String) params.get("searchApplCd");
		String adminYn			= (String) params.get("adminYn");
		String authPg   		= (String) params.get("authPg");
		String searchApplYmd   	= (String) params.get("searchApplYmd");
		String searchSabun  	= (String) params.get("searchSabun");
		String etc01  			= (String) params.get("etc01");
		String etc02  			= (String) params.get("etc02");
		String etc03  			= (String) params.get("etc03");
		String reUseYn          = (String) params.get("reUseYn");	//재사용여부
		String reApplSeq 		= "";		//재사용시 새로운 문서 SEQ
		String applSeqExist 	= "Y";

		String startYmd			= String.valueOf(params.get("startYmd"));
		String endYmd			= String.valueOf(params.get("endYmd"));

		if(StringUtils.isEmpty(searchApplSeq)) {
			params.put("seqId", "APPL");
			searchApplSeq = ((Map<?, ?>) otherService.getSequence(params)).get("getSeq").toString();
			applSeqExist = "N";
			Log.Debug("APPL SEQ IS NOT EXISTS");
		} else {
			Log.Debug("SEARCH_APPL_SEQ IS {}", searchApplSeq);
		}

		if("Y".equals(reUseYn)) {
			params.put("seqId","APPL");
			reApplSeq = ((Map<?, ?>) otherService.getSequence(params)).get("getSeq").toString();
		}

		Map<String, Object> uiInfo = (Map<String, Object>) approvalMgrService.getUiInfo(params);
		if(uiInfo != null) {
			String uiInfoValue = String.valueOf(uiInfo.get("etcNote"));
			if(!"".equals(uiInfoValue) && !"null".equals(uiInfoValue)) {
				uiInfoValue = uiInfoValue.replace("\n", "<br>");
			}
			uiInfo.put("etcNote", uiInfoValue);
		}

		Map<?, ?> userInfo 	= (Map<?, ?>) approvalMgrService.getApprovalMgrUserInfoMap(params);
		Map<?, ?> orgLvl 	= (Map<?, ?>) approvalMgrService.getApprovalMgrApplOrgLvl(params);

		request.setAttribute("TEST21", searchApplSeq);

		mv.setViewName("hri/applyApproval/approvalMgr/approvalMgrLayer");
		mv.addObject("searchApplSabun", searchApplSabun);
		mv.addObject("searchApplSeq", 	searchApplSeq);
		mv.addObject("searchApplCd", 	searchApplCd);
		mv.addObject("adminYn", 		adminYn);
		mv.addObject("authPg", 		authPg);
		mv.addObject("searchApplYmd", 	searchApplYmd);
		mv.addObject("searchSabun", 	searchSabun);
		mv.addObject("applSeqExist", 	applSeqExist);
		mv.addObject("uiInfo", 		uiInfo);
		mv.addObject("userInfo", 		userInfo);
		mv.addObject("orgLvl", 		orgLvl);
		mv.addObject("etc01", 			etc01);
		mv.addObject("etc02", 			etc02);
		mv.addObject("etc03", 			etc03);
		mv.addObject("reApplSeq", 		reApplSeq);

		if(startYmd != null && !startYmd.isEmpty()) mv.addObject("startYmd", startYmd);
		if(endYmd != null && !endYmd.isEmpty()) mv.addObject("endYmd", endYmd);

		return mv;
	}

	/**
	 * WTM 근무스케줄신청 레이어 > 신청서번호 이슈로 분기처리
	 * @param session
	 * @param params
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewWtmApprovalMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewWtmApprovalMgrLayer(HttpSession session
			, @RequestParam Map<String, Object> params
			, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		params.put("ssnSabun", session.getAttribute("ssnSabun"));
		params.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		params.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));

		String searchApplSabun  = (String) params.get("searchApplSabun");
		String searchApplSeq   	= (String) params.get("searchApplSeq");
		String searchApplCd   	= (String) params.get("searchApplCd");
		String adminYn			= (String) params.get("adminYn");
		String authPg   		= (String) params.get("authPg");
		String searchApplYmd   	= (String) params.get("searchApplYmd");
		String searchSabun  	= (String) params.get("searchSabun");
		String etc01  			= (String) params.get("etc01");
		String etc02  			= (String) params.get("etc02");
		String etc03  			= (String) params.get("etc03");
		String reUseYn          = (String) params.get("reUseYn");	//재사용여부
		String reApplSeq 		= "";		//재사용시 새로운 문서 SEQ
		String applSeqExist 	= "N";

		if("Y".equals(reUseYn)) {
			params.put("seqId","APPL");
			reApplSeq = ((Map<?, ?>) otherService.getSequence(params)).get("getSeq").toString();
		}

		Map<String, Object> uiInfo = (Map<String, Object>) approvalMgrService.getUiInfo(params);
		if(uiInfo != null) {
			String uiInfoValue = String.valueOf(uiInfo.get("etcNote"));
			if(!"".equals(uiInfoValue) && !"null".equals(uiInfoValue)) {
				uiInfoValue = uiInfoValue.replace("\n", "<br>");
			}
			uiInfo.put("etcNote", uiInfoValue);
		}

		Map<?, ?> userInfo 	= (Map<?, ?>) approvalMgrService.getApprovalMgrUserInfoMap(params);
		Map<?, ?> orgLvl 	= (Map<?, ?>) approvalMgrService.getApprovalMgrApplOrgLvl(params);

		mv.setViewName("hri/applyApproval/approvalMgr/approvalMgrLayer");
		mv.addObject("searchApplSabun", searchApplSabun);
		mv.addObject("searchApplSeq", 	searchApplSeq);
		mv.addObject("searchApplCd", 	searchApplCd);
		mv.addObject("adminYn", 		adminYn);
		mv.addObject("authPg", 		authPg);
		mv.addObject("searchApplYmd", 	searchApplYmd);
		mv.addObject("searchSabun", 	searchSabun);
		mv.addObject("applSeqExist", 	applSeqExist);
		mv.addObject("uiInfo", 		uiInfo);
		mv.addObject("userInfo", 		userInfo);
		mv.addObject("orgLvl", 		orgLvl);
		mv.addObject("etc01", 			etc01);
		mv.addObject("etc02", 			etc02);
		mv.addObject("etc03", 			etc03);
		mv.addObject("reApplSeq", 		reApplSeq);

		return mv;
	}

	/**
	 * 신청서 결재 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTestIframe", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTestIframe(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("ApprovalMgrController.viewApprovalMgr");
		return "hri/applyApproval/approvalMgr/iframeTestPage";
	}


	/**
	 * 신청서 Web 인쇄 팝업
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrPrint", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewApprovalMgrPrint(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("ApprovalMgrController.viewApprovalMgr");
		return "hri/applyApproval/approvalMgrResult/approvalMgrPrint";
		       
	}
	
	/**
	 * 그룹웨어 인터페이스 화면 - 제주항공전용
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGwPage", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGwPage(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("ApprovalMgrController.viewGwPage");
		return "hri/gwPage";
	}

	/**
	 * R10052코드 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getR10052CodeList", method = RequestMethod.POST )
	public ModelAndView getR10052CodeCodeList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		List<?> result = approvalMgrService.getR10052CodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("codeList", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 신청자 정보 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrUserInfoMap", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrUserInfoMap(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		Map<?, ?> result = approvalMgrService.getApprovalMgrUserInfoMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 단계 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrLevelCodeList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrLevelCodeList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = approvalMgrService.getApprovalMgrLevelCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); 
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 내부결자선 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrInList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrInList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = approvalMgrService.getApprovalMgrInList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 참조자 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrReferUserList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrReferUserList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = approvalMgrService.getApprovalMgrReferUserList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 참조자 변경 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrReferUserChgList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrReferUserChgList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

		List<?> result = approvalMgrService.getApprovalMgrReferUserChgList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리 최초 신청 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrApplOrgLvl", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrApplOrgLvl(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		Map<?, ?> result = approvalMgrService.getApprovalMgrApplOrgLvl(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result.get("orgLvl") != null ? result.get("orgLvl").toString():null);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리 최초 신청 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrApplList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrApplList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		List<?> result = approvalMgrService.getApprovalMgrApplList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 관리 최초 신청 결재선 변경 리스트 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrApplChgList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrApplChgList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = approvalMgrService.getApprovalMgrApplChgList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리 최초 신청 임시저장 신청서 마스터 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrTHRI103", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrTHRI103(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		Map<?, ?> result = approvalMgrService.getApprovalMgrTHRI103(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 관리 최초 신청 임시저장 신청서 결재자 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrTHRI107", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrTHRI107(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = approvalMgrService.getApprovalMgrTHRI107(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 관리 최초 신청 임시저장 수신참조자 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrTHRI125", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrTHRI125(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = approvalMgrService.getApprovalMgrTHRI125(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 관리 최초 신청 결재선 변경 변경 팝업 화면
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrChgApplPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String approvalMgrChgApplPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.Debug("ApprovalMgrController.approvalMgrChgApplPopup");
		return "hri/applyApproval/approvalMgr/appPathRegPoup";
	}
	
	/**
	 * 신청서 결재 관리 최초 신청 결재선 변경 MODAL 화면
	 * 
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrChgLineLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewApprovalMgrChgLineLayer(HttpSession session,
			@RequestParam Map<String, Object> params) throws Exception {
		Log.Debug("ApprovalMgrController.approvalMgrChgApplPopup");
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("hri/applyApproval/approvalMgr/appPathRegLayer");
		mv.addObject("orgCd", params.get("orgCd"));
		mv.addObject("pathSeq", params.get("pathSeq"));
		mv.addObject("searchApplSabun", params.get("searchApplSabun"));
		return mv;
	}
	
	/**
	 * 신청서 결재 관리 저장
	 *
	 * @param session
	 * @param request
	 * @param params
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveApprovalMgr", method = RequestMethod.POST )
	public ModelAndView saveApprovalMgr(HttpSession session,
										HttpServletRequest request,
										@RequestParam Map<String, Object> params,
										@RequestBody Map<String, Object> body) throws Exception {
		Log.DebugStart();
		
		// BODY 에 있는 정보를 모두 PARAM에 넣는다.
		params.putAll(body);
		int cnt = 0;
		String message = "";
		
		String ssnEnterCd 	= session.getAttribute("ssnEnterCd").toString();
		String ssnSabun 	= session.getAttribute("ssnSabun").toString();
		
		params.put("ssnSabun", 	ssnSabun);
		params.put("ssnEnterCd", 	ssnEnterCd);
		params.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		List<Map<String, Object>> appls = (List<Map<String, Object>>) params.get("appls");
		List<Map<String, Object>> inusers = (List<Map<String, Object>>) params.get("inusers");
		List<Map<String, Object>> refers = (List<Map<String, Object>>) params.get("refers");
		
		String applSeq = (String) params.get("searchApplSeq");
		String referApplGubun = "11".equals((String) params.get("applStatusCd")) ? "0":"1"; 
		
		//ADD IN_USER 
		AtomicInteger index = new AtomicInteger();
		inusers = inusers.stream().map(o -> {
						o.put("agreeSeq", appls.size() + (index.getAndIncrement() + 1));
						return o;
					}).collect(Collectors.toList());
		appls.addAll(inusers);
		
		params.put("insertAgreeUser", appls);
		params.put("insertReferUser", refers);
		params.put("referApplGubun", referApplGubun);
		params.put("applSeq", applSeq);

		int code = -1;
		String rm = "11".equals((String) params.get("applStatusCd")) ? "임시저장":"신청";
		try{
			cnt = approvalMgrService.saveApprovalMgr(params);
			if (cnt < 1) {
				message= rm + "된 내용이 없습니다.";
				code = 0;
				return makeReturnValue(cnt, message, code);
			}
			
			message= rm + " 되었습니다.";
			code = 1;
			
			approvalMgrService.sendNotification(session, params, "notification");
			approvalMgrService.sendAppPush(params, "신규 결재 건이 있습니다.");

//			// 결재후처리 작업 (P_HRI_AFTER_PROC_EXEC 프로시저 대체)
//			int aftCode = approvalAfterJob(params);
//			if(aftCode < 0)
//				message = "후처리작업에 실패하였습니다.";

//			commonMailController.callMailApp(request, params);
		} catch(Exception e){
			e.printStackTrace();
			logger.error(e.getMessage());
			cnt=-1;
			message= rm + " 실패하였습니다.";
			return makeReturnValue(cnt, message, code);
		}

		return makeReturnValue(cnt, message, code);
	}

	private boolean useNotification(HttpSession session) {
		String ssnNotificationUseYn = StringUtil.nvl((String) session.getAttribute("ssnNotificationUseYn"), "N");
		return "Y".equals(ssnNotificationUseYn);
	}

	private ModelAndView makeReturnValue(int cnt, String message, int code) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("cnt", cnt);
		mv.addObject("Message", message);
		mv.addObject("Code", code);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리 상세 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String approvalMgrDetailPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("ApprovalMgrController.approvalMgrDetailPopup");
		return "hri/applicationBasis/approvalMgr/approvalMgrDetailPopup";
	}

	/**
	 * 신청서 결재 관리 결재자, 참조자 수정  팝업 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String approvalMgrPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("ApprovalMgrController.approvalMgrPopup");
		return "hri/applicationBasis/approvalMgr/approvalMgrPopup";
	}

	/**
	 * 신청서 결재 관리 팝업 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrPopupList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrPopupList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = approvalMgrService.getApprovalMgrPopupList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 대결자 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrDeputyUserChgList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrDeputyUserChgList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String agreeSabun = paramMap.get("agreeSabun").toString().replace(",", "','");
		paramMap.put("agreeSabun","'"+agreeSabun+"'");
		List<?> result = approvalMgrService.getApprovalMgrDeputyUserChgList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
}