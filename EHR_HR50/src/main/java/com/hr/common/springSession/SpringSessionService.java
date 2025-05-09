package com.hr.common.springSession;

import com.hr.common.util.springSession.SpringSessionResolver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 세션 관리 서비스
 * 세션 관리 모드(memory/spring-session-jdbc)에 따라 적절한 SessionManager를 사용
 */
@Primary // core에서 사용하는 세션 관리 서비스
@Service("SpringSessionService")
public class SpringSessionService implements SpringSessionResolver {

	@Value("${session.manager.type}")
	private String sessionManagerType;

	@Autowired
	@Qualifier("memorySessionManager")
	private SessionManager memorySession;

	@Autowired(required = false)
	@Qualifier("springSessionJdbcManager")
	private SessionManager springSessionJdbc;

	@Autowired(required = false)
	@Qualifier("springSessionRedisManager")
	private SessionManager springSessionRedis;

	/**
	 * 세션 매니저 타입에 따른 세션 매니저 반환
	 * sessionManagerType에 따라 관리 모드에 일치하는 세션 매니저 리턴
	 */
	private SessionManager getSessionManager() {
		if ("memory".equalsIgnoreCase(sessionManagerType)) {
			return memorySession;
		} else if ("spring-session-jdbc".equalsIgnoreCase(sessionManagerType)) {
			return springSessionJdbc;
		} else if ("spring-session-redis".equalsIgnoreCase(sessionManagerType)) {
			return springSessionRedis;
		}
		return null;
	}

	/**
	 * 세션 목록 다건 조회 Service
	 */
	@Override
	public List<String> getSessionIdsByEnterCdSabun(Map<?, ?> paramMap) throws Exception {
		return getSessionManager().getSessionIdsByEnterCdSabun(paramMap);
	}

	/**
	 * 세션 정보 단건 조회 Service
	 */
	@Override
	public Map<?, ?> getSessionDataBySessionId(Map<String, Object> paramMap) throws Exception {
		return getSessionManager().getSessionDataBySessionId(paramMap);
	}

	/**
	 * 세션 무효화 처리 Service
	 */
	@Override
	public int invalidateSession(Map<?, ?> paramMap) throws Exception {
		return getSessionManager().invalidateSession(paramMap);
	}

	/**
	 * 현재 세션을 제외한 세션 무효화 처리 Service
	 */
	@Override
	public int invalidateSessionsExcludeCurrent(Map<?, ?> paramMap) throws Exception {
		return getSessionManager().invalidateSessionsExcludeCurrent(paramMap);
	}

	/**
	 * 세션 정보 설정 Service
	 */
	@Override
	public void setSession(String sessionId, String enterCd, String sabun) {
		if ("memory".equalsIgnoreCase(sessionManagerType)) {
			memorySession.setSession(sessionId, enterCd, sabun);
		} else if ("spring-session-jdbc".equalsIgnoreCase(sessionManagerType)) {
			springSessionJdbc.setSession(sessionId, enterCd, sabun);
		} else if ("spring-session-redis".equalsIgnoreCase(sessionManagerType)) {
			springSessionRedis.setSession(sessionId, enterCd, sabun);
		}
	}
}
