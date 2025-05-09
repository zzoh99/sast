package com.hr.common.util.securePath;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.apache.commons.io.FilenameUtils;

/**
 * 파일 경로 보안 처리를 위한 유틸리티 클래스
 */
public class SecurePathUtil {
    
    /**
     * 안전한 파일 경로 생성을 위한 유틸리티 함수
     * 경로 탐색 공격(Path Traversal)을 방지하고 안전한 파일 경로를 생성.
     *
     * @param basePath 기본 디렉토리 경로
     * @param components 파일/디렉토리 구성요소들
     * @return 검증되고 정규화된 안전한 경로
     * @throws SecurityException 경로 탐색 공격 시도 감지시 발생
     * @throws IllegalArgumentException 기본 경로가 null이거나 비어있을 경우 발생
     */
    public static Path getSecurePath(String basePath, String... components) {
        if (basePath == null || basePath.trim().isEmpty()) {
            throw new IllegalArgumentException("기본 경로는 null이거나 비어있을 수 없습니다");
        }
        
        // 기본 경로를 정규화하여 상대 경로 등을 처리
        Path base = Paths.get(basePath).normalize();
        Path resolved = base;
        
        if (components != null) {
            for (String component : components) {
                if (component == null) continue;
                
                // 경로 구분자로 분리하여 각각 처리
                String[] parts = component.split("[\\\\/]");
                for (String part : parts) {
                    if (part.trim().isEmpty()) continue;
                    // 각 부분에서 안전한 이름만 추출하여 경로 결합
                    String safeName = FilenameUtils.getName(part);
                    resolved = resolved.resolve(safeName).normalize();
                }
            }
        }
        
        // 최종 경로가 기본 경로 밖으로 나가지 않는지 검증
        if (!resolved.startsWith(base)) {
            throw new SecurityException("경로 탐색 공격 시도가 감지되었습니다");
        }
        
        return resolved;
    }
    
    /**
     * MultipartRequest에서 안전한 파일 경로 생성
     * 
     * @param basePath 기본 디렉토리 경로
     * @param fileName 파일명
     * @return 검증되고 정규화된 안전한 경로
     * @throws SecurityException 경로 탐색 공격 시도 감지시 발생
     * @throws IllegalArgumentException 기본 경로가 null이거나 비어있을 경우 발생
     */
    public static Path getSecureMultipartPath(String basePath, String fileName) {
        return getSecurePath(basePath, fileName);
    }
    
    /**
     * 파일 확장자 검증
     * 
     * @param fileName 검증할 파일명
     * @param allowedExtensions 허용된 확장자 배열
     * @return 허용된 확장자인 경우 true, 아닌 경우 false
     */
    public static boolean isAllowedFileExtension(String fileName, String[] allowedExtensions) {
        if (fileName == null || allowedExtensions == null) {
            return false;
        }
        
        String extension = FilenameUtils.getExtension(fileName).toLowerCase();
        for (String allowedExt : allowedExtensions) {
            if (allowedExt.toLowerCase().equals(extension)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 파일명 검증 및 안전한 파일명 생성
     * 경로 주입 공격 방지를 위해 파일명에서 경로 구분자 제거
     * 
     * @param fileName 검증할 파일명
     * @return 안전한 파일명
     */
    public static String sanitizeFileName(String fileName) {
        if (fileName == null) return null;
        return FilenameUtils.getName(fileName);
    }

    /**
     * 안전한 디렉토리 생성
     * 경로 검증 후 디렉토리 생성
     * 
     * @param basePath 기본 디렉토리 경로
     * @param dirPath 생성할 디렉토리 경로
     * @throws SecurityException 유효하지 않은 경로일 경우 발생
     */
    public static void createSecureDirectory(String basePath, String dirPath) {
        Path securePath = getSecurePath(basePath, dirPath);
        File dir = securePath.toFile();
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }
} 