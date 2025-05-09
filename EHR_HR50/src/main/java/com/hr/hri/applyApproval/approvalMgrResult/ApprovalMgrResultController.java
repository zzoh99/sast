package com.hr.hri.applyApproval.approvalMgrResult;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
import com.hr.common.notification.NotificationService;
import com.hr.common.other.OtherService;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
import com.hr.hri.applyApproval.approvalMgr.ApprovalMgrService;;

/**
 * 신청서 결재 관리
 *
 * @author ParkMoohun
 */
@Controller
@SuppressWarnings("unchecked")
@RequestMapping(value="/ApprovalMgrResult.do", method=RequestMethod.POST )
public class ApprovalMgrResultController {

	@Inject
	@Named("ApprovalMgrResultService")
	private ApprovalMgrResultService approvalMgrResultService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("ApprovalMgrService")
	private ApprovalMgrService approvalMgrService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;
	
	@Inject
	@Named("NotificationService")
	private NotificationService notificationService;

	/**
	 * 신청서 결재 관리 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrResult", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewApprovalMgrResult(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();

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
		String gubun			= "";
		Map<String, Object> uiInfo 	= (Map<String, Object>) approvalMgrResultService.getUiInfo(paramMap);
		uiInfo.put("etcNote", uiInfo.get("etcNote") == null ? null : uiInfo.get("etcNote").toString().replace("\n", "<br>"));

		Map<?, ?> userInfo 			= (Map<?, ?>)approvalMgrResultService.getApprovalMgrResultUserInfoMap(paramMap);
		Map<?, ?> applMasterInfo 	= (Map<?, ?>)approvalMgrResultService.getApprovalMgrResultTHRI103(paramMap);
		Map<?, ?> cancelButton 		= (Map<?, ?>)approvalMgrResultService.getCancelButtonMap(paramMap);

		//searchApplSabun, searchApplYmd이 빈 값일 경우가 있어 신청서마스터에서 조회한 신청 정보를 넣어줌 2020.10.19
		if(applMasterInfo != null) {
			searchApplCd 		= String.valueOf(applMasterInfo.get("applCd"));
			searchApplYmd   	= String.valueOf(applMasterInfo.get("applYmd"));
			searchApplSabun 	= String.valueOf(applMasterInfo.get("applSabun"));
		}
		paramMap.put("searchApplSabun", searchApplSabun );
		
		//신청자정보 추가 2016.09.30
		Map<?, ?> userApplInfo		= (Map<?, ?>)approvalMgrService.getApprovalMgrUserInfoMap(paramMap);

		/* 2018-11-14 사용안함
		//차민주/류시웅 하드코딩  요청사항
		//경조에서는 수정할 결재함에서 수정할 수 있어야함
		//2013.09.13 AM 10:30
		Map<?, ?> agreeInfo 				= (Map)approvalMgrResultService.getAgreeSabun(paramMap);
		if(null != agreeInfo && agreeInfo.get("applTypeCd").equals("40")){
			adminYn = "Y";
		}
		*/
		
		//현 결재자와 세션사번이 같은지체크 2019.12.17 jylee
		String applYn       = "N";
		String ssnSabun 	= session.getAttribute("ssnSabun").toString();
		Map<?, ?> agreeInfo 		= (Map<?, ?>)approvalMgrResultService.getAgreeSabun(paramMap);
		if(null != agreeInfo && agreeInfo.get("agreeSabun").equals(ssnSabun)){
			applYn = "Y";
		}

		// 수신 담당자 일경우 gubun 값 추가 (0:본인,1:결재,3:수신)
		gubun = (String)approvalMgrResultService.getApprovalMgrThri107Gubun(paramMap);

