package com.hr.sys.other.noticeTemplateMgr;

/**
 * 알림 서식 공통 상수 정의
 * @author P19246
 *
 */
public class NoticeCommonConstants {

	/**
	 * 알림 발송 유형 enum
	 */
	public static enum TYPE {

		/** 메일 */
		MAIL,

		/** SMS */
		SMS,

		/** LMS */
		LMS,

		/** 메신저 */
		MESSENGER;
	}

	/**
	 * 업무 enum
	 */
	public static enum BIZ {

		/** 기본서식 */
		SYS_TMP_00,

		/** 결재요청 */
		APP_REQ,

		/** 사원정보변경승인 */
		CHG_EMP_INFO,

		/** 비밀번호 찾기 */
		FIND_PWD,

		/** 사원정보변경 요청알림 */
		CHG_EMP_INFO_REQ
		;
	}
}
