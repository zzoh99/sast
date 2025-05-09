package com.hr.common.springSession;

import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.session.Session;
import org.springframework.session.SessionRepository;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Spring Session Redis 기반 세션 관리자
 */
@Component("springSessionRedisManager")
public class SpringSessionRedisManager implements SessionManager {

    @Autowired(required = false)
    private SessionRepository<? extends Session> sessionRepository;

    @Autowired(required = false)
    private RedisTemplate<String, Object> redisTemplate;

    private static final String USER_SESSIONS_KEY_PREFIX = "ehr-session:index:session:";
    
    /** 세션 값 구분자 */
    private static final String SESSION_DELIMITER = "|";

    /**
     * 회사코드와 사번으로 해당 사용자의 모든 세션 ID를 조회
     * 
     * @param paramMap 조회 조건 (ssnEnterCd: 회사코드, ssnSabun: 사번)
     * @return 세션 ID 목록
     */
    @Override
    public List<String> getSessionIdsByEnterCdSabun(Map<?, ?> paramMap) {
        Log.Debug();

        String ssnEnterCd = String.valueOf(paramMap.get("ssnEnterCd"));
        String ssnSabun = String.valueOf(paramMap.get("ssnSabun"));

        try {
            String userKey = USER_SESSIONS_KEY_PREFIX + ssnEnterCd + SESSION_DELIMITER + ssnSabun;
            Set<Object> sessionIds = redisTemplate.opsForSet().members(userKey);
            
            if (sessionIds != null) {
                List<String> result = new ArrayList<>();
                for (Object sessionId : sessionIds) {
                    // 세션이 실제로 존재하는지 확인
                    if (sessionRepository.findById(sessionId.toString()) != null) {
                        result.add(sessionId.toString());
                    } else {
                        // 세션이 없다면 인덱스에서도 제거
                        redisTemplate.opsForSet().remove(userKey, sessionId);
                    }
                }
                return result;
            }
            return new ArrayList<>();
        } catch (Exception e) {
            Log.Error("Failed getSessionIdsByEnterCdSabun "+ e);
            return new ArrayList<>();
        }
    }

    /**
     * 세션 ID로 해당 세션의 사용자 정보를 조회
     * 
     * @param paramMap 조회 조건 (sessionId: 세션 ID)
     * @return 세션에 저장된 속성 맵
     */
    @Override
    public Map<?, ?> getSessionDataBySessionId(Map<String, Object> paramMap) {
        String sessionId = String.valueOf(paramMap.get("sessionId"));
        Map<String, Object> attributes = new HashMap<>();

        try {
            Session session = sessionRepository.findById(sessionId);
            if (session != null) {
                for (String attributeName : session.getAttributeNames()) {
                    attributes.put(attributeName, session.getAttribute(attributeName));
                }
                Log.Debug("Session data retrieved for: " + sessionId);
            } else {
                Log.Debug("Session not found: " + sessionId);
            }
        } catch (Exception e) {
            Log.Error("Failed to get session data for: " + e);
        }

        return attributes;
    }

    /**
     * 특정 세션을 무효화
     * 
     * @param paramMap 무효화할 세션 정보 (sessionId: 세션 ID)
     * @return 삭제된 세션 수
     */
    @Override
    public int invalidateSession(Map<?, ?> paramMap) {
        String sessionId = String.valueOf(paramMap.get("sessionId"));
        try {
            Session session = sessionRepository.findById(sessionId);
            if (session != null) {
                String enterCd = String.valueOf(session.getAttribute("ssnEnterCd"));
                String sabun = String.valueOf(session.getAttribute("ssnSabun"));
                
                String userKey = USER_SESSIONS_KEY_PREFIX + enterCd + SESSION_DELIMITER + sabun;
                redisTemplate.opsForSet().remove(userKey, sessionId);
            }
            sessionRepository.deleteById(sessionId);
            return 1;
        } catch (Exception e) {
            Log.Error("Failed to invalidate session: " + e);
        }

        return 0;
    }

    /**
     * 현재 세션을 제외한 특정 사용자의 모든 세션을 무효화
     */
    @Override
    public int invalidateSessionsExcludeCurrent(Map<?, ?> paramMap) {
        String currentSessionId = String.valueOf(paramMap.get("currentSessionId"));
        String ssnEnterCd = String.valueOf(paramMap.get("ssnEnterCd"));
        String ssnSabun = String.valueOf(paramMap.get("ssnSabun"));

        int count = 0;
        try {
            String userKey = USER_SESSIONS_KEY_PREFIX + ssnEnterCd + SESSION_DELIMITER + ssnSabun;
            Set<Object> sessionIds = redisTemplate.opsForSet().members(userKey);
            
            if (sessionIds != null) {
                for (Object sessionId : sessionIds) {
                    String sid = sessionId.toString();
                    if (!sid.equals(currentSessionId)) {
                        redisTemplate.opsForSet().remove(userKey, sid);
                        sessionRepository.deleteById(sid);
                        count++;
                        Log.Debug("Invalidated session: " + sid);
                    }
                }
            }
        } catch (Exception e) {
            Log.Error("Failed to invalidate sessions" + e);
        }

        return count;
    }

    /**
     * 새로운 세션 정보를 저장하고 인덱스 생성
     */
    @Override
    public void setSession(String sessionId, String enterCd, String sabun) {
        try {
            String userKey = USER_SESSIONS_KEY_PREFIX + enterCd + SESSION_DELIMITER + sabun;
            redisTemplate.opsForSet().add(userKey, sessionId);
            Log.Debug("Session indexed for user: " + enterCd + SESSION_DELIMITER + sabun);
        } catch (Exception e) {
            Log.Error("Failed to set session index for: " + e);
        }
    }
} 