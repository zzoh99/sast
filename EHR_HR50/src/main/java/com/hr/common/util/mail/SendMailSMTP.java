package com.hr.common.util.mail;

import com.hr.common.util.classPath.ClassPathUtils;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.StringTokenizer;
import java.util.Vector;
/**
 * @author Mir
 *
 * <br>메일 보내는 클래스. mail.jar, activation.jar 있어야 함.<br>
 * <br>C#과 다르게 생성자에 attach 유무, debug 메세지 출력 여부가 있어야 한다.
 * <br>기본 인코딩은 UTF-8, text/html;charset=UTF-8로 고정되어 있음.
 * <br>생성자 인증이 필요 없을 땐 : host, [port,] 보내는이메일, [받는이메일, ] 일반텍스트여부(false면 html형식), 파일첨부여부, 디버그여부.<br>
 * <br>생성자 인증이 필요 할 때는 : host, [port,] id, pw, 보내는이메일, [받는이메일, ] 일반텍스트여부(false면 html형식), 파일첨부여부, 디버그여부.<br>
 */
public class SendMailSMTP {
	/*
	   //set up the default parameters.
	   Properties props = new Properties();
	   props.put("mail.transport.protocol", "smtp");
	   props.put("mail.smtp.host", "127.0.0.1");
	   props.put("mail.smtp.port", "25");
	*/
	private String str_from = "";
	private String str_from_name = "";
	private Vector<String> vt_replyTo = null;
	private Vector<String> vt_to = null;
	private Vector<String> vt_cc = null;
	private Vector<String> vt_bcc = null;
	private Properties props = System.getProperties();
	private Session session = null;
	private MimeMessage message = null;
	private String str_contentType = "text/html;charset=UTF-8";
	private boolean boo_contents_type_plane = true; // true : text, false : html
	private boolean boo_attach = false; // true : 파일 첨부
	private Multipart multipart = null;

	private String attachCharset;

	private ResourceBundle rb = null;

	public void setAttachCharset() {
		this.rb = ResourceBundle.getBundle(ClassPathUtils.getOptiPropertiesPath());

		// mail.attach.charset 프로퍼티값 대입, 만약 해당 프로퍼티가 없거나 null일 경우 'UTF-8'을 기본값으로 설정
		if (rb.containsKey("mail.attach.charset")) {
			this.attachCharset = rb.getString("mail.attach.charset");
		} else {
			this.attachCharset = "UTF-8";
		}
	}

	public SendMailSMTP() throws Exception {
		setAttachCharset();
	} // end constructor

	/**
	 * SendMailSMTP : html 방식일 때 contents type 은 "text/html;charset=UTF-8" 이 기본
	 * @param host smtp서버 주소
	 * @param from 보내는 사람 메일주소
	 * @param plane text여부. true면 일반 txt로, false면 html로
	 * @param attach 파일 첨부 여부 true/false
	 * @param debug debug출력 여부 true/false
	 * @throws Exception
	 */
	public SendMailSMTP(String host, String from, boolean plane, boolean attach, boolean debug) throws Exception {
		// To see what is going on behind the scene
		props.put("mail.debug", ""+debug+"");
		// SMTP host property 정의
		props.put("mail.smtp.host", host);
		this.str_from = from;
	    // session 얻기
		this.session = Session.getInstance(this.props,null);
		// 새로운  message object 생성
		this.message = new MimeMessage(this.session);
		this.boo_contents_type_plane = plane;
		this.boo_attach = attach;
		if (this.boo_attach) this.multipart = new MimeMultipart();

		setAttachCharset();
	} // end constructor

	/**
	 * SendMailSMTP : html 방식일 때 contents type 은 "text/html;charset=UTF-8" 이 기본
	 * @param host smtp서버 주소
	 * @param port smtp서버 port
	 * @param from 보내는 사람 메일주소
	 * @param plane text여부. true면 일반 txt로, false면 html로
	 * @param attach 파일 첨부 여부 true/false
	 * @param debug debug출력 여부 true/false
	 * @throws Exception
	 */
	public SendMailSMTP(String host, int port, String from, boolean plane, boolean attach, boolean debug) throws Exception {
		// To see what is going on behind the scene
		props.put("mail.debug", ""+debug+"");
		// SMTP host property 정의
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", String.valueOf(port));
		this.str_from = from;
	    // session 얻기
		this.session = Session.getInstance(this.props,null);
		// 새로운  message object 생성
		this.message = new MimeMessage(this.session);
		this.boo_contents_type_plane = plane;
		this.boo_attach = attach;
		if (this.boo_attach) this.multipart = new MimeMultipart();

		setAttachCharset();
	} // end constructor

