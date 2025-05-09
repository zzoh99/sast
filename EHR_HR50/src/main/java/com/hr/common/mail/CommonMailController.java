package com.hr.common.mail;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.nhncorp.lucy.security.xss.LucyXssFilter;
import com.nhncorp.lucy.security.xss.XssPreventer;
import com.nhncorp.lucy.security.xss.XssSaxFilter;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import com.hr.common.util.StringUtil;
import com.hr.common.util.api.ApiUtil;
import com.hr.common.util.mail.MailUtil;
import com.hr.common.util.mail.SmtpMailUtil;
import com.hr.cpn.payCalculate.monPayMailCre.MonPayMailCreService;
import com.hr.cpn.personalPay.perPayPartiPopSta.PerPayPartiPopStaService;
import com.hr.sys.other.noticeTemplateMgr.NoticeCommonConstants;
import com.hr.sys.other.noticeTemplateMgr.NoticeTemplateMgrService;

/**
 * 메일발송 처리 공통 컨트롤러
 *
 */
@Controller
@RequestMapping(value="/Send.do", method=RequestMethod.POST )
public class CommonMailController {

	@Inject
	@Named("CommonMailService")
	private CommonMailService commonMailService;

	@Inject
	@Named("OtherService")
	private OtherService otherService;

	@Value("${mail.server}")
	private String mailServer;
	@Value("${mail.user}")
	private String mailUser;
	@Value("${mail.passwd}")
	private String mailPasswd;
	@Value("${mail.tester}")
	private String mailTester;
	@Value("${mail.sender}")
	private String mailSender;

	@Value("${sms.number}")
	private String smsNumber;
	@Value("${sms.tester}")
	private String smsTester;
	
	/** 알림서식관리 Service */
	@Inject
	@Named("NoticeTemplateMgrService")
	private NoticeTemplateMgrService noticeTemplateMgrService;

	/**
	 * 월급여메일발송 서비스
	 */
	@Inject
	@Named("MonPayMailCreService")
	private MonPayMailCreService monPayMailCreService;

	/**
	 * 월급여메일발송 - 2017.02.03
	 */
	@Inject
	@Named("PerPayPartiPopStaService")
	private PerPayPartiPopStaService perPayPartiPopStaService;

	private static String savedMailSeq;

	/**
	 * 메일 구문가져오기
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getMailContent", method = RequestMethod.POST )
	public ModelAndView mailContent(@RequestParam Map<String, Object> paramMap) throws Exception {
		// Session 이 없을때가 있음

		paramMap.put("ssnEnterCd", paramMap.get("enterCd"));
		Map<?, ?> map = commonMailService.mailContent(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;

	}

	@RequestMapping(params="cmd=getMailId", method = RequestMethod.POST )
	public ModelAndView getMailId(@RequestParam Map<String, Object> paramMap) throws Exception {
		// Session 이 없을때가 있음

		paramMap.put("ssnEnterCd", paramMap.get("enterCd"));
		paramMap.put("ssnSabun", paramMap.get("sabun"));
		Map<?, ?> map = commonMailService.getMailId(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;

	}

	/* 비밀번호 찾기 : 세션값 존재하지 않음 */
	@RequestMapping(params="cmd=callMailPwd", method = RequestMethod.POST )
	public ModelAndView callMailPwd(HttpServletRequest request, @RequestParam Map<String, Object> paramMap)
			throws Exception {

		ModelAndView mv = new ModelAndView();
		
		String receverStr = "";
		String newPwdStr = "";

		String bizCd = NoticeCommonConstants.BIZ.FIND_PWD.name();
		String uri   = request.getRequestURL().toString().replace(request.getRequestURI(), "");

		paramMap.put("enterCd"   , paramMap.get("enterCd").toString());
		paramMap.put("ssnEnterCd", paramMap.get("enterCd").toString());
		paramMap.put("sabun"     , paramMap.get("sabun").toString());
		paramMap.put("data1"     , request.getSession().getAttribute("ssnNewPwd"));
		paramMap.put("bizCd"     , bizCd);

		Map<?, ?> deEncPwd = otherService.getBase64De(paramMap);
		newPwdStr = deEncPwd != null && deEncPwd.get("code") != null ? deEncPwd.get("code").toString():"";
		
		
		/** 알림서식 조회 */
		Map<String, Map<String, Object>> template = noticeTemplateMgrService.getTemplateMapByBizCd((String) paramMap.get("enterCd"), bizCd, null);
		Map<String,Object> templateCont = null;
		/** [END] 알림서식 조회 */
		
		
		if (paramMap.get("type").toString().equals("0")) {

			Map<?, ?> mailInfo = commonMailService.mailSendSabunToInfo(paramMap);
			
			if( template != null && !template.isEmpty() ) {
				templateCont = template.get(NoticeCommonConstants.TYPE.MAIL.name());
			}

			String mailTitle   = "";
			String mailContent = "";
			String applName    = "";
			String applSabun   = "";
			String fromMail    = "";
			String sender      = "";

			if (templateCont == null || mailInfo == null) {
				mv.setViewName("jsonView");
				mv.addObject("result", "메일 발송실패하였습니다. \n관리자에게 문의하세요.");
			}  else if (templateCont.get("useYn").toString().equals("N")) {
				mv.setViewName("jsonView");
				mv.addObject("result", "알림서식의 메일 사용여부가 설정되지 않았습니다. \n관리자에게 문의하세요.");
			} else {
				
				receverStr  = mailInfo.get("receverStr").toString();
				applName    = mailInfo.get("name").toString();
				applSabun   = mailInfo.get("sabun").toString();
				
				sender      = templateCont.get("senderNm").toString();
				fromMail    = templateCont.get("sendMail").toString();
				mailTitle   = templateCont.get("templateTitle").toString();
				mailContent = templateCont.get("templateContent").toString();
				
				/*
				 * 2019-05-02 메일 파라메터 CONTENT_TITLE - 메일 본문 제목 APPL_NAME - 신청자명 APPL_SABUN -
				 * 신청자사번 INIT_PWD - 임시비밀번호
				 */
				mailContent = StringUtil.stringReplace(mailContent, "#CONTENT_TITLE#", mailTitle);
				mailContent = StringUtil.stringReplace(mailContent, "#APPL_NAME#"    , applName);
				mailContent = StringUtil.stringReplace(mailContent, "#APPL_SABUN#"   , applSabun);
				mailContent = StringUtil.stringReplace(mailContent, "#INIT_PWD#"     , newPwdStr);
				mailContent = StringUtil.stringReplace(mailContent, "#URI#"          , uri);
				
				paramMap.put("receverStr" , receverStr);
				paramMap.put("mailTitle"  , mailTitle);
				paramMap.put("mailContent", mailContent);
				paramMap.put("fromMail"   , fromMail);
				paramMap.put("bizCd"      , bizCd);
				paramMap.put("fileStr"    , "");
				paramMap.put("sender"     , sender);
				paramMap.put("receiveType", "0");
				
				mv = callMail(request, paramMap);
				mv.setViewName("jsonView");
				mv.addObject("result", mv.toString());
			}

		} else {
			if( template != null && !template.isEmpty() ) {
				templateCont = template.get(NoticeCommonConstants.TYPE.SMS.name());
			}
			
			if (templateCont == null) {
				mv.setViewName("jsonView");
				mv.addObject("result", "발송실패하였습니다. \n관리자에게 문의하세요.");
				
			} else {
				Map<?, ?> smsInfo = commonMailService.smsSendSabunToInfo(paramMap);
				receverStr = smsInfo.get("receverStr").toString();
				paramMap.put("receverStr", receverStr);
				paramMap.put("context"   , templateCont.get("templateContent").toString().replace("#INIT_PWD#", newPwdStr));
				paramMap.put("sender"    , templateCont.get("senderNm").toString());
				paramMap.put("fromSms"   , templateCont.get("sendPhone").toString());
				paramMap.put("bizCd"     , bizCd);
				
				mv = callSms(request, paramMap);
				mv.setViewName("jsonView");
				mv.addObject("result", mv.toString());
			}

		}
		return mv;

	}

