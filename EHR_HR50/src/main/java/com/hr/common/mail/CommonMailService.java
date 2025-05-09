package com.hr.common.mail;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import javax.inject.Named;
import java.util.List;
import java.util.Map;

/**
 * 메일 전송 공통 서비스
 *
 */
@Service("CommonMailService")
public class CommonMailService{

	@Inject
	@Named("Dao")
	private Dao dao;

	@Inject
	@Named("OtherService")
	private OtherService otherService;
	
	/** SMTP URL */
	@Value("${mail.server}")
	private String mailServer;
	/** SMTP USER */
	@Value("${mail.user}")
	private String mailUser;
	/** SMTP Password */
	@Value("${mail.passwd}")
	private String mailPasswd;
	/** tester email */
	@Value("${mail.tester}")
	private String mailTester;
	/** Sendder name */
	@Value("${mail.sender}")
	private String mailSender;

	/**
	 *   메일  서식 List Combo 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> mailContent(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("mailContent", paramMap);
	}

	/**
	 * 지정 사번의 메일 정보 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public Map<?, ?> getMailId(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMailId", paramMap);
	}

	/**
	 * 메일  서식 조회 OnayOne Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	/* 20240718 jyp 사용안함
	public Map<?, ?> mailContentOnlyOne(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("mailContentOnlyOne", paramMap);
	}

	 */

	/**
	 * applSeq 에서 Sabun 가져오기  Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> mailAppSendSabun(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("mailAppSendSabun", paramMap);
	}

	/**
	 *   개인정보 변경 신청시 알람받을 사람 리스트 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> getEmpInfoChangeMailMgrList(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("getEmpInfoChangeMailMgrList", paramMap);
	}

	/**
	 *   사번으로 보내는 사람 메일조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> mailSendSabunFromInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("mailSendSabunFromInfo", paramMap);
	}

	/**
	 *   사번으로 보낼사람 메일조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> mailSendSabunToInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("mailSendSabunToInfo", paramMap);
	}
	
	/**
	 *   사번으로 보낼사람 SMS 조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> smsSendSabunToInfo(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("smsSendSabunToInfo", paramMap);
	}

	/**
	 * 메일 결과 저장 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int tsys996InsertMail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt = dao.update("tsys996InsertMail", paramMap);
		if( cnt > 0 ) {
			dao.updateClob("tsys996UpdateMail", paramMap);
		}
		return cnt;
	}

	/**
	 * 메일 결과 수정 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public int tsys996UpdateMail(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.updateClob("tsys996UpdateMail", paramMap);
	}
	
	/**
	 * API 로그 등록
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int tsys992Insert(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		int cnt =0;
		cnt = dao.update("tsys992InsertMail", paramMap);
		dao.updateClob("tsys992UpdateMail", paramMap);
		return cnt;
	}
	
	/**
	 *   사번으로 보낼사람 메일조회 Service
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public List<?> mailSendSabunWithCc(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return (List<?>)dao.getList("mailSendSabunWithCc", paramMap);
	}
	
	/**
	 *  메일전송 관련 설정 데이터 조회
	 *
	 * @param paramMap
	 * @return List
	 * @throws Exception
	 */
	public Map<?, ?> mailStdMap(Map<?, ?> paramMap) throws Exception {
		Log.Debug();
		return dao.getMap("getMailStdCdValue", paramMap);
	}
}