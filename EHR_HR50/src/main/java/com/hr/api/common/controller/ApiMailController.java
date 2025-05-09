package com.hr.api.common.controller;

import com.hr.common.logger.Log;
import com.hr.common.mail.CommonMailService;
import com.hr.common.other.OtherService;
import com.hr.common.util.StringUtil;
import com.hr.common.util.mail.SmtpMailUtil;
import com.hr.sys.other.noticeTemplateMgr.NoticeCommonConstants;
import com.hr.sys.other.noticeTemplateMgr.NoticeTemplateMgrService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5/mail")
public class ApiMailController {

    @Inject
    @Named("CommonMailService")
    private CommonMailService commonMailService;

    @Inject
    @Named("OtherService")
    private OtherService otherService;

    /** 알림서식관리 Service */
    @Inject
    @Named("NoticeTemplateMgrService")
    private NoticeTemplateMgrService noticeTemplateMgrService;

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

    /**
     * 결제요청 알림메일
     * @param session
     * @param request
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/callMailAppl")
    public Map<String, Object> callMailAppl(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {

        String Message = "";
        String bizCd = NoticeCommonConstants.BIZ.APP_REQ.name();
        String uri    = request.getRequestURL().toString().replace(request.getRequestURI(), "");

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("enterCd"   , session.getAttribute("ssnEnterCd"));
        paramMap.put("bizCd"     , bizCd);
        paramMap.put("seqId"     , "MAIL");
        // paramMap.put("mailSeq",(otherService.getSequence(paramMap)).get("getSeq").toString());

        Map<String, Object> result = new HashMap<>();

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
            Message = "메일발송이 필요없는 결재입니다.";
            result.put("Message", Message);
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
                Message = "보내는 메일주소가 없습니다.";
                result.put("Code", "-1");
                result.put("Message", Message);

            } else if (sendMailInfo.get("sendMail") == null || "".equals(sendMailInfo.get("sendMail"))
                    || sendMailInfo.get("sendName") == null || "".equals(sendMailInfo.get("sendName"))) {
                Message = "보내는 메일주소가 없습니다.";
                result.put("Code", "-1");
                result.put("Message", Message);

            } else if (templateCont == null) {
                Message = "메일 서식 데이타가 없습니다.";
                result.put("Code", "-1");
                result.put("Message", Message);

            } else if (templateCont.get("useYn").toString().equals("N")) {
                Message = "알림서식의 메일 사용여부가 설정되지 않았습니다. \n관리자에게 문의하세요.";
                result.put("Code", "-1");
                result.put("Message", Message);
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
                            Message = mUtil.sendEmail(sender, mailTitle, receiverStr, mailContent, null, MAIL_TESTER);
                        } catch (Exception e) {
                            log = e.getMessage();
                            Message = "N";
                        }
                    } else {
                        Message = "N";
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
                    Message = "메일 발송 성공!";
                } else {
                    Message = "메일 발송 실패![" + (sendCnt - successCnt) + "건 발송 실패]";
                }
                result.put("Message", Message);
            }
        }
        return result;
    }

}
