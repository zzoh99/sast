package com.hr.common.springSession;

import com.hr.common.util.springSession.SpringSessionResolver;

/**
 * 세션 관리자 인터페이스
 * Core의 SpringSessionResolver를 상속받아 세션 관리 기능을 정의
 * 메모리 기반 세션과 Spring Session JDBC 기반 세션 모두에서 사용
 */
public interface SessionManager extends SpringSessionResolver {
    // SpringSessionResolver 에 추가하지 않고 추가 메소드 정의가 필요한 경우 선언
} 