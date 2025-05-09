/**
 * 
 */
package com.hr.common.util.mail;


/**
 * @author mir1115
 *
 */
public class SMTPAuthenticator extends javax.mail.Authenticator {
    private String id;
    private String pw;

	//private static final Logger logger =     Logger.getLogger(SMTPAuthenticator.class.getName());
    public SMTPAuthenticator(String id, String pw) {
        this.id = id;
        this.pw = pw;

    }
    protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
        return new javax.mail.PasswordAuthentication(id, pw);		
    }
}