	/**
	 * SendMailSMTP : html 방식일 때 contents type 은 "text/html;charset=UTF-8" 이 기본
	 * @param host smtp서버 주소
	 * @param id smtp서버 로그인 정보 : id
	 * @param pw smtp서버 로그인 정보 : pw
	 * @param from 보내는 사람 메일주소
	 * @param plane text여부. true면 일반 txt로, false면 html로
	 * @param attach 파일 첨부 여부 true/false
	 * @param debug debug출력 여부 true/false
	 * @throws Exception
	 */
	public SendMailSMTP(String host, String id, String pw, String from, boolean plane, boolean attach, boolean debug) throws Exception {
		// To see what is going on behind the scene
		props.put("mail.debug", ""+debug+"");
		// SMTP host property 정의
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.auth", "true"); // 인증을 요할때 요렇게 해야 함.
		SMTPAuthenticator auth = new SMTPAuthenticator(id, pw);
		this.str_from = from;
	    // session 얻기
		//this.session = Session.getDefaultInstance(this.props, auth);
		this.session = Session.getInstance(this.props, auth);
		// 새로운  message object 생성
		this.message = new MimeMessage(this.session);
		this.boo_contents_type_plane = plane;
		this.boo_attach = attach;
		if (this.boo_attach) this.multipart = new MimeMultipart();

		setAttachCharset();
	} // end constructor

	/**
	 * SendMailSMTP : html 방식일 때 contents type 은 "text/html;charset=UTF-8" 이 기본
	 * @param host smtp서버 주소
	 * @param port smtp서버 port
	 * @param id smtp서버 로그인 정보 : id
	 * @param pw smtp서버 로그인 정보 : pw
	 * @param from 보내는 사람 메일주소
	 * @param plane text여부. true면 일반 txt로, false면 html로
	 * @param attach 파일 첨부 여부 true/false
	 * @param debug debug출력 여부 true/false
	 * @throws Exception
	 */
	public SendMailSMTP(String host, int port, String id, String pw, String from, boolean plane, boolean attach, boolean debug) throws Exception {
		// To see what is going on behind the scene
		props.put("mail.debug", ""+debug+"");
		// SMTP host property 정의
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", String.valueOf(port));
		props.put("mail.smtp.auth", "true"); // 인증을 요할때 요렇게 해야 함.
		SMTPAuthenticator auth = new SMTPAuthenticator(id, pw);
		this.str_from = from;
	    // session 얻기
		//this.session = Session.getDefaultInstance(this.props, auth);
		this.session = Session.getInstance(this.props, auth);
		// 새로운  message object 생성
		this.message = new MimeMessage(this.session);
		this.boo_contents_type_plane = plane;
		this.boo_attach = attach;
		if (this.boo_attach) this.multipart = new MimeMultipart();

		setAttachCharset();
	} // end constructor

	/**
	 * SendMailSMTP : html 방식일 때 contents type 은 "text/html;charset=UTF-8" 이 기본
	 * @param host smtp서버 주소
	 * @param from 보내는 사람 메일주소
	 * @param to 받는 사람 메일주소. 한명일때.
	 * @param plane text여부. true면 일반 txt로, false면 html로
	 * @param attach 파일 첨부 여부 true/false
	 * @param debug debug출력 여부 true/false
	 * @throws Exception
	 */
	public SendMailSMTP(String host, String from, String to, boolean plane, boolean attach, boolean debug) throws Exception {
		// To see what is going on behind the scene
		props.put("mail.debug", ""+debug+"");
		// SMTP host property 정의
		props.put("mail.smtp.host", host);
		this.str_from = from;
		if (vt_to == null) vt_to = new Vector<String>();
		this.vt_to.add(to);
	    // session 얻기
		//this.session = Session.getDefaultInstance(this.props,null);
		this.session = Session.getInstance(this.props,null);
		// 새로운  message object 생성
		this.message = new MimeMessage(this.session);
		this.boo_contents_type_plane = plane;
		this.boo_attach = attach;
		if (this.boo_attach) this.multipart = new MimeMultipart();

		setAttachCharset();
	} // end constructor

