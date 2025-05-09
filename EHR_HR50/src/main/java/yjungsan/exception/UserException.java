package yjungsan.exception;

/**
 * 사용자 Exception
 * @author kbc
 *
 */
public class UserException extends Exception {

	private static final long serialVersionUID = -6593854463902863651L;
	
	public UserException(String msg) {
		super(msg);
	}
}
