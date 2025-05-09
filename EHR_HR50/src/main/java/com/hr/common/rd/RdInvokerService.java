package com.hr.common.rd;

import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.common.util.StringUtil;
import com.hr.common.util.fileupload.impl.FileUploadConfig;
import m2soft.ers.invoker.InvokerException;
import m2soft.ers.invoker.http.ReportingServerInvoker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * RD 다운로드
 */
@Service("RdInvokerService")
public class RdInvokerService {

    @Autowired
    private EncryptRdService encryptRdService;

    private FileUploadConfig config;

    @Value("${rd.url}")
    private String rdUrl;

    @Value("${rd.mrd}")
    private String rdMrd;

    @Value("${rd.base.path}")
    private String rdTypeBasic;

    private ReportingServerInvoker init() {
        ReportingServerInvoker invoker = new ReportingServerInvoker(rdUrl + "/ReportingServer/service");
        invoker.setCharacterEncoding("euc-kr");
        invoker.setReconnectionCount(3);
        invoker.setConnectTimeout(5);
        invoker.setReadTimeout(30);
        return invoker;
    }

    private void setInvokerParameters(ReportingServerInvoker invoker, Map<String, Object> paramMap, boolean isEncParam, String extension, String fileName) throws Exception {
        // 파라미터 유효성 검사
        String mrdPath = StringUtil.stringValueOf(paramMap.get("mrdPath"));
        String rdParam = StringUtil.stringValueOf(paramMap.get("rdParam"));

        if (mrdPath == null || mrdPath.isEmpty()) {
            throw new IllegalArgumentException("mrdPath cannot be null or empty");
        }

        if (rdParam == null || rdParam.isEmpty()) {
            throw new IllegalArgumentException("rdParam cannot be null or empty");
        }

        // 파라미터 암호화 처리
        if(isEncParam) {
            Map<String, Object> encParam = encryptRdService.encrypt(mrdPath, rdParam);
            mrdPath = StringUtil.stringValueOf(encParam.get("path"));
            rdParam = StringUtil.stringValueOf(encParam.get("encryptParameter"));
            invoker.addParameter("enc_type", "11");
            invoker.addParameter("mrd_path", mrdPath);
        } else {
            if(!mrdPath.startsWith("/")){
                mrdPath = "/" + mrdPath;
            }
            invoker.addParameter("mrd_path", rdMrd + rdTypeBasic + mrdPath);
        }

        // 확장자 유효성 검사
        if (extension == null || extension.isEmpty()) {
            extension = "pdf";  // 기본 확장자를 pdf로 설정
        }

        invoker.addParameter("opcode", "500");
        invoker.addParameter("mrd_param", rdParam);
        invoker.addParameter("export_type", extension);
        invoker.addParameter("export_name", fileName != null ? fileName + "." + extension : "report." + extension);  // 파일명 기본값 설정
        invoker.addParameter("protocol", "file");
    }

    /**
     * 서버내에 다운로드한 리포트 파일 경로 전달 방식
     * @param paramMap - MRD Path 및 파라미터
     * @param isEncParam - 파라미터 암호화 적용 여부
     * @param extension - 파일 확장자
     * @param fileName - 저장될 파일명 (확장자를 제외한 파일명)
     * @return 결과 코드와 파일명
     */
    public Map<String, Object> invokeToFile(Map<String, Object> paramMap, boolean isEncParam, String extension, String fileName) throws Exception {
        Log.DebugStart();
        Map<String, Object> result = new HashMap<>();

        ReportingServerInvoker invoker = init();

        try {
            config = new FileUploadConfig("rd");

            // 파일 경로 생성
            String filePath = generateFilePath(paramMap, fileName, extension);

            setInvokerParameters(invoker, paramMap, isEncParam, extension, fileName);
            invoker.invoke(filePath);
            result.put("saveFileName", filePath);
            result.put("resultCode", 1);
        } catch (InvokerException e) {
            Log.Debug("Error during invocation: " + e.getMessage());
            result.put("resultCode", -1);
        } catch (Exception e) {
            Log.Debug("Error: " + e.getMessage());
            throw new RuntimeException(e);
        }

        Log.DebugEnd();
        return result;
    }

    /**
     * 리포트 데이터를 byte[]로 반환 방식
     * @param paramMap - MRD Path 및 파라미터
     * @param isEncParam - 파라미터 암호화 적용 여부
     * @param extension - 파일 확장자
     * @param fileName - 저장될 파일명 (확장자를 제외한 파일명)
     * @return 리포트 데이터를 byte[]로 반환
     * @throws Exception
     */
    public byte[] invokeToByteArray(Map<String, Object> paramMap, boolean isEncParam, String extension, String fileName) throws Exception {
        Log.DebugStart();
        ReportingServerInvoker invoker = init();
        setInvokerParameters(invoker, paramMap, isEncParam, extension, fileName);

        try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
             InputStream is = invoker.invokeAndGetStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;

            while ((bytesRead = is.read(buffer)) != -1) {
                baos.write(buffer, 0, bytesRead);
            }

            Log.DebugEnd();
            return baos.toByteArray();  // 리포트를 byte[]로 반환

        } catch (Exception e) {
            Log.Debug("Error during stream invocation: " + e.getMessage());
            throw e;
        }
    }

    // 파일 경로 처리 메서드
    private String generateFilePath(Map<String, Object> paramMap, String fileName, String extension) throws Exception {
        String realPath = this.config.getDiskPath();
        if (realPath == null || realPath.isEmpty()) {
            throw new IllegalArgumentException("Disk path 가 정의되지 않았습니다.");
        }

        if(!paramMap.containsKey("enterCd")){
            throw new IllegalArgumentException("enterCd 값이 없습니다.");
        }

        String enterCd = paramMap.get("enterCd").toString();
        realPath = StringUtil.replaceAll(realPath + "/" + enterCd, "//", "/");

        String tmp = this.config.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
        tmp = (tmp == null) ? "" : tmp;

        // 패턴 매칭을 통한 경로 포맷팅
        Pattern p = Pattern.compile("@([\\w]*)@");
        Matcher m = p.matcher(tmp);

        while (m.find()) {
            String replaceKey = m.group(0);
            String patternKey = m.group(1);
            try {
                tmp = tmp.replace(replaceKey, DateUtil.getCurrentDay(patternKey));
            } catch (Exception e) {
                Log.Debug("Date format error: " + e.getMessage());
            }
        }

        String workDir = StringUtil.replaceAll(tmp, "//", "/");

        File df = new File(realPath + "/" + workDir);

        if(!df.isDirectory()) {
            if( df.mkdirs() ){
                Log.Debug("Directory Create Ok!");
            }
        }

        if(fileName == null || fileName.isEmpty()) {
            fileName = "report_" + DateUtil.getDateTime(System.currentTimeMillis(), "yyyyMMddHHmmssSSS");
        }

        return StringUtil.replaceAll(realPath + "/" + workDir + "/" + fileName + "." + extension, "//", "/");
    }
}