		mv.setViewName("hri/applyApproval/approvalMgrResult/approvalMgrResult");
		mv.addObject("searchApplSabun", searchApplSabun);
		mv.addObject("searchApplSeq", 	searchApplSeq);
		mv.addObject("searchApplCd", 	searchApplCd);
		mv.addObject("adminYn", 		adminYn);
		mv.addObject("authPg", 			authPg);
		mv.addObject("searchApplYmd", 	searchApplYmd);
		mv.addObject("searchSabun", 	searchSabun);
		mv.addObject("uiInfo", 			uiInfo);
		mv.addObject("userInfo", 		userInfo);
		mv.addObject("userApplInfo",	userApplInfo); // 2016.09.30 추가
		mv.addObject("applMasterInfo", 	applMasterInfo);
		mv.addObject("etc01", 			etc01);
		mv.addObject("etc02", 			etc02);
		mv.addObject("etc03", 			etc03);
		mv.addObject("cancelButton", 	cancelButton);
		mv.addObject("gubun", 	gubun);
		mv.addObject("applYn", 	        applYn);  //2019.12.17 jylee
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=viewApprovalMgrResultLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewApprovalMgrResultLayer(HttpSession session
											, @RequestParam Map<String, Object> params
											, HttpServletRequest request) throws Exception {
		Log.DebugStart();
		ModelAndView mv = new ModelAndView();
		
		String searchApplSabun  = params.get("searchApplSabun").toString();
		String searchApplSeq   	= params.get("searchApplSeq").toString();
		String searchApplCd   	= params.get("searchApplCd").toString();
		String adminYn			= params.get("adminYn").toString();
		String authPg   		= params.get("authPg").toString();
		String searchApplYmd   	= params.get("searchApplYmd").toString();
		String searchSabun  	= params.get("searchSabun").toString();
		String etc01  			= (String) params.get("etc01");
		String etc02  			= (String) params.get("etc02");
		String etc03  			= (String) params.get("etc03");
		String gubun			= "";

		String ssnSabun = StringUtil.stringValueOf(session.getAttribute("ssnSabun"));

		Map<String, Object> uiInfo 	= (Map<String, Object>) approvalMgrResultService.getUiInfo(params);
		uiInfo.put("etcNote", uiInfo.get("etcNote") == null ? null : uiInfo.get("etcNote").toString().replace("\n", "<br>"));
		Map<?, ?> userInfo = (Map<?, ?>)approvalMgrResultService.getApprovalMgrResultUserInfoMap(params);
		Map<?, ?> applMasterInfo = (Map<?, ?>)approvalMgrResultService.getApprovalMgrResultTHRI103(params);

		params.put("ssnOrgCd", StringUtil.stringValueOf(session.getAttribute("ssnOrgCd")));
		Map<String, Object> cancelButton = (Map<String, Object>) approvalMgrResultService.getCancelButtonMap(params);
		if ("Y".equals(uiInfo.get("reUseYn")) && ssnSabun.equals(applMasterInfo.get("applSabun"))) {
			cancelButton.put("visibleReuseBtn", "Y");
		}
		
		if(applMasterInfo != null) {
			searchApplCd = String.valueOf(applMasterInfo.get("applCd"));
			searchApplYmd = String.valueOf(applMasterInfo.get("applYmd"));
			searchApplSabun = String.valueOf(applMasterInfo.get("applSabun"));
		}
		params.put("searchApplSabun", searchApplSabun );
		Map<?, ?> userApplInfo = (Map<?, ?>)approvalMgrService.getApprovalMgrUserInfoMap(params);
		
		String applYn = "N";
		Map<?, ?> agreeInfo = (Map<?, ?>)approvalMgrResultService.getAgreeSabun(params);
		if(null != agreeInfo && ssnSabun.equals(agreeInfo.get("agreeSabun"))){
			applYn = "Y";
		}
		
		gubun = (String)approvalMgrResultService.getApprovalMgrThri107Gubun(params);
		
		mv.setViewName("hri/applyApproval/approvalMgrResult/approvalMgrResultLayer");
		mv.addObject("searchApplSabun", searchApplSabun);
		mv.addObject("searchApplSeq", 	searchApplSeq);
		mv.addObject("searchApplCd", 	searchApplCd);
		mv.addObject("adminYn", 		adminYn);
		mv.addObject("authPg", 			authPg);
		mv.addObject("searchApplYmd", 	searchApplYmd);
		mv.addObject("searchSabun", 	searchSabun);
		mv.addObject("uiInfo", 			uiInfo);
		mv.addObject("userInfo", 		userInfo);
		mv.addObject("userApplInfo",	userApplInfo); // 2016.09.30 추가
		mv.addObject("applMasterInfo", 	applMasterInfo);
		mv.addObject("etc01", 			etc01);
		mv.addObject("etc02", 			etc02);
		mv.addObject("etc03", 			etc03);
		mv.addObject("cancelButton", 	cancelButton);
		mv.addObject("gubun", 	gubun);
		mv.addObject("applYn", 	        applYn);  //2019.12.17 jylee
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
		Log.DebugStart();
		return "hri/applyApproval/approvalMgrResult/iframeTestPage";
	}
	
