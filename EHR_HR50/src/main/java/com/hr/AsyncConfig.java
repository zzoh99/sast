package com.hr;

import java.util.concurrent.Executor;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurerSupport;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

/**
 * <pre>
 * com.isu.ifm
 * AsyncConfig.java
 * </pre>
 * 설   명 : 비동기 동작이 가능하도록 설정한다.
 * 작성자 : jdshin
 * 날   짜 : 2022. 5. 10.
 * 이   력
 * [최초생성] 2022. 5. 10., jdshin
 *
 * @param val
 * @return
 */
@Configuration
@EnableAsync
public class AsyncConfig extends AsyncConfigurerSupport {
	
	@Override
	public Executor getAsyncExecutor() {
		ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
		executor.setCorePoolSize(2);
		executor.setMaxPoolSize(10);
		executor.setQueueCapacity(500);
        executor.setThreadNamePrefix("push-async-");
        executor.initialize();
        return executor;
	}
}
