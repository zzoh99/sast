package com.hr;

import java.util.HashMap;
import java.util.Map;

import com.hr.common.logger.Log;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

/**
 * <pre>
 * com.isu.ifm
 * AsyncService.java
 * </pre>
 * 설   명 : 비동기 처리를 수행하는 서비스
 * 작성자 : jdshin
 * 날   짜 : 2022. 5. 10.
 * 이   력
 * [최초생성] 2022. 5. 10., jdshin
 *
 * @param val
 * @return
 */
@Service
public class AsyncService {
	/**
	 * <pre>
	 * push
	 * </pre>
	 * 설   명 : 알림메시지를 푸시한다.
	 * 작성자 : jdshin
	 * 날   짜 : 2022. 5. 10.
	 * 이   력
	 * [최초생성] 2022. 5. 10., jdshin
	 *
	 * @param val
	 * @return
	 */
	@Async
	public void push(String url, Map<String, Object> paramMap) throws InterruptedException {
		RestTemplate restTemplate = new RestTemplate();
		Map<String, Object> responseMap = new HashMap<>();
		restTemplate.postForEntity(url, paramMap, responseMap.getClass(), new Object[0]);
		Thread.sleep(1000L);
		Log.Info("pushAsync-in");
	}
}
