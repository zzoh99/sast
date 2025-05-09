package com.hr.common.springSession;

import com.hr.common.logger.Log;
import org.springframework.stereotype.Component;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionListener;
import javax.servlet.http.HttpSessionEvent;
import java.io.Serializable;
import java.util.*;

/**
 * 메모리 기반 세션 관리자
 * 사용자의 로그인 세션을 메모리(Hashtable)에 저장하고 관리하는 클래스
 */
@Component("memorySessionManager")
public class MemorySessionManager implements SessionManager, Serializable, HttpSessionListener {
    private static final long serialVersionUID = -2746011480897844180L;
    
    /** 로그인한 사용자의 세션 정보를 저장하는 Hashtable (Key: sessionId, Value: "enterCd|sabun") */
    private static final Hashtable<String, String> loginUsers = new Hashtable<>();
    
    /** 세션 관련 추가 데이터를 저장하는 Hashtable */
    private static final Hashtable<String, Object> loginSessions = new Hashtable<>();
    
    /** 세션 값 구분자 */
    private static final String SESSION_DELIMITER = "|";

    // 활성화된 전체 세션을 추적하기 위한 Map
    private static final Map<String, HttpSession> activeSessions = new HashMap<>();

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        Log.Debug("♥♥♥ sessionCreated ♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥");
        HttpSession session = se.getSession();
        activeSessions.put(session.getId(), session);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        Log.Debug("♥♥♥ sessionDestroyed ♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥ start");
        HttpSession session = se.getSession();
        String id = session.getId();
        try{
            if("Y".equals((String)session.getAttribute("loginDup"))) {
                //중복 로그인
                Log.Debug("♥♥♥ 중복 로그인");
            } else {
                //로그아웃
                Log.Debug("♥♥♥ 로그아웃");
            }
        }
        catch(IllegalStateException e) {
            Log.Error("♥♥♥ 세션 타임아웃");
        }
        catch(Exception e){
            Log.Error(e.getMessage());
        }
        activeSessions.remove(se.getSession().getId());
    }

    /**
     * 회사코드와 사번으로 해당 사용자의 모든 세션 ID를 조회
     * @param paramMap 조회 조건 (ssnEnterCd: 회사코드, ssnSabun: 사번)
     * @return 세션 ID 목록
     */
    @Override
    public List<String> getSessionIdsByEnterCdSabun(Map<?, ?> paramMap) {
        List<String> result = new ArrayList<>();
        String targetEnterCd = String.valueOf(paramMap.get("ssnEnterCd"));
        String targetSabun = String.valueOf(paramMap.get("ssnSabun"));
        
        loginUsers.forEach((sessionId, value) -> {
            String[] parts = parseSessionValue(value);
            if (isMatchingUser(parts, targetEnterCd, targetSabun)) {
                result.add(sessionId);
            }
        });
        
        return result;
    }

    /**
     * 세션 ID로 해당 세션의 사용자 정보를 조회
     * @param paramMap 조회 조건 (sessionId: 세션 ID)
     * @return 사용자 정보 (ssnEnterCd: 회사코드, ssnSabun: 사번)
     */
    @Override
    public Map<?, ?> getSessionDataBySessionId(Map<String, Object> paramMap) {
        String sessionId = String.valueOf(paramMap.get("sessionId"));
        Map<String, Object> result = new HashMap<>();
        
        if (loginUsers.containsKey(sessionId)) {
            String[] parts = parseSessionValue(loginUsers.get(sessionId));
            if (parts.length == 2) {
                result.put("ssnEnterCd", parts[0]);
                result.put("ssnSabun", parts[1]);
            }
        }
        return result;
    }

    /**
     * 특정 세션을 무효화
     * @param paramMap 무효화할 세션 정보 (sessionId: 세션 ID)
     * @return 처리 결과 (1: 성공, 0: 실패)
     */
    @Override
    public int invalidateSession(Map<?, ?> paramMap) {
        String sessionId = String.valueOf(paramMap.get("sessionId"));
        if (loginUsers.containsKey(sessionId)) {
            removeSessionData(sessionId);
            invalidateHttpSession(sessionId);
            return 1;
        }
        return 0;
    }

    /**
     * 현재 세션을 제외한 특정 사용자의 모든 세션을 무효화
     * 중복 로그인 방지를 위해 사용
     * @param paramMap 무효화 조건 (currentSessionId: 현재 세션 ID, ssnEnterCd: 회사코드, ssnSabun: 사번)
     * @return 무효화된 세션 수
     */
    @Override
    public int invalidateSessionsExcludeCurrent(Map<?, ?> paramMap) {
        String currentSessionId = String.valueOf(paramMap.get("currentSessionId"));
        String targetEnterCd = String.valueOf(paramMap.get("ssnEnterCd"));
        String targetSabun = String.valueOf(paramMap.get("ssnSabun"));
        int count = 0;

        for (Map.Entry<String, String> entry : new HashMap<>(loginUsers).entrySet()) {
            String sessionId = entry.getKey();
            String[] parts = parseSessionValue(entry.getValue());
            
            if (isMatchingUser(parts, targetEnterCd, targetSabun) && !sessionId.equals(currentSessionId)) {
                removeSessionData(sessionId);
                invalidateHttpSession(sessionId);
                count++;
            }
        }
        
        return count;
    }

    /**
     * 새로운 세션 정보를 저장
     * @param sessionId 세션 ID
     * @param enterCd 회사코드
     * @param sabun 사번
     */
    @Override
    public void setSession(String sessionId, String enterCd, String sabun) {
        loginUsers.put(sessionId, createSessionValue(enterCd, sabun));
    }

    /**
     * 저장된 세션 값을 파싱하여 회사코드와 사번으로 분리
     */
    private String[] parseSessionValue(String value) {
        return value.split("\\" + SESSION_DELIMITER);
    }

    /**
     * 회사코드와 사번을 결합하여 세션 값 생성
     */
    private String createSessionValue(String enterCd, String sabun) {
        return enterCd + SESSION_DELIMITER + sabun;
    }

    /**
     * 주어진 회사코드와 사번이 세션 정보와 일치하는지 확인
     */
    private boolean isMatchingUser(String[] parts, String targetEnterCd, String targetSabun) {
        return parts.length == 2 && parts[0].equals(targetEnterCd) && parts[1].equals(targetSabun);
    }

    /**
     * 메모리에서 세션 데이터 제거
     */
    private void removeSessionData(String sessionId) {
        loginUsers.remove(sessionId);
        loginSessions.remove(sessionId);
    }

    /**
     * HttpSession 무효화
     * 전체 HttpSession 중에서 주어진 sessionId와 일치하는 세션을 찾아 무효화
     * 
     * @param sessionId 무효화할 세션 ID
     */
    private void invalidateHttpSession(String sessionId) {
        try {
            HttpSession targetSession = activeSessions.get(sessionId);
            if (targetSession != null) {
                try {
                    targetSession.invalidate();
                    Log.Debug("세션 무효화 성공 - 세션ID: " + sessionId);
                } catch (IllegalStateException e) {
                    Log.Debug("이미 무효화된 세션 - 세션ID: " + sessionId);
                    activeSessions.remove(sessionId);
                }
            }
        } catch (Exception e) {
            Log.Error("세션 무효화 실패 - 세션ID: " + sessionId + ", 에러: " + e.getMessage());
        }
    }
} 