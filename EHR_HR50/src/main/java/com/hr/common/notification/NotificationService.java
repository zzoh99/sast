package com.hr.common.notification;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Service("NotificationService")
public class NotificationService {

	private static final Long DEFAULT_TIMEOUT = 60L * 1000 * 60; // 기본 타임아웃 설정 (1시간)
	private final ConcurrentHashMap<String, SseEmitter> emitters = new ConcurrentHashMap<>();

	@Autowired
	private Dao dao;

	/**
	 * 사용자가 구독을 위해 호출하는 메서드. 구독 아이디는 (회사코드|사번|세션ID 값) 으로 생성된다
	 *
	 * @param enterCd - 회사코드
	 * @param sabun - 사용자 사번
	 * @param jsessionid - session Id
	 * @return SseEmitter - 서버에서 보낸 이벤트 Emitter
	 */
	public SseEmitter subscribe(String enterCd, String sabun, String jsessionid) {
		SseEmitter emitter = createEmitter(enterCd + "|" + sabun+"|"+jsessionid);

		notify(enterCd, sabun, "connect", "connected"); // 503 에러 방지용.
		return emitter;
	}

	/**
	 * 서버의 이벤트를 클라이언트에게 보내는 메서드
	 * 다른 서비스 로직에서 이 메서드를 사용해 데이터를 Object event에 넣고 전송하면 된다.
	 *
	 * @param enterCd - 회사코드
	 * @param sabun 메시지 수신자 사번.
	 * @param eventName - 전송할 이벤트의 이름
	 * @param event  - 전송할 이벤트 객체.
	 */
	public void notify(String enterCd, String sabun, String eventName, Object event) {
		send(enterCd + "|" + sabun, eventName, event);
	}

	/**
	 * 클라이언트에게 메시지 전송
	 *
	 * @param key 메시지 수신자 key (회사코드|사번).
	 * @param eventName - 전송할 이벤트의 이름
	 * @param data - 전송할 데이터.
	 */
	private void send(String key, String eventName, Object data) {
		CompletableFuture.runAsync(() -> {
			// 사번으로 시작하는 키를 필터링하여 SseEmitter 리스트 추출.
			List<SseEmitter> filteredEmitters = emitters.entrySet().stream()
					.filter(entry -> entry.getKey().startsWith(key + "|"))
					.map(Map.Entry::getValue)
					.collect(Collectors.toList());

			for (SseEmitter emitter : filteredEmitters) {
				if (emitter != null) {
					try {
						emitter.send(SseEmitter.event().name(eventName).data(data));
					} catch (IOException exception) {
						emitters.values().remove(emitter);
						emitter.completeWithError(exception);
						Log.Debug("Error " + exception.toString());
					}
				}
			}
		});
	}

	/**
	 * 이벤트 Emitter 생성
	 *
	 * @param id - 구독 ID (회사코드|사번|세션ID 값)
	 * @return SseEmitter - 생성된 이벤트 Emitter.
	 */
	private SseEmitter createEmitter(String id) {
		SseEmitter emitter = new SseEmitter(DEFAULT_TIMEOUT);
		emitters.put(id, emitter);

		// Emitter가 완료될 때(모든 데이터가 성공적으로 전송된 상태) Emitter를 삭제한다.
		emitter.onCompletion(() -> emitters.remove(id));

		// Emitter가 타임아웃 되었을 때(지정된 시간동안 어떠한 이벤트도 전송되지 않았을 때) Emitter를 삭제한다.
		emitter.onTimeout(() -> emitters.remove(id));

		emitter.onError((Throwable t) -> {
			emitters.remove(id);
			Log.Debug("Error occurred for emitter with id " + id + ", Throwable: " + t);
		});

		return emitter;
	}

	/**
	 * 이벤트 Emitter 제거
	 *
	 * @param id - 구독 ID (회사코드|사번|세션ID 값)
	 * @return SseEmitter - 생성된 이벤트 Emitter.
	 */
	public void removeEmitter(String id) {
		List<String> keysToRemove = emitters.keySet().stream()
				.filter(key -> key.equals(id))
				.collect(Collectors.toList());
		for (String key : keysToRemove) {
			emitters.remove(key);
		}
	}

	/**
	 * 새로운 알림 메시지를 DB에 저장한다.
	 * @param paramMap 알림 정보.
	 * @return 정상적으로 데이터가 저장되면 true.
	 */
	public boolean saveNotification(Map<String, Object> paramMap) {
		Log.Debug();
		try {
			return dao.create("saveNotification", paramMap) > 0;
		} catch (Exception e) {
			Log.Debug(e.toString());
			return false;
		}
	}
}
