package com.hr;

import org.springframework.context.annotation.Configuration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.session.jdbc.config.annotation.web.http.EnableJdbcHttpSession;

@Configuration
@ConditionalOnProperty(name = "session.manager.type", havingValue = "spring-session-jdbc")
@EnableJdbcHttpSession
public class SpringSessionJdbcConfig {
    // JDBC 세션 관련 설정이 필요한 경우 여기에 추가
} 