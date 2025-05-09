package com.hr.api.common.wrapper;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.api.common.filter.Api50Filter;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

// api 패키지만 적용 (모바일,셀프서비스)
@ControllerAdvice(basePackages = "com.hr.api")
public class Api50ResponseBodyAdvice implements ResponseBodyAdvice<Object> {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private SecurityMgrService securityMgrService;

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return true;
    }

    @Override
    public Object beforeBodyWrite(Object body,
                                  MethodParameter returnType,
                                  MediaType selectedContentType,
                                  Class<? extends HttpMessageConverter<?>> selectedConverterType,
                                  ServerHttpRequest request,
                                  ServerHttpResponse response) {

        try {
            // null 체크
            if (body == null) {
                return null;
            }

            // Map인 경우 처리
            if (body instanceof Map) {
                Map<String, Object> resultMap = (Map<String, Object>) body;

                // 필요한 처리 수행
                return processMap(returnType, request, resultMap);
            }

            // String인 경우 특별 처리 (String은 직접 변환 필요)
            if (body instanceof String) {
                // String을 JSON으로 변환해야 하는 경우
                ObjectMapper mapper = new ObjectMapper();
                return mapper.writeValueAsString(processString((String) body));
            }

            // 다른 타입의 응답 처리
            return processOtherType(body);

        } catch (Exception e) {
            // 에러 처리
            return handleError(e);
        }
    }

    private Map<String, Object> processMap(MethodParameter returnType, ServerHttpRequest request, Map<String, Object> originalMap) {
        Map<String, Object> resultMap = new HashMap<>(originalMap);

        HttpServletRequest servletRequest = null;
        if (request instanceof ServletServerHttpRequest) {
            servletRequest = ((ServletServerHttpRequest) request).getServletRequest();
        }

        HttpSession session = servletRequest.getSession(false);
        String ssnEnterCd = session == null ? null : (String) session.getAttribute("ssnEnterCd");

        if (ssnEnterCd != null) {
            String encKey = Api50Filter.PriKEY;
            ObjectMapper mapper = new ObjectMapper();

            // 컨트롤러 클래스의 전체 이름 가져오기
            String fullClassName = returnType.getContainingClass().getName();

            // 패키지 이름 가져오기
            String packageName = fullClassName.substring(0, fullClassName.lastIndexOf('.'));
            if(packageName.startsWith("com.hr.api.front")) {
                encKey = securityMgrService.getEncryptKey(ssnEnterCd); // front 패키지용 암호화 키
            }

            try {
                JSONObject t = CryptoUtil.cryptoParameter(mapper.writeValueAsString(originalMap), "E", encKey, servletRequest);
                resultMap = mapper.readValue(t.toString(), new TypeReference<Map<String, Object>>() {});
            } catch (JsonProcessingException e) {
                logger.error("MAPPER PARSE FAIL : {}", originalMap);
                throw new RuntimeException(e);
            }
        }

        return resultMap;
    }

    private Object processString(String body) {
        // String 처리 로직
        return body;
    }

    private Object processOtherType(Object body) {
        // 다른 타입 처리 로직
        return body;
    }

    private Object handleError(Exception e) {
        Map<String, Object> errorMap = new HashMap<>();
        errorMap.put("error", e.getMessage());
        return errorMap;
    }
}