	/**
	 * SendMailSMTP : html 방식일 때 contents type 은 "text/html;charset=UTF-8" 이 기본
	 * @param host smtp서버 주소
	 * @param port smtp서버 port
	 * @param from 보내는 사람 메일주소
	 * @param to 받는 사람 메일주소. 한명일때.
	 * @param plane text여부. true면 일반 txt로, false면 html로
	 * @param attach 파일 첨부 여부 true/false
	 * @param debug debug출력 여부 true/false
	 * @throws Exception
	 */
	public SendMailSMTP(String host, int port, String from, String to, boolean plane, boolean attach, boolean debug) throws Exception {
		// To see what is going on behind the scene
		props.put("mail.debug", ""+debug+"");
		// SMTP host property 정의
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", String.valueOf(port));
		this.str_from = from;
		if (vt_to == null) vt_to = new Vector<String>();
		this.vt_to.add(to);
	    // session 얻기
		//this.session = Session.getDefaultInstance(this.props,null);
		this.session = Session.getInstance(this.props,null);
		// 새로운  message object 생성
		this.message = new MimeMessage(this.session);
		this.boo_contents_type_plane = plane;
		this.boo_attach = attach;
		if (this.boo_attach) this.multipart = new MimeMultipart();

		setAttachCharset();
	} // end constructor

	/**
	 * SendMailSMTP : html 방식일 때 contents type 은 "text/html;charset=UTF-8" 이 기본
	 * @param host smtp서버 주소
	 * @param id smtp서버 로그인 정보 : id
	 * @param pw smtp서버 로그인 정보 : pw
	 * @param from 보내는 사람 메일주소
	 * @param to 받는 사람 메일주소. 한명일때.
	 * @param plane text여부. true면 일반 txt로, false면 html로
	 * @param attach 파일 첨부 여부 true/false
	 * @param debug debug출력 여부 true/false
	 * @throws Exception
	 */
	public SendMailSMTP(String host, String id, String pw, String from, String to, boolean plane, boolean attach, boolean debug) throws Exception {
		// To see what is going on behind the scene
		props.put("mail.debug", ""+debug+"");
		// SMTP host property 정의
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.auth", "true"); // 인증을 요할때 요렇게 해야 함.
		SMTPAuthenticator auth = new SMTPAuthenticator(id, pw);
		this.str_from = from;
		if (vt_to == null) vt_to = new Vector<String>();
		this.vt_to.add(to);
	    // session 얻기
		//this.session = Session.getDefaultInstance(this.props, auth);
		this.session = Session.getInstance(this.props, auth);
		// 새로운  message object 생성
		this.message = new MimeMessage(this.session);
		this.boo_contents_type_plane = plane;
		this.boo_attach = attach;
		if (this.boo_attach) this.multipart = new MimeMultipart();

		setAttachCharset();
	} // end constructor

	/**
	 * SendMailSMTP : html 방식일 때 contents type 은 "text/html;charset=UTF-8" 이 기본
	 * @param host smtp서버 주소
	 * @param host smtp서버 port
	 * @param id smtp서버 로그인 정보 : id
	 * @param pw smtp서버 로그인 정보 : pw
	 * @param from 보내는 사람 메일주소
	 * @param to 받는 사람 메일주소. 한명일때.
	 * @param plane text여부. true면 일반 txt로, false면 html로
	 * @param attach 파일 첨부 여부 true/false
	 * @param debug debug출력 여부 true/false
	 * @throws Exception
	 */
	public SendMailSMTP(String host, int port, String id, String pw, String from, String to, boolean plane, boolean attach, boolean debug) throws Exception {
		// To see what is going on behind the scene
		props.put("mail.debug", ""+debug+"");
		// SMTP host property 정의
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", String.valueOf(port));
		props.put("mail.smtp.auth", "true"); // 인증을 요할때 요렇게 해야 함.
		SMTPAuthenticator auth = new SMTPAuthenticator(id, pw);
		this.str_from = from;
		if (vt_to == null) vt_to = new Vector<String>();
		this.vt_to.add(to);
	    // session 얻기
		//this.session = Session.getDefaultInstance(this.props, auth);
		this.session = Session.getInstance(this.props, auth);
		// 새로운  message object 생성
		this.message = new MimeMessage(this.session);
		this.boo_contents_type_plane = plane;
		this.boo_attach = attach;
		if (this.boo_attach) this.multipart = new MimeMultipart();

		setAttachCharset();
	} // end constructor

