package com.hr.common.springSession;

import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import javax.inject.Named;
import java.io.*;
import java.sql.Blob;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Spring Session JDBC 기반 세션 관리자
 * 사용자의 로그인 세션을 데이터베이스에 저장하고 관리하는 클래스
 */
@Component("springSessionJdbcManager")
public class SpringSessionJdbcManager implements SessionManager {

    @Inject
    @Named("Dao")
    private Dao dao;

    /**
     * 회사코드와 사번으로 해당 사용자의 모든 세션 ID를 조회
     * 세션 데이터를 직렬화하여 데이터베이스에서 검색
     * 
     * @param paramMap 조회 조건 (ssnEnterCd: 회사코드, ssnSabun: 사번)
     * @return 세션 ID 목록
     */
    @Override
    @Transactional(readOnly = true)
    public List<String> getSessionIdsByEnterCdSabun(Map<?, ?> paramMap) throws Exception {
        Log.Debug();
        String ssnEnterCd = paramMap.get("ssnEnterCd").toString();
        String ssnSabun = paramMap.get("ssnSabun").toString();

        String serializedEnterCd = serializeToHex(ssnEnterCd);
        String serializedSabun = serializeToHex(ssnSabun);

        Map<String, Object> convertParams = new HashMap<>();
        convertParams.put("serializedEnterCd", serializedEnterCd);
        convertParams.put("serializedSabun", serializedSabun);

        // Dao.getList()가 Collection<?>을 반환하므로, List<String>으로 변환
        Collection<?> result = dao.getList("getSessionIdsByEnterCdSabun", convertParams);
        
        // Collection을 List<String>으로 변환
        if (result instanceof List) {
            List<?> resultList = (List<?>) result;
            if (!resultList.isEmpty()) {
                if (resultList.get(0) instanceof Map) {
                    // 결과가 Map 형태로 온 경우
                    return resultList.stream()
                        .map(item -> ((Map<?, ?>) item).get("SESSION_ID").toString())
                        .collect(Collectors.toList());
                } else {
                    // 결과가 직접 String으로 온 경우
                    return resultList.stream()
                        .map(Object::toString)
                        .collect(Collectors.toList());
                }
            }
        }
        
        return new ArrayList<>(); // 결과가 없는 경우 빈 리스트 반환
    }

    /**
     * 세션 ID로 해당 세션의 사용자 정보를 조회
     * SPRING_SESSION_ATTRIBUTES 테이블에서 세션 데이터를 조회하고 역직렬화하여 반환
     * 
     * @param paramMap 조회 조건 (sessionId: 세션 ID)
     * @return 세션에 저장된 속성 맵
     */
    @Override
    @Transactional(readOnly = true)
    public Map<?, ?> getSessionDataBySessionId(Map<String, Object> paramMap) throws Exception {
        Map<String, String> attributes = new HashMap<>();

        Map<String, String> primaryIdMap = (Map<String, String>) dao.getMap("getPrimaryIdBySessionId", paramMap);

        if(primaryIdMap != null && !primaryIdMap.isEmpty()) {
            String primaryId = primaryIdMap.get("primaryId");
            paramMap.put("primaryId", primaryId);

            List<Map<String, Object>> sessionData = (List<Map<String, Object>>) dao.getList("getSessionDataBySessionId", paramMap);
            for (Map<String, Object> attributeBytes : sessionData) {
                Object blobObj = attributeBytes.get("attributeBytes");

                byte[] bytes;
                if (blobObj instanceof Blob) {
                    bytes = blobToBytes((Blob) blobObj);
                } else {
                    bytes = (byte[]) blobObj;
                }

                if (bytes != null) {
                    String value = deserialize(bytes);
                    attributes.put(attributeBytes.get("attributeName").toString(), value);
                }
            }
        }

        return attributes;
    }

    /**
     * 특정 세션을 무효화
     * SPRING_SESSION 테이블에서 해당 세션 정보를 삭제
     * 
     * @param paramMap 무효화할 세션 정보 (sessionId: 세션 ID)
     * @return 삭제된 세션 수
     */
    @Override
    @Transactional
    public int invalidateSession(Map<?, ?> paramMap) throws Exception {
        return dao.delete("invalidateSession", paramMap);
    }

    /**
     * 현재 세션을 제외한 특정 사용자의 모든 세션을 무효화
     * 중복 로그인 방지를 위해 사용
     * 
     * @param paramMap 무효화 조건 (currentSessionId: 현재 세션 ID, ssnEnterCd: 회사코드, ssnSabun: 사번)
     * @return 무효화된 세션 수
     */
    @Override
    @Transactional
    public int invalidateSessionsExcludeCurrent(Map<?, ?> paramMap) throws Exception {
        String ssnEnterCd = paramMap.get("ssnEnterCd").toString();
        String ssnSabun = paramMap.get("ssnSabun").toString();

        String serializedEnterCd = serializeToHex(ssnEnterCd);
        String serializedSabun = serializeToHex(ssnSabun);

        Map<String, Object> convertParams = new HashMap<>();
        convertParams.put("currentSessionId", paramMap.get("currentSessionId"));
        convertParams.put("serializedEnterCd", serializedEnterCd);
        convertParams.put("serializedSabun", serializedSabun);

        return dao.delete("invalidateSessionsExcludeCurrent", convertParams);
    }

    /**
     * 새로운 세션 정보를 저장
     * Spring Session에서는 자동으로 처리되므로 별도 구현이 불필요
     */
    @Override
    public void setSession(String sessionId, String enterCd, String sabun) {
        // Spring Session에서는 별도 구현 불필요
    }

    /**
     * Blob 타입의 데이터를 byte 배열로 변환
     * 
     * @param blob 변환할 Blob 객체
     * @return byte 배열
     */
    private byte[] blobToBytes(Blob blob) throws Exception {
        if (blob == null) return null;
        try (InputStream inputStream = blob.getBinaryStream()) {
            byte[] bytes = new byte[(int) blob.length()];
            inputStream.read(bytes);
            return bytes;
        }
    }

    /**
     * byte 배열을 객체로 역직렬화
     * 
     * @param bytes 역직렬화할 byte 배열
     * @return 역직렬화된 문자열
     */
    private String deserialize(byte[] bytes) {
        try (ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
             ObjectInputStream ois = new ObjectInputStream(bis)) {
            return (String) ois.readObject();
        } catch (Exception e) {
            throw new RuntimeException("역직렬화 실패", e);
        }
    }

    /**
     * 객체를 16진수 문자열로 직렬화
     * 
     * @param obj 직렬화할 객체
     * @return 16진수 문자열
     */
    private String serializeToHex(Object obj) {
        try {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            ObjectOutputStream out = new ObjectOutputStream(bos);
            out.writeObject(obj);
            out.flush();
            return bytesToHex(bos.toByteArray());
        } catch (Exception e) {
            throw new RuntimeException("Serialization failed", e);
        }
    }

    /**
     * byte 배열을 16진수 문자열로 변환
     * 
     * @param bytes 변환할 byte 배열
     * @return 16진수 문자열
     */
    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }
} 