	/**
	 * 신청서 Web 인쇄 팝업
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrResultPrint", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewApprovalMgrResultPrint(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		return "hri/applyApproval/approvalMgrResult/approvalMgrResultPrint";
		       
	}

	@RequestMapping(params="cmd=viewApprovalMgrResultPrintLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewApprovalMgrResultPrintLayer(HttpSession session,
											 @RequestParam Map<String, Object> paramMap,
											 HttpServletRequest request) throws Exception {
		return "hri/applyApproval/approvalMgrResult/approvalMgrResultPrintLayer";

	}

	/**
	 * 신청서 결재 신청자 정보 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrResultUserInfoMap", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultUserInfoMap(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<?, ?> result = approvalMgrResultService.getApprovalMgrResultUserInfoMap(paramMap);
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
	@RequestMapping(params="cmd=getApprovalMgrResultLevelCodeList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultLevelCodeList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = approvalMgrResultService.getApprovalMgrResultLevelCodeList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
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
	@RequestMapping(params="cmd=getApprovalMgrResultInList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultInList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = approvalMgrResultService.getApprovalMgrResultInList(paramMap);
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
	@RequestMapping(params="cmd=getApprovalMgrResultReferUserList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultReferUserList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = approvalMgrResultService.getApprovalMgrResultReferUserList(paramMap);
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
	@RequestMapping(params="cmd=getApprovalMgrResultReferUserChgList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultReferUserChgList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = approvalMgrResultService.getApprovalMgrResultReferUserChgList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리  리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrResultApplOrgLvl", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultApplOrgLvl(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<?, ?> result = approvalMgrResultService.getApprovalMgrResultApplOrgLvl(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); 
		mv.addObject("DATA", result.get("orgLvl") != null ? result.get("orgLvl").toString() : null);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리  리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrResultApplList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultApplList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = approvalMgrResultService.getApprovalMgrResultApplList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 관리  결재선 변경 리스트 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrResultApplChgList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultApplChgList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = approvalMgrResultService.getApprovalMgrResultApplChgList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리  임시저장 신청서 마스터 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrResultTHRI103", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultTHRI103(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		Map<?, ?> result = approvalMgrResultService.getApprovalMgrResultTHRI103(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 관리  임시저장 신청서 결재자 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrResultTHRI107", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultTHRI107(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = approvalMgrResultService.getApprovalMgrResultTHRI107(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 관리  임시저장 수신참조자 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrResultTHRI125", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultTHRI125(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = approvalMgrResultService.getApprovalMgrResultTHRI125(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 신청서 결재 관리 신청 결재선 변경 팝업 화면
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrResultChgApplPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String approvalMgrResultChgApplPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return "hri/applyApproval/approvalMgrResult/appPathRegPoup";
	}
	/**
	 * 신청서 결재 관리 참조자 변경 팝업 화면
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrResultChgReferPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String approvalMgrResultChgReferPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		return "hri/applyApproval/approvalMgrResult/appReferRegPopup";
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
	@RequestMapping(params="cmd=saveApprovalMgrResult", method = RequestMethod.POST )
	public ModelAndView saveApprovalMgrResult(HttpSession session,
											  HttpServletRequest request,
											  @RequestParam Map<String, Object> params,
											  @RequestBody Map<String, Object> body) throws Exception {
		Log.DebugStart();

		// BODY 에 있는 정보를 모두 PARAM에 넣는다.
		params.putAll(body);
		int cnt = 0;
		String message = "";

		String applSave			= params.get("applSave").toString();
		String referSave		= params.get("referSave").toString();
		int	   cAgreeSeq		= Integer.parseInt(params.get("agreeSeq").toString());

		List<Map<String, Object>> appls = (List<Map<String, Object>>) params.get("appls");
		List<Map<String, Object>> inusers = (List<Map<String, Object>>) params.get("inusers");
		List<Map<String, Object>> refers = (List<Map<String, Object>>) params.get("refers");

		//전체 agreeSeq 보다 적은 것만 넣도록 한다.
		List<Map<String, Object>> users = appls.stream()
				.filter(m -> Integer.parseInt(m.get("agreeSeq").toString()) < cAgreeSeq)
				.collect(Collectors.toList());

		//ADD IN_USER
		AtomicInteger index = new AtomicInteger();
		inusers = inusers.stream().map(o -> {
			o.put("agreeSeq", users.size() + (index.getAndIncrement() + 1));
			return o;
		}).collect(Collectors.toList());
		users.addAll(inusers);

		params.put("insertReferUser", refers);
		params.put("insertAgreeUser", users);

		try{
			cnt = approvalMgrResultService.saveApprovalMgrResult(applSave, referSave, params);
			if (cnt == 0) {
				message = "저장된 내용이 없습니다.";
				return makeReturnValue(cnt, message);
			}

			message="저장되었습니다.";

			Map<String, Object> applInfo 	= (Map<String, Object>)approvalMgrResultService.getApprovalMgrResultTHRI103(params);
			String applStatusCd = String.valueOf(applInfo.get("applStatusCd"));
			String applStatusNm = String.valueOf(applInfo.get("applStatusCdNm"));
			String pushMessage = "신규 결재 건이 있습니다.";
			if (applStatusCd.equals("23") || applStatusCd.equals("33") || applStatusCd.equals("99")) {
				pushMessage = applStatusNm + " 되었습니다.";
			}
			approvalMgrService.sendNotification(session, params, "notification");
			approvalMgrService.sendAppPush(params, pushMessage);

		} catch(Exception e) {
			Log.Debug(e.getMessage());
			cnt=-1;
			message="저장 실패하였습니다.";
			return makeReturnValue(cnt, message);
		}

		return makeReturnValue(cnt, message);
	}

	private boolean useNotification(HttpSession session) {
		String ssnNotificationUseYn = StringUtil.nvl((String) session.getAttribute("ssnNotificationUseYn"), "N");
		return "Y".equals(ssnNotificationUseYn);
	}

	private ModelAndView makeReturnValue(int cnt, String message) {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("cnt", cnt);
		mv.addObject("Message", message);
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
	@RequestMapping(params="cmd=viewApprovalMgrResultDetailPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String approvalMgrResultDetailPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		return "hri/applicationBasis/approvalMgrResult/approvalMgrResultDetailPopup";
	}

	/**
	 * 신청서 결재 관리 결재자, 참조자 수정  팝업 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrResultPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String approvalMgrResultPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		return "hri/applicationBasis/approvalMgrResult/approvalMgrResultPopup";
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
	@RequestMapping(params="cmd=getApprovalMgrResultPopupList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultPopupList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		List<?> result = approvalMgrResultService.getApprovalMgrResultPopupList(paramMap);
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
	@RequestMapping(params="cmd=getApprovalMgrResultDeputyUserChgList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultDeputyUserChgList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		String agreeSabun = paramMap.get("agreeSabun").toString().replaceAll(",", "','");
		paramMap.put("agreeSabun","'"+agreeSabun+"'");
		List<?> result = approvalMgrResultService.getApprovalMgrResultDeputyUserChgList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인 신청 결재 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateStatusCd", method = RequestMethod.POST )
	public ModelAndView updateStatusCd(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("agreeUserMemo","");

		String agreeGubun = (paramMap.containsKey("agreeGubun")) ? paramMap.get("agreeGubun").toString() : "";

		if ("".equals(agreeGubun)) {
			String statusCd = (paramMap.containsKey("statusCd")) ? paramMap.get("statusCd").toString() : "";
			if(statusCd.equals("23") || statusCd.equals("33") || statusCd.equals("43") ){
				agreeGubun = "0";
			}else  agreeGubun = "1";
			paramMap.put("agreeGubun",agreeGubun);
		}
		String message 		= "";
		int cnt = 0;
		try{Log.Debug("paramMap<?, ?> : " + paramMap);
			cnt = approvalMgrResultService.updateStatusCd(paramMap);
			if (cnt > 0) {
				message="저장되었습니다.";
				/*== 알림 push 시작 ==*/
				String ssnNotificationUseYn = StringUtil.nvl((String) session.getAttribute("ssnNotificationUseYn"), "N");
				if( "Y".equals(ssnNotificationUseYn) ) {
					approvalMgrService.sendNotification(session, paramMap, "notification");
//					List<?> pushList = approvalMgrResultService.getApprovalNotiSabun(paramMap);
//					for(Object o : pushList) {
//						Map<?, ?> pushMap = (Map<?, ?>) o;
//						if (pushMap != null) {
//							this.notificationService.notify(enterCd, (String) pushMap.get("sabun"), "notification", pushMap.get("content"));
//						}
//					}
				}
				/*== 알림 push 끝 ==*/	
			} else {
				message="저장된 내용이 없습니다.";
			}
		}catch(Exception e){ e.printStackTrace(); cnt=-1; message="저장 실패하였습니다."; }
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");  mv.addObject("cnt", 		cnt); mv.addObject("Message", 	message);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 개인 신청 결재 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=updateCancelStatusCd", method = RequestMethod.POST )
	public ModelAndView updateCancelStatusCd(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		String message 		= "";
		int cnt = 0;
		try{ cnt = approvalMgrResultService.updateCancelStatusCd(paramMap);
			if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");  mv.addObject("cnt", 		cnt); mv.addObject("Message", 	message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 개인 신청 결재 참조자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertApprovalMgrResultReferAddUser", method = RequestMethod.POST )
	public ModelAndView insertApprovalMgrResultReferAddUser(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

		String message = "";
		int cnt = 0;
		try{ cnt = approvalMgrResultService.insertApprovalMgrResultReferAddUser(convertMap);
			if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
		}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");  mv.addObject("Code", 		cnt); mv.addObject("Message", 	message);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리  임시저장 신청서 결재자 조회
	 *
	 * @param session
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getApprovalMgrResultReferAllList", method = RequestMethod.POST )
	public ModelAndView getApprovalMgrResultReferAllList(HttpSession session,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		List<?> result = approvalMgrResultService.getApprovalMgrResultReferAllList(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("DATA", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 신청서 결재 관리 결재 의견  팝업 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewApprovalMgrResultCommentPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String approvalMgrResultCommentPopup(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		return "hri/applyApproval/approvalMgrResult/appCommentPopup";
	}

	/**
	 * 의견댓글 저장하기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveComment", method = RequestMethod.POST )
	public ModelAndView saveComment(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {

		// comment 시작

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = approvalMgrResultService.saveComment(paramMap);
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("code", resultCnt);
		mv.addObject("message", message);
		mv.addObject("map", paramMap);
		Log.DebugEnd();
		return mv;
	}

	
	/**
	 * 의견댓글 리스트 가져오기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getCommentList", method = RequestMethod.POST )
	public ModelAndView getCommentList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {

		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = approvalMgrResultService.getCommentList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 의견댓글 삭제하기
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=delComment", method = RequestMethod.POST )
	public ModelAndView delComment(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {

		// comment 시작

		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		String message = "";
		int resultCnt = -1;

		try{
			resultCnt = approvalMgrResultService.delComment(paramMap);
		}catch(Exception e){
			resultCnt = -1;
			message="저장에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("code", resultCnt);
		mv.addObject("message", message);
		mv.addObject("map", paramMap);
		Log.DebugEnd();
		return mv;
	}
}