	/**
	 * 개인정보 변경 신청반려시 메일, SMS, 그룹웨어 알림 보내기
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 */
	public String sendAlarmOnComPersonalInfo(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) {

		String message = "";
		try {
			Log.Debug("=======================send Start");
			
			// 메일, SMS, 그룹웨어 알림 대상자 리스트
			Map<?, ?> mailSendEmp = commonMailService.mailSendSabunToInfo(paramMap);
			Log.Debug("sendList:::::==" + mailSendEmp);

			String mailYn = StringUtils.defaultIfEmpty((String) paramMap.get("mailYn"), "Y");
			String smsYn = StringUtils.defaultIfEmpty((String) paramMap.get("smsYn"), "N");
			String gwYn = StringUtils.defaultIfEmpty((String) paramMap.get("gwYn"), "N");
			String bizCd = NoticeCommonConstants.BIZ.CHG_EMP_INFO.name();

			Log.Debug("mailYn::==>" + mailYn);
			Log.Debug("smsYn::==>" + smsYn);
			Log.Debug("gwYn::==>" + gwYn);

			if (mailSendEmp != null && mailSendEmp.size() > 0 && mailYn != null && mailYn.equals("Y") ) {
				paramMap.put("receverStr", mailSendEmp.get("receverStr"));
				paramMap.put("bizCd"     , bizCd);
				callMailType6(session, request, paramMap);
			}

			//if (smsYn != null && smsYn.equals("Y")) {
				// SmsUtil su = new SmsUtil(); su.sendSms(sendMap, paramMap)
			//}
			Log.Debug("=======================send end");
		} catch (Exception e) {
			message = "메일전송에 실패 하였습니다.";
			Log.Debug(message);
		}

		return message;
	}

	/**
	 * 개인정보 변경 신청시 메일, SMS, 그룹웨어 알림 보내기
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings("unused")
	public String sendAlarmOnChgPersonalInfo(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) {

		String message = "";
		try {
			Log.Debug("=======================send Start");
			
			// 메일, SMS, 그룹웨어 알림 대상자 리스트
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> sendList = (List<Map<String, Object>>) commonMailService.getEmpInfoChangeMailMgrList(paramMap);
			Log.Debug("sendList:::::==" + sendList);

			String mailYn = "N";
			String smsYn = "N";
			String gwYn = "N";
			
			String receverStr = "";
			String bizCd = NoticeCommonConstants.BIZ.CHG_EMP_INFO_REQ.name();
			
			/** 알림서식 조회 */
			String enterCd = (String) paramMap.get("ssnEnterCd");
			String languageCd = (session != null) ? (String) session.getAttribute("ssnLocaleCd") : "KR";
			Map<String, Map<String, Object>> template = noticeTemplateMgrService.getTemplateMapByBizCd(enterCd, bizCd, languageCd);
			Map<String,Object> templateCont = null;
			/** [END] 알림서식 조회 */

			if( sendList != null && sendList.size() > 0 ) {
				for(Map<String, Object> send : sendList) {
					mailYn = String.valueOf(send.get("mailYn"));
					smsYn = String.valueOf(send.get("smsYn"));
					gwYn = String.valueOf(send.get("gwYn"));
					
					if (mailYn != null && mailYn.equals("Y")) {
						if (!"".equals(receverStr)) {
							receverStr += "^";
						}
						receverStr += send.get("mailId") + ";" + send.get("name");
					}
					
					if (smsYn != null && smsYn.equals("Y")) {
						// SmsUtil su = new SmsUtil(); su.sendSms(map, paramMap);
					}
					
				}
				// 메일전송
				if (receverStr != null && !"".equals(receverStr)) {
					paramMap.put("receverStr", receverStr);
					paramMap.put("bizCd"     , bizCd);
					callMailType6(session, request, paramMap);
				}
			}
			