	/**
	 * 메일 contentType 세팅
	 * @param type 메일 타입. 예: text/html;charset=ksc5601
	 * @throws Exception
	 */
	public void setContentsType(String type) throws Exception {
		this.str_contentType = type;
	}

    /**
	 * 보내는 사람 이름 세팅. 기본은 UTF-8이며 contents type의 charset에 따라 맞춰진다.
	 * 대신 contents type 포맷은 반드시 "text/html;charset=UTF-8" 형식으로 세팅해야 한다.
	 * (= 로 tokenize해서 가져오기 때문)
	 * @param from_name 표시 이름
	 * @throws Exception
	 */
	public void setFromName(String from_name) throws Exception {
		this.str_from_name = from_name;
	}

	/**
	 * 회신 메일 주소 추가. 여러개 세팅 가능. c#은 하나만 세팅 가능.
	 * @param mail_replyTo 회신 메일주소
	 * @throws Exception
	 */
	public void addReplyTo(String mail_replyTo) throws Exception {
		if (vt_replyTo == null) vt_replyTo = new Vector<String>();
		this.vt_replyTo.add(mail_replyTo);
	}

	/**
	 * 받는사람 메일 추가. 여러개 세팅 가능.
	 * @param mail_add 받는사람 메일주소
	 * @throws Exception
	 */
	public void addTo(String mail_add) throws Exception {
		if (vt_to == null) vt_to = new Vector<String>();
		this.vt_to.add(mail_add);
	}

	/**
	 * 받는사람 메일 초기화.
	 * @throws Exception
	 */
	public void clearTo() throws Exception {
		if (vt_to != null && vt_to.size() > 0) {
			vt_to.clear();
		}
	}

	/**
	 * 참조 할 사람 메일 추가. 여러개 세팅 가능.
	 * @param mail_add 참조 할 사람 메일주소
	 * @throws Exception
	 */
	public void addCc(String mail_add) throws Exception {
		if (vt_cc == null) vt_cc = new Vector<String>();
		this.vt_cc.add(mail_add);
	}

	/**
	 * 숨은참조 할 사람 메일 추가. 여러개 세팅 가능.
	 * @param mail_add 참조 할 사람 메일주소
	 * @throws Exception
	 */
	public void addBcc(String mail_add) throws Exception {
		if (vt_bcc == null) vt_bcc = new Vector<String>();
		this.vt_bcc.add(mail_add);
	}


	/**
	 * 메일 제목 세팅. 기본 인코딩은 UTF-8
	 * @param title 메일 제목
	 * @throws Exception
	 */
	public void setTitle(String title) throws Exception {
		this.message.setSubject(title, "UTF-8");
	}

	/**
	 * 메일 제목 세팅
	 * @param title 메일 제목
	 * @param encoding 메일 제목 인코딩
	 * @throws Exception
	 */
	public void setTitle(String title, String encoding) throws Exception {
		this.message.setSubject(title, encoding);
	}

	/**
	 * 메일 본문 세팅
	 * @param contents 메일 본문
	 * @throws Exception
	 */
	public void setContents(String contents) throws Exception {
		if (this.boo_attach) {
			BodyPart messageBodyPart = new MimeBodyPart();
			if (this.boo_contents_type_plane) messageBodyPart.setText(contents);
			else messageBodyPart.setContent(contents, this.str_contentType);
			this.multipart.addBodyPart(messageBodyPart);
		} else {
			if (this.boo_contents_type_plane) this.message.setText(contents);
			else this.message.setContent(contents, this.str_contentType);
		}
	}

	/**
	 * 첨부파일 추가. 여러개 세팅 가능. 파일명 default 인코딩은 UTF-8 로 세팅됨.
	 * @param filePath 첨부파일 경로. 경로 주의해서 넣을것.
	 * @param fileName 첨부파일 이름.
	 * @throws Exception
	 */
	public void setAttach(String filePath, String fileName) throws Exception {
		if (this.boo_attach) {
			BodyPart messageBodyPart = new MimeBodyPart();
			DataSource source = new FileDataSource(filePath + fileName);
			messageBodyPart.setDataHandler(new DataHandler(source));

			if(attachCharset.equalsIgnoreCase("none")) {
				messageBodyPart.setFileName(source.getName());
			} else {
				messageBodyPart.setFileName(MimeUtility.encodeText(fileName, attachCharset, "B"));
			}

			this.multipart.addBodyPart(messageBodyPart);
		}
	}


