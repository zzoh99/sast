package com.hr.common.util.mail;

//import java.util.Properties;

//import org.springframework.beans.factory.annotation.Value;

import com.hr.common.logger.Log;
import signgate.crypto.util.Debug;

public class SmtpMailUtil {

	private SendMailSMTP mail = null;
	public SmtpMailUtil(String host, String fromEmail) throws Exception{
		//이곳에 발신자 정보 들어간다.
		mail = new SendMailSMTP(host, fromEmail, false, false, false);
	}
	public SmtpMailUtil(String host, String id ,String pwd ,String fromEmail) throws Exception{
		//이곳에 발신자 정보 들어간다.
		mail = new SendMailSMTP(host, id, pwd, fromEmail, false, false, false);
	}
	public SmtpMailUtil(String host, int port, String id ,String pwd ,String fromEmail) throws Exception{
		//이곳에 발신자 정보 들어간다.
		mail = new SendMailSMTP(host, port, id, pwd, fromEmail, false, false, false);
	}
	public SmtpMailUtil(String host, int port, String id ,String pwd ,String fromEmail, boolean plane) throws Exception{
		//이곳에 발신자 정보 들어간다.
		mail = new SendMailSMTP(host, port, id, pwd, fromEmail, plane, false, false);
	}
	public SmtpMailUtil(String host, int port, String id ,String pwd ,String fromEmail, boolean plane, boolean attach) throws Exception{
		//이곳에 발신자 정보 들어간다.
		mail = new SendMailSMTP(host, port, id, pwd, fromEmail, plane, attach, false);
	}
	public SmtpMailUtil(String host, int port, String id ,String pwd ,String fromEmail, boolean plane, boolean attach, boolean debug) throws Exception{
		//이곳에 발신자 정보 들어간다.
		mail = new SendMailSMTP(host, port, id, pwd, fromEmail, plane, attach, debug);
	}

	public SmtpMailUtil(String host, int port, String fromEmail, boolean plane, boolean attach, boolean debug) throws Exception{
		//이곳에 발신자 정보 들어간다.
		mail = new SendMailSMTP(host, port, fromEmail, plane, attach, debug);
	}

	public String sendEmail(String formName ,String mailTitle, String[] mailTo, String content, String[] attachFiles, String mailTester) throws Exception{
		String result = "N";
		try{
			Debug.log("1>>"+  formName +"||"+ mailTitle +"||"+ mailTo +"||"+ content +"||"+ attachFiles +"||"+ mailTester);
			//발송자 정보
			if (formName != null) {
				mail.setFromName(formName);
			}

			//메일 제목 세팅
			mail.setTitle(mailTitle);

			//파일 추가
			if (attachFiles != null) {
				for(int i = 0; i < attachFiles.length; i++){
					mail.setAttach(attachFiles[i]);
				}
			}

			//메일 본문 세팅
			mail.setContents(content);

			//수신자 초기화.
			mail.clearTo();

			//수신자 세팅
			if (mailTo != null) {
				for(int i = 0; i < mailTo.length; i++){
					if( "".equals(mailTester) ) { mail.addTo(mailTo[i]) ; }
					else { mail.addTo(mailTester) ; } ;

				}
			}
			//메일 발송
			mail.send();

			result = "Y";
		}catch(Exception e){
			Log.Error(e.toString());
			throw e;
		}

		return result;

	}

	public String sendEmail(String formName ,String mailTitle, String mailTo, String content , String[] attachFiles, String mailTester) throws Exception{
		String result = "N";
		try{
			Debug.log("2>>"+ formName +"||"+ mailTitle +"||"+ mailTo +"||"+ content +"||"+ attachFiles +"||"+ mailTester);
			//발송자 정보
			if (formName != null) {
				mail.setFromName(formName);
			}

			//메일 제목 세팅
			mail.setTitle(mailTitle);

			//파일 추가
			if (attachFiles != null) {
				for(int i = 0; i < attachFiles.length; i++){
					mail.setAttach(attachFiles[i]);
				}
			}

			//메일 본문 세팅
			mail.setContents(content);

			//수신자 초기화.
			mail.clearTo();

			//수신자 세팅
			if(mailTester == null || "".equals(mailTester) ) { mail.addTo(mailTo) ; }
			else { mail.addTo(mailTester) ; } ;

			//메일 발송
			mail.send();

			result = "Y";
		}catch(Exception e){
			Log.Error(e.toString() );
			throw e;
		}

		return result;

	}

}