			Log.Debug("=======================send end");
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
			message = "메일전송에 실패 하였습니다.";
		}

		return message;
	}

	/*
	 * 서식으로 발송 tag 에 mailTo, bizCd, url 필수 url 은 getBase64En 을 호출해서 암호해 해서 작업
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=callMailType6", method = RequestMethod.POST )
	public ModelAndView callMailType6(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		String result = "";
		
		// set param
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("enterCd", session.getAttribute("ssnEnterCd"));
		Log.Debug("paramMap:::::::::::=============>" + paramMap);
		
		// 업무 코드(템플릿 코드)
		String bizCd = (String) paramMap.get("bizCd");
		
		/** 알림서식 조회 */
		String enterCd = (String) paramMap.get("ssnEnterCd");
		String languageCd = (session != null) ? (String) session.getAttribute("ssnLocaleCd") : "KR";
		Map<String, Map<String, Object>> template = noticeTemplateMgrService.getTemplateMapByBizCd(enterCd, bizCd, languageCd);
		Map<String,Object> templateCont = null;
		if( template != null && !template.isEmpty() ) {
			templateCont = template.get(NoticeCommonConstants.TYPE.MAIL.name());
		}
		/** [END] 알림서식 조회 */

		
		String mailTitle   = "";
		String mailContent = "";
		//String receverStr  = "";
		String fromMail    = "";
		//String sender      = "";
		//String tag         = "";

		if (templateCont == null) {
			result = "메일 발송실패하였습니다. \n관리자에게 문의하세요.";
			mv.addObject("result", result);
			
		} else if (templateCont.get("useYn").toString().equals("N")) {
			result = "알림서식의 메일 사용여부가 설정되지 않았습니다. \n관리자에게 문의하세요.";
			mv.addObject("Code", "-1");
			mv.addObject("result", result);
		} else {
			Log.Debug("receverStr::::=" + paramMap.get("receverStr").toString());

			/* 템플릿 데이터에서 가져와 설정 */
			mailTitle   = templateCont.get("templateTitle").toString();
			mailContent = templateCont.get("templateContent").toString();
			fromMail    = templateCont.get("sendMail").toString();

			// 메일 제목 치환문자 처리
			Map<String, Object> changeList = new HashMap<String, Object>();
			Iterator<String> it = null;
			String key = "";
			Log.Debug("titleChange:::=" + paramMap.get("titleChange"));
			if (paramMap.get("titleChange") != null) {
				changeList = (Map<String, Object>) paramMap.get("titleChange");
				it = changeList.keySet().iterator();
				while (it.hasNext()) {
					key = (String) it.next();
					mailTitle = StringUtil.stringReplace(mailTitle, key, String.valueOf(changeList.get(key)));
				}
			}
			
			// 메일 내용 치환문자 처리
			Log.Debug("mailContent:::+" + paramMap.get("contentsChange"));
			if (paramMap.get("contentsChange") != null) {
				changeList = (Map<String, Object>) paramMap.get("contentsChange");
				Log.Debug("changeList::::==>" + changeList);
				it = changeList.keySet().iterator();
				while (it.hasNext()) {
					key = (String) it.next();
					mailContent = StringUtil.stringReplace(mailContent, key, String.valueOf(changeList.get(key)));
				}
			}
			paramMap.put("sender"     , templateCont.get("senderNm").toString());
			paramMap.put("mailTitle"  , mailTitle);
			paramMap.put("mailContent", mailContent);
			paramMap.put("fromMail"   , fromMail);
			paramMap.put("bizCd"      , bizCd);
			paramMap.put("fileStr"    , "");
			paramMap.put("receiveType", "0");
			Log.Debug("paramMap::" + paramMap);

			mv = callMail(request, paramMap);
			mv.addObject("result", mv.toString());

		}

		return mv;
	}

	@RequestMapping(params="cmd=callMail", method = RequestMethod.POST )
	public ModelAndView callMail(HttpServletRequest request, @RequestParam Map<String, Object> paramMap)
			throws Exception {
		/**
		 * [0] : 수신자정보(주소;이름^주소;이름^...주소;이름) [1] : 제목 [2] : 본문 [3] : 보내는 사람 사번 [4] :
		 * 발송메일주소 [5] : 업무코드[급여:CPN...
		 */
		Log.Debug("----------------------------------" + paramMap.toString());
		
		MailUtil mailUtil = new MailUtil(request);
		
		/* 메일전송 관련 설정 데이터 조회 */
		SmtpMailUtil mUtil = null;
		String MAIL_SEND_TYPE = "1";
		String MAIL_SERVER    = mailServer;
		String MAIL_PORT      = null;
		String MAIL_USER      = mailUser;
		String MAIL_PASSWORD  = mailPasswd;
		String MAIL_TESTER    = mailTester;
		Map<?,?> mailStdMap = commonMailService.mailStdMap(paramMap);
		if( mailStdMap != null && !mailStdMap.isEmpty() ) {
			MAIL_SEND_TYPE = (String) mailStdMap.get("mailSendType");
			MAIL_SERVER    = (String) mailStdMap.get("mailServer");
			MAIL_PORT      = (String) mailStdMap.get("mailPort");
			MAIL_USER      = (String) mailStdMap.get("mailUser");
			MAIL_PASSWORD  = (String) mailStdMap.get("mailPassword");
			MAIL_TESTER    = (String) mailStdMap.get("mailTester");
		}
		/* [END] 메일전송 관련 설정 데이터 조회 */

		
		String result        = "";
		String enterCd       = (String) paramMap.get("enterCd");
		String title         = (String) paramMap.get("mailTitle");
		String content       = (String) paramMap.get("mailContent");
		String sender        = (String) paramMap.get("sender");
		String fromMail      = (String) paramMap.get("fromMail");
		String receverStr    = (String) paramMap.get("receverStr");
		String ccReceiverStr = (String) paramMap.get("ccReceiverStr");
		String fileStr       = (String) paramMap.get("fileStr");
		String rcvName       = "";
		String log           = null;
		
		String[] tmpReceverList = null;
		String[] receverAddList = null;
		String[] tmpFileList    = null;
		String[] fileAddList    = null;
		
		// 회사코드 설정
		if(enterCd == null) {
			enterCd = (String) paramMap.get("ssnEnterCd");
		}
		
		// 이메일 내용 설정
		if(content == null) {
			content = (String) paramMap.get("contents");
		}

		/**
		 * 크로스 사이트 스크립팅 공격에 대비한 XssFilter 적용.
		 * XssFilter 적용 시 스크립트와 같은 XSS 공격에 취약한 요소를 걸러낸다.
		 * ex) 입력 값:           <img src="x" onerror="alert(document.cookie)"/>
		 *     XssFilter 적용 후: <img src="x"/>
		 * XssPreventer.escape: 문자열에서 HTML으로 인식될만한 요소까지도 완전 변환. 예를 들어, '<'는 '&lt;', '>'는 '&gt;'로 변환.
		 * XssPreventer.unescape: 문자열에서 변환된 HTML 요소를 원본 HTML로 변환. 예를 들어, '&lt;'는 '<', '&gt;'는 '>'로 변환.
		 * XssFilter: HTML 요소를 유지하되 XSS 공격에 취약한 요소만 제거.
		 */
		LucyXssFilter filter = XssSaxFilter.getInstance("lucy-xss-sax.xml", true); // 두 번째 인자값은 withoutComment 로, 값이 없거나 false 인 경우 필터링 된 스크립트의 로그가 결과값에 추가됨.
		content = filter.doFilter(XssPreventer.unescape(content));
		title = filter.doFilter(XssPreventer.unescape(title));

		content = mailUtil.getMailContent(paramMap.get("receiveType").toString(), content.toString());

		// 수신자 이메일 설정
		if( !StringUtil.isBlank(receverStr) ) {
			tmpReceverList = receverStr.split("\\^");
			receverAddList = new String[tmpReceverList.length];
		}
		
		// 첨부파일 설정
		if( !StringUtil.isBlank(fileStr) ) {
			tmpFileList = fileStr.split("\\^");
			fileAddList = new String[tmpFileList.length];
		}
		
		// 전송방식이 [WAS]에서 전송하는 경우
		if( "1".equals(MAIL_SEND_TYPE) ) {
			mUtil = new SmtpMailUtil(MAIL_SERVER, Integer.parseInt(MAIL_PORT), MAIL_USER, MAIL_PASSWORD, fromMail);
		}

		// 수신자가 존재하는 경우 진행
		if( tmpReceverList != null && tmpReceverList.length > 0 ) {
			//int cnt =0;
			// 메일건수(수신자의 명수)
			int mailCnt = 0;
			// 발송성공건수
			int successMailCnt = 0;
			
			// 메일 SEQ
			String mailSeq = "";
			// mailSeq 조회 파라미터 삽입
			paramMap.put("seqId", "MAIL");
			
			for (int i = 0; i < tmpReceverList.length; i++) {
				// Reset SMTP Exception Message
				log = null;
				
				// 메일주소 세팅
				if (tmpReceverList[i].indexOf(";") > 0) { // test@test.com;홍길동 형식일 경우 메일주소만 취득
					receverAddList[i] = tmpReceverList[i].split(";")[0];
				} else {
					receverAddList[i] = tmpReceverList[i];
				}
				rcvName = tmpReceverList[i];

				// 전송방식이 [WAS]에서 전송하는 경우
				if( "1".equals(MAIL_SEND_TYPE) ) {
					try {
						if (mUtil != null) result = mUtil.sendEmail(sender, title, receverAddList[i], content, fileAddList, MAIL_TESTER);
					} catch (Exception e) {
						result = "N";
						log = e.getMessage();
					}
				} else {
					result = "N";
				}
				
				// SEQ 조회
				Map<?, ?> seqmap = otherService.getSequence(paramMap);
				
				mailSeq = seqmap != null && seqmap.get("getSeq") != null ? seqmap.get("getSeq").toString():null;
				Log.Debug("mailSeq=>>>>" + mailSeq);
				
				// SET paramMap
				paramMap.put("mailSeq"      , mailSeq);
				paramMap.put("title"        , title);
				paramMap.put("content"      , content);
				paramMap.put("result"       , result);
				paramMap.put("mailCnt"      , "1");
				paramMap.put("rcvName"      , rcvName);
				paramMap.put("log"          , (log == null) ? "" : log);
				paramMap.put("ccReceiverStr", (ccReceiverStr == null) ? "" : ccReceiverStr);
				Log.Debug("paramMap=>>>>" + paramMap);
				
				// 메일 발송 결과 DB 저장
				//cnt = commonMailService.tsys996InsertMail(paramMap);
				commonMailService.tsys996InsertMail(paramMap);
				
				mailCnt = mailCnt + 1;
				if( "Y".equals(result) ) {
					successMailCnt = successMailCnt + 1;
				}
			}
			
			result = "메일발송요청  : " + tmpReceverList.length + ", 메일발송건수  : " + mailCnt + ", 발송성공건수 : " + successMailCnt;
			Log.Debug("result=>>>>" + result);
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * SMS 전송 (이수그룹 사용)
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callSms", method = RequestMethod.POST )
	public ModelAndView callSms(HttpServletRequest request, @RequestParam Map<String, Object> paramMap)
			throws Exception {
		Log.DebugStart();

		String sender = String.valueOf(paramMap.get("fromSms"));
		List<String> receivers = Arrays.asList(String.valueOf(paramMap.get("receverStr")).split("\\^"));
		String title = String.valueOf(paramMap.get("title"));
		String context = String.valueOf(paramMap.get("context"));
		String chkid = String.valueOf(paramMap.get("sender"));

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("fromPhoneNumber", sender);
		param.put("toPhoneNumbers", receivers);
		param.put("title", title);
		param.put("body", context);

		Map<?, ?> resultMap = ApiUtil.sendSms(param);

		Map<String, Object> logMap = new HashMap<String, Object>();
		logMap.put("enterCd", paramMap.get("enterCd").toString());
		logMap.put("jobType", "sms");
		logMap.put("jobYmd", new SimpleDateFormat("yyyyMMdd").format(Calendar.getInstance().getTime()));
		logMap.put("sender", sender);
		logMap.put("receivers", receivers);
		String temp = String.valueOf(receivers);
		if (temp != null && temp.length() > 1) {
			temp = temp.substring(1, temp.length() - 1);
		}
		logMap.put("receivers", temp);
		logMap.put("departmentCode", paramMap.get("departmentCode"));
		logMap.put("title", title);
		logMap.put("content", context);
		logMap.put("resultCd", resultMap.get("code").toString());
		logMap.put("resultMsg", resultMap.get("message").toString());
		logMap.put("chkid", chkid);
		logMap.put("seqId", "MAIL");
		
		
		Map<?, ?> seqmap = otherService.getSequence(logMap);
		String mailSeq = seqmap != null && seqmap.get("getSeq") != null ? seqmap.get("getSeq").toString():null;
		logMap.put("mailSeq", mailSeq);

		commonMailService.tsys992Insert(logMap);

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", resultMap);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 월급여메일전송 by JSG
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(params="cmd=postMonPayMailCreCallMail", method = RequestMethod.POST )
	public ModelAndView MonPayMailCreCallMail(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		//String testMailCont = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("enterCd", session.getAttribute("ssnEnterCd"));

		String[] sabuns = paramMap.get("sabuns").toString().split(",");
		String fromEmail = paramMap.get("balsin").toString();
		String payActionCd = paramMap != null && paramMap.get("searchPayActionCd") != null ? paramMap.get("searchPayActionCd").toString():""; 
		
		

		for (int cnt = 0; cnt < sabuns.length;) {
			paramMap.put("receiverSabun", sabuns[cnt]);
			paramMap.put("sabun", sabuns[cnt]);
			paramMap.put("payActionCd", payActionCd);

			cnt++;

			List<?> list = new ArrayList<Object>();
			String searchYn = "Y";

			try {
				list = monPayMailCreService.getMonPayMailCreHTML1(paramMap);
			} catch (Exception e) {
				searchYn = "N";
			}
			ModelAndView mailContensModel1 = new ModelAndView();
			mailContensModel1.setViewName("jsonView");
			mailContensModel1.addObject("DATA", list);
			try {

				paramMap.put("elementType", "A");
				list = perPayPartiPopStaService.getPerPayPartiPopStaCalcList(paramMap);
			} catch (Exception e) {
				searchYn = "N";
			}
			ModelAndView mailContensModel2 = new ModelAndView();
			mailContensModel2.setViewName("jsonView");
			mailContensModel2.addObject("DATA", list);
			try {
				paramMap.put("elementType", "D");
				list = perPayPartiPopStaService.getPerPayPartiPopStaCalcList(paramMap);
			} catch (Exception e) {
				searchYn = "N";
			}
			ModelAndView mailContensModel3 = new ModelAndView();
			mailContensModel3.setViewName("jsonView");
			mailContensModel3.addObject("DATA", list);
			try {
				list = perPayPartiPopStaService.getPerPayPartiPopStaCalcTaxList(paramMap);
			} catch (Exception e) {
				searchYn = "N";
			}
			ModelAndView mailContensModel4 = new ModelAndView();
			mailContensModel4.setViewName("jsonView");
			mailContensModel4.addObject("DATA", list);

			List<Map<?, ?>> mailContens1 = (List<Map<?, ?>>) mailContensModel1.getModelMap().get("DATA");
			List<Map<?, ?>> mailContens2 = (List<Map<?, ?>>) mailContensModel2.getModelMap().get("DATA");
			List<Map<?, ?>> mailContens3 = (List<Map<?, ?>>) mailContensModel3.getModelMap().get("DATA");
			List<Map<?, ?>> mailContens4 = (List<Map<?, ?>>) mailContensModel4.getModelMap().get("DATA");

			if (searchYn.equals("N")) {
				ModelAndView mv = new ModelAndView();

				mv.setViewName("jsonView");
				mv.addObject("result", "조회에 실패하여 메일발송에 실패하였습니다.");
				Log.Debug("조회에 실패하여 메일발송에 실패하였습니다.");
				return mv;
			}
			//String path = request.getRequestURL().toString().replace(request.getRequestURI(), "");

			String htmlStr = "<style type='text/css'>" + "@charset 'utf-8';"
					+ " body, div, h1, h2, h3, h4, h5, h6, ul, ol, li, dl, dt, dd, p, form, fieldset, input, table, tr, th, td, textarea, pre {margin:0; padding:0;} "
					+ " input, select,textarea { font-family: Nanum Gothic,나눔고딕, Malgun Gothic, 돋움, Dotum, AppleGothic, sans-serif !important; } "
					+ " button { margin:0; padding:0; border:0; outline:0; font-size:100%; vertical-align:baseline; background:transparent; cursor:pointer; *overflow:visible; } "
					+ " h1, h2, h3, h4, h5, h6 { font-weight: normal; } " + " em { font-style:normal; } "
					+ " ul, ol, li { list-style:none } " + " fieldset, img { border:none; margin:0; padding:0; } "
					+ " body a { color:#6e7277; text-decoration: none; } "
					+ " body a:hover, body a:active,body a:focus { text-decoration:none; } "
					+ " pre { padding-top:5px; } "
					+ " table { margin:0; padding:0; border-spacing:0; border-collapse:collapse; border:0; } "
					+ " td { text-align:left; } " + " hr { display:none } "
					+ " caption, legend, .hide { position:absolute; width:0; height:0; overflow:hidden; text-indent:-9999px; font-size:0; } "
					+ " body { font-family: Nanum Gothic,나눔고딕, Malgun Gothic, 돋움, Dotum, AppleGothic, sans-serif !important; color:#747b80; font-size:13px; letter-spacing:-1px; } "
					+ " #wrap { 50% 0 } "
					+ " #header { width:545px; height:175px; margin:0 auto; padding:75px 0 0 50px; 360px 88px no-repeat; } "
					+ " #container { position:relative; width:495px; margin:0 auto; padding:15px 50px 0; } "
					+ " .mat10 { margin-top:10px !important; } "
					+ " .pay_date { display:inline-block; color:#2a2c2e; font-weight:600; margin-right:5px; vertical-align:top; line-height:18px; } "
					+ " .pay_date_group { position:absolute; right:50px; top:50px; } "
					+ " .pay_date_group .pay_date { display:inline-block; color:#2a2c2e; font-weight:600; margin-right:5px; vertical-align:top; line-height:18px; } "
					+ " .pay_date_group .btn_print { display:inline-block; border:1px solid #cdd1d4; border-radius:3px; width:14px; height:12px; padding:3px; text-indent:-99999px; } "
					+ " h2 { font-size:18px; color:#2a2c2e; font-weight:800; margin:25px 0 5px; }"
					+ " h2>span { font-size:11px; color:#747b80; margin-left:5px; }"
					+ " table.blue { border-top:2px solid #4d90c4; width:100%; } "
					+ " table.blue>tbody>tr>th { font-size:14px; background-color:#f2f7fa; color:#4d90c4; font-weight:800; padding:8px 0 8px 15px; border-bottom:1px solid #cdd1d4; border-right:1px solid #cdd1d4; border-left:1px solid #cdd1d4; text-align:left; } "
					+ " table.blue>tbody>tr>th:first-child { border-left:none; } "
					+ " table.blue>tbody>tr>td { font-size:14px; font-weight:600; padding:8px 10px; border-bottom:1px solid #cdd1d4; text-align:right; height:15px; } "
					+ " table.gray { border-top:2px solid #cdd1d4; width:100%; } "
					+ " table.gray>tbody>tr>th { font-size:14px; background-color:#f7f7f7; color:#2a2c2e; font-weight:800; padding:8px 0 8px 15px; border-bottom:1px solid #cdd1d4; border-right:1px solid #cdd1d4; border-left:1px solid #cdd1d4; text-align:left; } "
					+ " table.gray>tbody>tr>th:first-child { border-left:none; } "
					+ " table.gray>tbody>tr>td { font-size:14px; font-weight:600; padding:8px 10px; border-bottom:1px solid #cdd1d4; text-align:right; height:15px; } "
					+ " table.gray>tfoot>tr>th { background-color:#e9ebec; color:#2a2c2e; font-size:14px; font-weight:800; padding:6px 0 6px 15px; border-bottom:1px solid #cdd1d4; border-right:1px solid #cdd1d4; border-left:1px solid #cdd1d4; text-align:left; } "
					+ " table.gray>tfoot>tr>th:first-child { border-left:none; } "
					+ " table.gray>tfoot>tr>td { background-color:#e9ebec; padding:6px 10px; border-bottom:1px solid #cdd1d4; font-size:14px; font-weight:800; color:#2a2c2e; text-align:right; } "
					+ " table.col_table>tbody>tr>th { padding:8px 0; text-align:center; } "
					+ " table.col_table>tbody>tr>th:last-child { border-right:none; } "
					+ " table.col_table>tbody>tr>td { border-right:1px solid #cdd1d4; } "
					+ " table.col_table>tbody>tr>td:last-child { border-right:none; } "
					+ " table.col_table>tfoot>tr>th { border-right:none !important; border-left:none !important; } "
					+ " table.col_table>tfoot>tr>td { border-right:none !important; } "
					+ " .total_sum { font-size:16px; font-weight:800; color:#4d90c4; } "
					+ " .table_txt { text-align:left !important; } " + " ul.half_box { overflow:hidden; } "
					+ " ul.half_box>li { float:left; width:48%; } "
					+ " ul.half_box>li:first-child { margin-right:4%; } "
					+ " .con_foot { width:100%; text-align:center; margin:30px 0; } "
					+ " .btn_close { display:inline-block; background-color:#888e93; color:#FFF; font-weight:800; font-size:12px; text-align:center; width:55px; border-radius:5px; padding:6px 0; margin-top:20px; } "
					+ "</style>" + "<div id='wrap' >" + "	<div id='header' >" + " <p><img src='cid:top-bg' /></p>"
					+ " <table>" + "	 <colgroup>" + "	 <col width='75%'>" + "	 <col width='25%'>" + "<tr><td>"
					+ "		<h1><span style='font-size:34px; color:#2a2c2e; font-weight:800; line-height:38px; letter-spacing:-2px;'>"
					+ mailContens1.get(0).get("payYmNm").toString() + "</span><br>"
					+ "		<span style='font-size:34px; color:#4d90c4 !important;'>"
					+ mailContens1.get(0).get("payNm").toString() + "</span></h1>" + "		<p class='today_txt'>"
					+ "			절약은 불필요한 비용을 피하는 과학이며,<br>" + "			또 신중하게 우리의 재산을 관리하는 기술이다.<br>"
					+ "			- 세네카" + "		</p>" + " </td>" + " <td>" + " <img src='cid:top-img' />"
					+ " </td></tr></table>" + "	</div>" + "	<div id='container'>"
					+ " <p><img src='cid:txt-bg' style='width:595px; height:56px;' /></p>" + " <table>" + "	 <colgroup>"
					+ "	 <col width='80%'>" + "	 <col width='20%'>" + "<tr ><td>"
					+ "		<span style='font-size:18px; color:#2a2c2e; font-weight:800; '>급여명세서</span>" + " </td>"
					+ " <td style='text-align:right'> "
					+ "     <span style='font-size:14px; color:#2a2c2e; font-weight:600; text-align:right;'>"
					+ mailContens1.get(0).get("paymentYmdNm").toString() + "</span>" + " </td></tr></table>"
					+ "		<table class='blue'>" + "			<colgroup>" + "				<col width='100px'>"
					+ "				<col width='150px'>" + "				<col width='100px'>"
					+ "				<col width='*'>" + "			</colgroup>" + "			<tbody>"
					+ "				<tr>" + "					<th>성명</th>"
					+ "					<td class='table_txt'>" + mailContens1.get(0).get("krName").toString() + "</td>"
					+ "					<th>사번</th>" + "					<td class='table_txt'>"
					+ mailContens1.get(0).get("sabun").toString() + "</td>" + "				</tr>"
					+ "				<tr>" + "					<th>소속</th>"
					+ "					<td colspan='3' class='table_txt'>"
					+ mailContens1.get(0).get("orgNm").toString() + "</td>" + "				</tr>"
					+ "			</tbody>" + "		</table>" + " 		<table class='blue mat10'>"
					+ " 			<colgroup>" + " 				<col width='100px'>"
					+ " 				<col width='150px'>" + " 				<col width='100px'>"
					+ " 				<col width='*'>" + " 			</colgroup>" + " 			<tbody>"
					+ " 				<tr>" + " 					<th>지급총액(A)</th>" + " 					<td>"
					+ mailContens1.get(0).get("totEarningMon").toString() + "</td>"
					+ " 					<th>공제총액(B)</th>" + " 					<td >"
					+ mailContens1.get(0).get("totDedMon").toString() + "</td>" + " 				</tr>"
					+ " 				<tr>" + " 					<th>과표총액</th>" + " 					<td >"
					+ mailContens1.get(0).get("taxBaseMon").toString() + "</td>" + " 					<th>지급은행</th>"
					+ " 					<td>" + mailContens1.get(0).get("bankNm").toString() + "</td>"
					+ " 				</tr>" + " 				<tr>" + " 					<th>계좌번호</th>"
					+ " 					<td>" + mailContens1.get(0).get("accountNo").toString() + "</td>"
					+ " 					<th>실수령액(A-B)</th>" + " 					<td><span class='total_sum'>"
					+ mailContens1.get(0).get("resultMon").toString() + "</span></td>" + " 				</tr>"
					+ " 			</tbody>" + " 		</table>" + " 		<ul class='half_box'>" + " 			<li>"
					+ " 				<h2>지급내역</h2>" + " 				<table class='gray'>"
					+ " 					<colgroup>" + " 						<col width='100px'>"
					+ " 						<col width='150px'>" + " 						<col width='100px'>"
					+ " 						<col width='*'>" + " 					</colgroup>"
					+ " 					<tbody>";

			String dispTotResultMon = "";
			if (mailContens2.size() > 0) {
				for (int i = 1; i < mailContens2.size(); i++) {
					htmlStr += "<tr><th>" + mailContens2.get(i).get("reportNm").toString() + "</th><td>"
							+ mailContens2.get(i).get("resultMon").toString() + "</td></tr>";
				}
				dispTotResultMon = mailContens2.get(0).get("resultMon").toString();
			}
			htmlStr += " 					</tbody>" + " 					<tfoot>" + " 						<tr>"
					+ " 							<th>지급총액(A)</th><td>" + dispTotResultMon + "</td>"
					+ " 						</tr>" + " 					</tfoot>" + " 				</table>"
					+ " 			</li>" + " 			<li>" + " 				<h2>공제내역</h2>"
					+ " 				<table class='gray'>" + " 					<colgroup>"
					+ " 						<col width='100px'>" + " 						<col width='150px'>"
					+ " 						<col width='100px'>" + " 						<col width='*'>"
					+ " 					</colgroup>" + " 					<tbody>";

			dispTotResultMon = "";
			if (mailContens3.size() > 0) {
				for (int i = 1; i < mailContens3.size(); i++) {
					htmlStr += "<tr><th>" + mailContens3.get(i).get("reportNm").toString() + "</th><td>"
							+ mailContens3.get(i).get("resultMon").toString() + "</td></tr>";
				}
				dispTotResultMon = mailContens3.get(0).get("resultMon").toString();
			}
			htmlStr += " 					</tbody>" + " 					<tfoot>" + " 						<tr>"
					+ " 							<th>공제총액(B)</th><td>" + dispTotResultMon + "</td>"
					+ " 						</tr>" + " 					</tfoot>" + " 				</table>"
					+ " 			</li>" + " 		</ul>"
					+ " 		<h2>과세내역<span>지급 완료된 현금 또는 현물로서, 제세공과금 납부를 위하여 관리하는 금액(지급/공제금액에 미포함)</span></h2>"
					+ " 		<table id='calcTaxTable' name='calcTaxTable' class='gray col_table'>"
					+ " 			<colgroup>" + " 				<col width='20%'>"
					+ " 				<col width='20%'>" + " 				<col width='20%'>"
					+ " 				<col width='20%'>" + " 				<col width='20%'>" + " 			</colgroup>"
					+ " 			<tbody>";

			dispTotResultMon = "";
			int cnt1 = 0;
			int aTdCnt = 0;
			if (mailContens4.size() > 0) {
				cnt1 = mailContens4.size() - 1;
				if (cnt1 > 0) {
					cnt1 = (int) Math.ceil((float) cnt1 / 5);

					for (int row = 0; row < cnt1; row++) {
						htmlStr += "<tr>";
						aTdCnt = 0;
						for (int tIdx = 5 * row + 1; aTdCnt < 5; tIdx++) {

							htmlStr += "<th>";

							if (tIdx < mailContens4.size()) {
								htmlStr += mailContens4.get(tIdx).get("reportNm").toString();
							}
							htmlStr += "</th>";

							aTdCnt++;
						}

						htmlStr += "</tr><tr>";

						// �뜲�씠�꽣
						aTdCnt = 0;
						for (int dIdx = 5 * row + 1; aTdCnt < 5; dIdx++) {
							htmlStr += "<td>";
							if (dIdx < mailContens4.size()) {
								htmlStr += mailContens4.get(dIdx).get("resultMon").toString();
							}
							htmlStr += "</td>";

							aTdCnt++;
						}
						htmlStr += "</tr>";
					}
					dispTotResultMon = mailContens4.get(0).get("resultMon").toString();
				}
			}
			htmlStr += " 			</tbody>" + " 			<tfoot>" + " 				<tr>"
					+ " 					<td></td>" + " 					<td></td>" + " 					<td></td>"
					+ " 					<th>과세총액(A)</th>" + " 					<td >" + dispTotResultMon + "</td>"
					+ " 				</tr>" + " 			</tfoot>" + " 		</table>"
					+ " 		<table class='gray mat10'>" + " 			<colgroup>"
					+ " 				<col width='20%'>" + " 				<col width='*'>" + " 			</colgroup>"
					+ " 			<tbody>" + " 				<tr>" + " 					<th>비고</th>"
					+ " 					<td id='bigo' name='bigo' class='table_txt'></td>" + " 				</tr>"
					+ " 			</tbody>" + " 		</table>" + " 	</div>" + " </div>";

			paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

			paramMap.put("receverStr", mailContens1.get(0).get("mailId").toString());
			paramMap.put("mailTitle", mailContens1.get(0).get("payActionNm").toString() + " 명세서");
			paramMap.put("mailContent", htmlStr);
			paramMap.put("fromMail", fromEmail);
			paramMap.put("fileStr", "");
			// paramMap.put("sender","e-HR System");
			paramMap.put("sender", mailSender);
			paramMap.put("receiveType", "0");

			paramMap.put("imagesStr",
					"/common/images/pay/top_bg.png|/common/images/pay/top_img.png|/common/images/pay/txt_bg.png");
			paramMap.put("imagesIds", "top-bg|top-img|txt-bg");

			// Log.Debug("===========htmlStr:"+htmlStr);

			ModelAndView mv = new ModelAndView();
			mv.setViewName("jsonView");
			mv.addObject("result", "");

			mv = callMail(request, paramMap);

			/* 메일 발송 후 해당 테이블에 발송된 메일 seq를 update */
			Map<String, Object> updateMap = new HashMap<String, Object>();
			updateMap.put("ssnEnterCd", paramMap.get("ssnEnterCd"));
			updateMap.put("searchPayActionCd", paramMap.get("searchPayActionCd"));
			updateMap.put("receiverSabun", paramMap.get("receiverSabun"));
			updateMap.put("mailSeq", savedMailSeq);
			monPayMailCreService.updateMailSeqForTcpn203(updateMap);

		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", "");
		return mv;
	}

	/**
	 * 결제요청 알림메일
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=callMailAppl", method = RequestMethod.POST )
	public ModelAndView callMailAppl(HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {

		String result = "";
		String bizCd = NoticeCommonConstants.BIZ.APP_REQ.name();
		String uri    = request.getRequestURL().toString().replace(request.getRequestURI(), "");
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("enterCd"   , session.getAttribute("ssnEnterCd"));
		paramMap.put("bizCd"     , bizCd);
		paramMap.put("seqId"     , "MAIL");
		// paramMap.put("mailSeq",(otherService.getSequence(paramMap)).get("getSeq").toString());

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		
		// 메일 수신자 목록 조회
		Map<?, ?> mailAppInfo = commonMailService.mailAppSendSabun(paramMap);
		
		
		/* 메일전송 관련 설정 데이터 조회 */
		SmtpMailUtil mUtil = null;
		String MAIL_SEND_TYPE = "1";
		String MAIL_SERVER    = mailServer;
		String MAIL_PORT      = null;
		String MAIL_USER      = mailUser;
		String MAIL_PASSWORD  = mailPasswd;
		String MAIL_TESTER    = mailTester;
		Map<?,?> mailStdMap = commonMailService.mailStdMap(paramMap);
		if( mailStdMap != null && !mailStdMap.isEmpty() ) {
			MAIL_SEND_TYPE = (String) mailStdMap.get("mailSendType");
			MAIL_SERVER    = (String) mailStdMap.get("mailServer");
			MAIL_PORT      = (String) mailStdMap.get("mailPort");
			MAIL_USER      = (String) mailStdMap.get("mailUser");
			MAIL_PASSWORD  = (String) mailStdMap.get("mailPassword");
			MAIL_TESTER    = (String) mailStdMap.get("mailTester");
		}
		/* [END] 메일전송 관련 설정 데이터 조회 */
		
		
		// 참조자
		if (mailAppInfo == null) {
			result = "메일발송이 필요없는 결재입니다.";
			mv.addObject("result", result);
		} else {
			String senderSabun = "";
			String receiverSabun = "";

			if ("21".equals(mailAppInfo.get("applStatusCd").toString()) || "31".equals(mailAppInfo.get("applStatusCd").toString())) {// 결재할 사람에게 요청된 내용을 전송
				senderSabun = mailAppInfo.get("applSabun").toString();
				receiverSabun = mailAppInfo.get("agreeSabun").toString();
				paramMap.put("withCC", "");
				
			} else {
				// 결재완료시 참조자에게 발송
				if ("Y".equals(mailAppInfo.get("referMailYn"))) {
					paramMap.put("withCC", "referMailYn");
				}

				senderSabun = mailAppInfo.get("agreeSabun").toString();
				receiverSabun = mailAppInfo.get("applSabun").toString();
			}

			// 최초 신청과 동시에 참조자에게 발송
			if ("Y".equals(mailAppInfo.get("applReferMailYn")) && "Y".equals(paramMap.get("firstDiv"))) {
				paramMap.put("withCC", "applReferMailYn");
			}

			// 받는사람(신청서 조건에 따라 참조자 포함)
			paramMap.put("sabun", receiverSabun);
			List<?> mailInfoList = commonMailService.mailSendSabunWithCc(paramMap);

			// 보내는사람
			paramMap.put("sabun", senderSabun);
			Map<?, ?> sendMailInfo = commonMailService.mailSendSabunFromInfo(paramMap);
			
			/** 알림서식 조회 */
			String enterCd = (String) paramMap.get("ssnEnterCd");
			String languageCd = (session != null) ? (String) session.getAttribute("ssnLocaleCd") : "KR";
			Map<String, Map<String, Object>> template = noticeTemplateMgrService.getTemplateMapByBizCd(enterCd, bizCd, languageCd);
			Map<String,Object> templateCont = null;
			if( template != null && !template.isEmpty() ) {
				templateCont = template.get(NoticeCommonConstants.TYPE.MAIL.name());
			}
			/** [END] 알림서식 조회 */
			
			if (sendMailInfo == null) {
				result = "보내는 메일주소가 없습니다.";
				mv.addObject("Code", "-1");
				mv.addObject("result", result);

			} else if (sendMailInfo.get("sendMail") == null || "".equals(sendMailInfo.get("sendMail"))
					|| sendMailInfo.get("sendName") == null || "".equals(sendMailInfo.get("sendName"))) {
				result = "보내는 메일주소가 없습니다.";
				mv.addObject("Code", "-1");
				mv.addObject("result", result);
				
			} else if (templateCont == null) {
				result = "메일 서식 데이타가 없습니다.";
				mv.addObject("Code", "-1");
				mv.addObject("result", result);

			} else if (templateCont.get("useYn").toString().equals("N")) {
				result = "알림서식의 메일 사용여부가 설정되지 않았습니다. \n관리자에게 문의하세요.";
				mv.addObject("Code", "-1");
				mv.addObject("result", result);
			} else {

				String receiverStr = "";
				String mailTitle   = "";
				String mailContent = "";
				String fromMail    = sendMailInfo.get("sendMail").toString();
				String sender      = sendMailInfo.get("sendName").toString();
				String deLink      = mailAppInfo.get("applLink").toString();
				String enLink      = "";
				String receiverDiv = "";
				String data1Str    = "";
				String data2Str    = "";
				String data4Str    = "";
				
				if ("Y".equals(sendMailInfo.get("sendMailYn").toString())) {
					fromMail = "";
				}
				
				// 전송방식이 [WAS]에서 전송하는 경우
				if( "1".equals(MAIL_SEND_TYPE) ) {
					mUtil = new SmtpMailUtil(MAIL_SERVER, Integer.parseInt(MAIL_PORT), MAIL_USER, MAIL_PASSWORD, fromMail);
				}
				
				paramMap.put("data1", deLink);
				Map<?, ?> endLink = otherService.getBase64En(paramMap);

				enLink = "/Link.do?link=" + endLink.get("code").toString();
				enLink = StringUtil.getBaseUrl(request) + enLink;
				
				
				Map<?, ?> mailInfo = null;
				
				int sendResult = -1;
				int sendCnt = 0;
				int successCnt = 0;
				
				String log = null;
				
				for (int i = 0; i < mailInfoList.size(); i++) {
					log = null;
					sendResult = -1;
					mailInfo = (Map<?, ?>) mailInfoList.get(i);
					
					receiverStr = mailInfo.get("receiverStr").toString(); // 수신, 참조자 메일주소
					receiverDiv = mailInfo.get("receiverDiv").toString(); // 수신, 참조 구분
					
					// (메일주소;이름) 형태가 아닌경우는 빈값으로 저장
					if ("Y".equals(mailInfo.get("receiveMailYn").toString())) {
						receiverStr = "";
					}
					
					if ("RCV".equals(receiverDiv)) { // 수신자
						data1Str = mailAppInfo.get("status").toString();
						data2Str = mailAppInfo.get("applNm").toString();
						data4Str = mailAppInfo.get("menuNm").toString();
					} else if ("CC".equals(receiverDiv)) { // 참조자
						data1Str = "참조";
						data2Str = "모든 문서";
						data4Str = "모든문서";
					}
					
					/*
					 * 메일 파라메터 CONTENT_TITLE1 - 신청서명 CONTENT_TITLE2 - 결재상태 APPL_CD_NM - 신청서명
					 * APPL_NAME - 신청자명 APPL_SABUN - 신청자사번 APPL_YMD - 신청일 APPL_LINK - 신청서경로
					 */
					mailContent = templateCont.get("templateContent").toString();
					mailContent = StringUtil.stringReplace(mailContent, "#DATA1#"         , data1Str);
					mailContent = StringUtil.stringReplace(mailContent, "#DATA2#"         , data2Str);
					mailContent = StringUtil.stringReplace(mailContent, "#DATA3#"         , enLink);
					mailContent = StringUtil.stringReplace(mailContent, "#DATA4#"         , data4Str);
					mailContent = StringUtil.stringReplace(mailContent, "#CONTENT_TITLE1#", mailAppInfo.get("applNm").toString());
					mailContent = StringUtil.stringReplace(mailContent, "#CONTENT_TITLE2#", mailAppInfo.get("status").toString());
					mailContent = StringUtil.stringReplace(mailContent, "#APPL_CD_NM#"    , mailAppInfo.get("applNm").toString());
					mailContent = StringUtil.stringReplace(mailContent, "#APPL_NAME#"     , mailAppInfo.get("applSabunNm").toString());
					mailContent = StringUtil.stringReplace(mailContent, "#APPL_SABUN#"    , mailAppInfo.get("applSabun").toString());
					mailContent = StringUtil.stringReplace(mailContent, "#APPL_YMD#"      , mailAppInfo.get("applYmd").toString());
					mailContent = StringUtil.stringReplace(mailContent, "#APPL_LINK#"     , mailAppInfo.get("menuNm").toString());
					mailContent = StringUtil.stringReplace(mailContent, "#URI#"           , uri);
					mailContent = "<html><body>" + mailContent + "</body></html>";
					
					mailTitle = templateCont.get("templateTitle").toString();
					mailTitle = StringUtil.stringReplace(mailTitle, "#DATA1#", data1Str);
					mailTitle = StringUtil.stringReplace(mailTitle, "#DATA2#", data2Str);
					mailTitle = "[" + templateCont.get("enterAlias").toString() + "]" + mailTitle;
					
					// 전송방식이 [WAS]에서 전송하는 경우
					if( "1".equals(MAIL_SEND_TYPE) ) {
						try {
							result = mUtil.sendEmail(sender, mailTitle, receiverStr, mailContent, null, MAIL_TESTER);
						} catch (Exception e) {
							log = e.getMessage();
							result = "N";
						}
					} else {
						result = "N";
					}
					
					paramMap.put("mailSeq"      , (otherService.getSequence(paramMap)).get("getSeq").toString());
					paramMap.put("bizCd"        , bizCd);
					paramMap.put("mailCnt"      , 1);
					paramMap.put("rcvName"      , receiverStr);
					paramMap.put("title"        , mailTitle);
					paramMap.put("sender"       , sender);
					paramMap.put("fromMail"     , fromMail);
					paramMap.put("content"      , mailContent);
					paramMap.put("result"       , result);
					paramMap.put("fileStr"      , "");
					paramMap.put("log"          , (log ==null) ? "" : log);
					paramMap.put("ccReceiverStr", "");
					
					// 여기서 DB INSERT 하면 됨.
					sendResult = commonMailService.tsys996InsertMail(paramMap);
					Log.Debug("callMailAppl send result code : " + sendResult);
					if (sendResult > 0) {
						successCnt = successCnt + 1;
					}
					
					sendCnt = sendCnt + 1;
				}
				
				if( sendCnt == successCnt ) {
					result = "메일 발송 성공!";
				} else {
					result = "메일 발송 실패![" + (sendCnt - successCnt) + "건 발송 실패]";
				}
				mv.addObject("result", result);
			}
		}
		return mv;
	}

}