	/**
	 * 첨부파일 추가. 여러개 세팅 가능. 파일명 인코딩은 UTF-8 로 세팅됨.
	 * @param file 첨부파일 경로. 경로 주의해서 넣을것.
	 * @throws Exception
	 */
	public void setAttach(String file) throws Exception {
		if (this.boo_attach) {
			BodyPart messageBodyPart = new MimeBodyPart();
			DataSource source = new FileDataSource(file);
			messageBodyPart.setDataHandler(new DataHandler(source));
			if(attachCharset.equalsIgnoreCase("none")) {
				messageBodyPart.setFileName(source.getName());
			} else {
				messageBodyPart.setFileName(MimeUtility.encodeText(source.getName(), attachCharset, "B"));
			}
			this.multipart.addBodyPart(messageBodyPart);
		}
	}

	/**
	 * 첨부파일 추가. 여러개 세팅 가능.
	 * @param filePath 첨부파일 경로. 경로 주의해서 넣을것.
	 * @param fileName 첨부파일 이름.
	 * @param encoding 인코딩. 예 : KSC5601.
	 * @throws Exception
	 */
	public void setAttach(String filePath, String fileName, String encoding) throws Exception {
		if (this.boo_attach) {
			BodyPart messageBodyPart = new MimeBodyPart();
			DataSource source = new FileDataSource(filePath + fileName);
			messageBodyPart.setDataHandler(new DataHandler(source));
			messageBodyPart.setFileName(MimeUtility.encodeText(fileName, encoding, "B"));
			this.multipart.addBodyPart(messageBodyPart);
		}
	}

	/**
	 * 메일 발송.
	 * @throws Exception
	 */
	public void send() throws Exception {
		// 보내는 메일 주소 세팅
		InternetAddress from = new InternetAddress();
	    from.setAddress(str_from); // 보내는 사람 주소 세팅
	    if (!"".equals(this.str_from_name)) {
			StringTokenizer stk = new StringTokenizer(this.str_contentType, "=");
			String encoding = "UTF-8";
			if (stk.countTokens() != 1) while (stk.hasMoreTokens()) encoding = stk.nextToken();
	    	from.setPersonal(str_from_name, encoding); // 보내는 사람 이름 세팅
	    }
	    this.message.setFrom(from);

		// 답장 받을 주소 세팅
		if (this.vt_replyTo != null && this.vt_replyTo.size() > 0) {
			InternetAddress[] replyToAddr = new InternetAddress[this.vt_replyTo.size()];
			for (int int_i=0;int_i<this.vt_replyTo.size();int_i++) {
				replyToAddr[int_i] = new InternetAddress((String)this.vt_replyTo.get(int_i));
			} // end for
			this.message.setReplyTo(replyToAddr);
		}

		// 수신 메일 주소 세팅
		if (this.vt_to != null && this.vt_to.size() > 0) {
			InternetAddress[] toAddr = new InternetAddress[this.vt_to.size()];
			for (int int_i=0;int_i<this.vt_to.size();int_i++) {
				toAddr[int_i] = new InternetAddress((String)this.vt_to.get(int_i));
			} // end for
			this.message.setRecipients(Message.RecipientType.TO, toAddr);
		}

		// 참조 메일 주소 세팅
		if (this.vt_cc != null && this.vt_cc.size() > 0) {
			InternetAddress[] ccAddr = new InternetAddress[this.vt_cc.size()];
			for (int int_i=0;int_i<this.vt_cc.size();int_i++) {
				ccAddr[int_i] = new InternetAddress((String)this.vt_cc.get(int_i));
			} // end for
			this.message.setRecipients(Message.RecipientType.CC, ccAddr);
		}


		// 숨은참조 메일 주소 세팅
		if (this.vt_bcc != null && this.vt_bcc.size() > 0) {
			InternetAddress[] bccAddr = new InternetAddress[this.vt_bcc.size()];
			for (int int_i=0;int_i<this.vt_bcc.size();int_i++) {
				bccAddr[int_i] = new InternetAddress((String)this.vt_bcc.get(int_i));
			} // end for
			this.message.setRecipients(Message.RecipientType.BCC, bccAddr);
		}


		// 발송...
		if (this.boo_attach) this.message.setContent(multipart);
		Transport.send(message);
	}

} // end class SendMailSMTP
