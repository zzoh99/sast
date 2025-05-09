package com.hr.sys.mail.mailSmsMgr;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.interfaceIf.stf.RecruitFtpUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * MailSmsMgr Controller
 *
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/MailSmsMgr.do", method=RequestMethod.POST )
public class MailSmsMgrController {
	
	@Value("${stf.url}") private String STF_URL;
	
	/**
	 * 메일및SMS전송(평가) 서비스
	 */
	@Inject
	@Named("MailSmsMgrService")
	private MailSmsMgrService mailSmsMgrService;
	
	/**
	 * 메일및SMS전송(평가) View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMailSmsMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewMailSmsMgr(
		HttpSession session,  HttpServletRequest request,
		@RequestParam Map<String, Object> paramMap ) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("sys/mail/mailSmsMgr/mailSmsMgr");
		mv.addObject("map", paramMap);
		return mv;
	}
	
	
	/**
	 * 메일및SMS전송(평가) - 발송ID별 상세내용 등록수정 팝업  - 메일 
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMailSmsMgrPopupMail", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewMailSmsMgrPopupMail(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String popupPageFlag = paramMap.get("popupPageFlag").toString();
		String searchBizCd = paramMap.get("searchBizCd").toString();
		
		String hrPort = Integer.toString(request.getServerPort());
		if( hrPort.equals("80") || hrPort.equals("443") ){
			hrPort = "";
		}else{
			hrPort = ":" + hrPort;
		}
		String hrDomain = request.getScheme()+"://"+ request.getServerName()+ hrPort;
		String recDomain = STF_URL;
		
		if( searchBizCd.equals("PAP") ){
			recDomain = hrDomain;
		}
		
		paramMap.put("hrDomain",	hrDomain);
		paramMap.put("recDomain",	recDomain);
		
		Map<?, ?> map = mailSmsMgrService.getMailSmsMgrMap("getMailSmsMgrPopupMap"+popupPageFlag, paramMap);
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> editorMap = new HashMap<String, Object>();
		editorMap.put("formNm",    "dataForm");
		editorMap.put("contentNm", "contents");
		mv.addObject("editor", editorMap);
		
		mv.setViewName("sys/mail/mailSmsMgr/mailSmsMgrPopupMail");
		
		mv.addObject("map", map);
		mv.addObject("popupPageFlag", popupPageFlag);
		
		mv.addObject("hrDomain",	hrDomain);
		mv.addObject("recDomain",	recDomain);
		
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 메일및SMS전송(평가) - 발송ID별 상세내용 등록수정 팝업  - SMS 
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewMailSmsMgrPopupSms", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewMailSmsMgrPopupSms(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		String popupPageFlag = paramMap.get("popupPageFlag").toString();
		
		Map<?, ?> map = mailSmsMgrService.getMailSmsMgrMap("getMailSmsMgrPopupMap"+popupPageFlag, paramMap);
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> editorMap = new HashMap<String, Object>();
		editorMap.put("formNm",    "dataForm");
		editorMap.put("contentNm", "contents");
		mv.addObject("editor", editorMap);
		
		mv.setViewName("sys/mail/mailSmsMgr/mailSmsMgrPopupSms");
		mv.addObject("map", map);
		mv.addObject("popupPageFlag", popupPageFlag);
		
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 메일및SMS전송(평가) - 발송ID 설정 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMailSmsMgr1", method = RequestMethod.POST )
	public ModelAndView saveMailSmsMgr1(
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
			resultCnt = mailSmsMgrService.saveMailSmsMgr1(convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패 하였습니다.";
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
	 * 메일및SMS전송(평가) - 발송ID - 대상자생성 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcMailSmsMgr1", method = RequestMethod.POST )
	public ModelAndView prcMailSmsMgr1(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 발송완료인 경우, 메시지처리
		Map<?, ?> checkSendYnMap = mailSmsMgrService.getMailSmsMgrMap("getMailSmsMgrPopupMap1", paramMap);
		String sendYn = checkSendYnMap.get("sendYn") != null ? checkSendYnMap.get("sendYn").toString():"N";
		if (sendYn != null && "Y".equals(sendYn)) {
			resultMap.put("Message", "이미 발송이 완료되어 대상자를 생성할 수 없습니다.");
		} else {
			String searchBizCd = convertFirstUpperCase(paramMap.get("searchBizCd").toString());
			String procName    = "prcMailSmsMgr"+ searchBizCd +"1";
			
			Map<?,?> map  = mailSmsMgrService.prcMailSmsMgr(procName, paramMap);
			
			Log.Debug("obj : "+map);
			Log.Debug("sqlCode : "+map.get("sqlCode"));
			Log.Debug("sqlErrm : "+map.get("sqlErrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			} else {
				resultMap.put("Message", "저장되었습니다.");
			}
		}
		
		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄 
		// comment 종료
		Log.DebugEnd();
		return mv;
	}		
	
	/**
	 * 메일및SMS전송(평가) - 발송ID - 발송내용 일괄생성 프로시저
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=prcMailSmsMgr2", method = RequestMethod.POST )
	public ModelAndView prcMailSmsMgr2(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 발송완료인 경우, 메시지처리
		Map<?, ?> checkSendYnMap = mailSmsMgrService.getMailSmsMgrMap("getMailSmsMgrPopupMap1", paramMap);
		String sendYn = checkSendYnMap.get("sendYn") != null ? checkSendYnMap.get("sendYn").toString():"N";
		if (sendYn != null && "Y".equals(sendYn)) {
			resultMap.put("Message", "이미 발송이 완료되어 발송내용을 설정할 수 없습니다.");
		} else {
			String searchBizCd = convertFirstUpperCase(paramMap.get("searchBizCd").toString());
			String procName    = "prcMailSmsMgr"+ searchBizCd +"2";
			
			Map<?,?> map  = mailSmsMgrService.prcMailSmsMgr(procName, paramMap);
			
			Log.Debug("obj : "+map);
			Log.Debug("sqlCode : "+map.get("sqlCode"));
			Log.Debug("sqlErrm : "+map.get("sqlErrm"));
			
			if (map.get("sqlCode") != null) {
				resultMap.put("Code", map.get("sqlCode").toString());
			}
			if (map.get("sqlErrm") != null) {
				resultMap.put("Message", map.get("sqlErrm").toString());
			} else {
				resultMap.put("Message", "저장되었습니다.");
			}
		}
		
		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		// return 형태 설정
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		// 그리드에 맵핑 되는 데이터 이면 DATA에 담아서 보냄 
		// comment 종료
		Log.DebugEnd();
		return mv;
	}		
	
	
	/**
	 * 메일및SMS전송(평가) - 발송ID - 발송 set
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMailSmsMgrSendFlag", method = RequestMethod.POST )
	public ModelAndView saveMailSmsMgrSendFlag(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
	
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		//String reload = "N";
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		// 발송완료인 경우, 메시지처리
		Map<?, ?> checkSendYnMap = mailSmsMgrService.getMailSmsMgrMap("getMailSmsMgrPopupMap1", paramMap);
		String sendYn = "";
		String contentsFlag = "";
		String receUserFlag = "";
		if(checkSendYnMap != null) {
			sendYn       = (String) checkSendYnMap.get("sendYn");
			contentsFlag = (String) checkSendYnMap.get("contentsFlag");
			receUserFlag = (String) checkSendYnMap.get("receUserFlag");
			
			if (sendYn       == null) sendYn       = "N";
			if (contentsFlag == null) contentsFlag = "";
			if (receUserFlag == null) receUserFlag = "";
		}
		
		if ("Y".equals(sendYn)) {
			message = "이미 발송이 완료되었습니다.";
		} else if ("N".equals(contentsFlag)) {
			message = "발송내용미설정자가 존재 합니다. 발송내용설정 후 발송 가능합니다.";
		} else if ("N".equals(receUserFlag)) {
			message = "발송할 대상자가 없습니다. 대상자 등록 후 발송 가능합니다.";
		} else {
			try{
				resultCnt  = mailSmsMgrService.updateMailSmsMgr("updateMailSmsMgrSendFlag1", paramMap);
				resultCnt += mailSmsMgrService.updateMailSmsMgr("updateMailSmsMgrSendFlag2", paramMap);
				if(resultCnt > 0){
					message = "저장되었습니다."; 
					//reload  = "Y";
					
					//저장 완료 후 이미지파일FTP업로드
					String srchKeyVal = "'" + (String)session.getAttribute("ssnEnterCd") + "" + paramMap.get("searchSendSeq") + "'";
					RecruitFtpUtil.imgFileFtpUpload("THRI108", "CONTENTS", "ENTER_CD||REF_SEQ", srchKeyVal, RecruitFtpUtil.TYPE_EHR);
				} else{ message="저장 된 내용이 없습니다."; }
			}catch(Exception e){
				resultCnt = -1; message="저장에 실패 하였습니다.";
			}
		}
		
		if (resultCnt > -1 ) {
			resultMap.put("Code", null);
		}
		resultMap.put("Message", message);

		
		// ModelAndView 생성
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 메일및SMS전송(평가) - 발송ID별 상세내용 팝업 저장 
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMailSmsMgrPopup", method = RequestMethod.POST )
	public ModelAndView saveMailSmsMgrPopup(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
	
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		String reload = "N";
		
		String popupPageFlag = paramMap.get("popupPageFlag").toString();
		
		try{
			resultCnt = mailSmsMgrService.updateMailSmsMgrClob("updateMailSmsMgrPopup"+popupPageFlag, paramMap);
			if(resultCnt > 0){
				message = "저장되었습니다."; 
				reload  = "Y";
			} else{ message="저장 된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패 하였습니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		resultMap.put("reload", reload);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
	
	// 생성 / 설정  == 프로시저호출
	// 발송 ==> update
	
	/**
	 * 메일및SMS전송(평가) - 대상자 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMailSmsMgr2", method = RequestMethod.POST )
	public ModelAndView saveMailSmsMgr2(
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
			resultCnt = mailSmsMgrService.saveMailSmsMgr("MailSmsMgr2", convertMap);
			if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패 하였습니다.";
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
	 * 메일및SMS전송(평가) - 대상자별 상세내용 팝업 저장 
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveMailSmsMgrPopup2", method = RequestMethod.POST )
	public ModelAndView saveMailSmsMgrPopup2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
	
		paramMap.put("ssnSabun",	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",	session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		String reload = "N";
		
		try{
			resultCnt = mailSmsMgrService.updateMailSmsMgrClob("updateMailSmsMgrPopup2", paramMap);
			if(resultCnt > 0){
				message = "저장되었습니다."; 
				reload  = "Y";
			} else{ message="저장 된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="저장에 실패 하였습니다.";
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("Code", resultCnt);
		resultMap.put("Message", message);
		resultMap.put("reload", reload);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	public String convertFirstUpperCase(String str){
		StringBuilder sbuf = new StringBuilder(str.toLowerCase());
		sbuf.deleteCharAt(0);
		sbuf.insert(0, str.substring(0, 1).toUpperCase());
		return sbuf.toString();
	}

}
