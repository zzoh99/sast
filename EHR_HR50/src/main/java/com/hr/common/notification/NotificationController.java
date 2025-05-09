package com.hr.common.notification;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import javax.servlet.http.HttpSession;
import java.util.Map;

@RestController
@RequestMapping(value="/notification", method=RequestMethod.POST )
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @GetMapping(value = "/subscribe", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribe(HttpSession session) {
        // enterCd|sabun|jsessionid 로 emitter 구독
        String enterCd = session.getAttribute("ssnEnterCd").toString();
        String sabun = session.getAttribute("ssnSabun").toString();
        String jsessionid = session.getAttribute("logingetId").toString();
        return notificationService.subscribe(enterCd, sabun, jsessionid);
    }

    @PostMapping("/send")
    public void send(@RequestParam Map<String, Object> params) {
        String enterCd = params.get("enterCd").toString();
        String sabun = params.get("sabun").toString();
        String eventName = params.get("eventName").toString();
        String message = params.get("message").toString();
        notificationService.notify(enterCd, sabun, eventName, message);
    }
}
