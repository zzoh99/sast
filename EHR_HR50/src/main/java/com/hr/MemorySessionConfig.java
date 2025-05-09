package com.hr;

import org.springframework.context.annotation.Configuration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;

@Configuration
@ConditionalOnProperty(name = "session.manager.type", havingValue = "memory")
public class MemorySessionConfig {
    // Memory 세션 관련 설정이 필요한 경우 여기에 추가
} 