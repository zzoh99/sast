package com.hr.api.common.controller;

import com.hr.common.code.CommonCodeService;
import com.hr.common.exception.FileUploadException;
import com.hr.common.logger.Log;
import com.hr.common.popup.PopupService;
import com.hr.common.rd.RdInvokerService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.StringUtil;
import com.hr.common.util.fileupload.impl.FileHandlerFactory;
import com.hr.common.util.fileupload.impl.FileUploadConfig;
import com.hr.common.util.fileupload.impl.IFileHandler;
import com.hr.common.util.fileupload.jfileupload.web.JFileUploadService;
import com.hr.common.util.securePath.SecurePathUtil;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Path;
import java.text.SimpleDateFormat;
import java.util.*;

@RestController
@RequestMapping(value="/api/v5/common")
public class ApiCommnController {

    @Inject
    @Named("JFileUploadService")
    private JFileUploadService jFileUploadService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    @Inject
    @Named("RdInvokerService")
    private RdInvokerService rdInvokerService;

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

    @Inject
    @Named("PopupService")
    private PopupService popupService;

    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

    @Value("${rd.url}")
    private String rdUrl;

    @Value("${rd.mrd}")
    private String rdMrdUrl;

    /**
     * 공통 COMBO 코드 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getCommonNSCodeList")
    public Map<String, Object> getCommonNSCodeList(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
        paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));

        List<?> list = commonCodeService.getCommonNSCodeList(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("codeList", list);
        Log.DebugEnd();
        return result;
    }

    /**
     * 공통코드 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getCommonCodeList")
    public Map<String, Object> getCommonCodeList(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

        getBaseYmd(paramMap);

        List<?> list = commonCodeService.getCommonCodeList(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("codeList", list);
        Log.DebugEnd();
        return result;
    }

    @RequestMapping(value = "/getCommonCodeLists")
    public Map<String, Object> getCommonCodeLists(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

        paramMap.put("grpCd", (paramMap.get("grpCd") + "").split(","));

        getBaseYmd(paramMap);

        List<?> list = commonCodeService.getCommonCodeLists(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("codeList", list);
        Log.DebugEnd();
        return result;
    }

    @RequestMapping(value = "/downReport")
    public void downReport(
            HttpSession session, HttpServletRequest request
            , HttpServletResponse response
            , @RequestParam Map<String, Object> paramMap) throws Exception{
        Log.DebugStart();

        String securityKey = request.getAttribute("securityKey") + "";
        String mrdPath = "hrm/empcard/PersonInfoCardType2_HR.mrd";

        String param = "/rp [,('HR','IM0004')]"
                + " [" + imageBaseUrl + "] "
                + " [N]" // 마스킹 여부
                + " [Y]" // hrbasic1
                + " [Y]" // hrbasic2
                + " [Y]"
                + " [Y]"
                + " [Y]" // 전체발령표시여부
                + " [HR]"
                + " ['101006']"
                + " []"
                + " ['IM0004']"  //사번
                + " [Y]" // 평가
                + " [Y]" // 타부서발령여부
                + " [Y]" // 연락처
                + " [Y]" // 병역
                + " [Y]" // 학력
                + " [Y]" // 경력
                + " [Y]" // 포상
                + " [Y]" // 징계
                + " [Y]" // 자격
                + " [Y]" // 어학
                + " [Y]" // 가족
                + " [Y]" // 발령
                + " [Y]" // 직무
                + " [" + securityKey + "] "
                + " /rv securityKey[" + securityKey + "]"
                + " /rloadimageopt [1]";

        paramMap.put("mrdPath", mrdPath);
        paramMap.put("rdParam", param);
        paramMap.put("enterCd", "HR");

        // 서버에 다운로드 처리
//        Map res = rdInvokerService.invokeToFile(paramMap, true, "pdf", null);
//        Log.Debug("파일 다운로드 경로: " +res.get("saveFileName").toString());

        // 서비스에서 byte[] 데이터를 받아옴
        byte[] rdData = rdInvokerService.invokeToByteArray(paramMap, true,"pdf", "report");

        // 응답 헤더 설정 (PDF 다운로드로 설정)
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"report.pdf\"");
        response.setContentLength(rdData.length);  // 데이터 크기를 설정

        // 클라이언트로 데이터 전송
        try (OutputStream os = response.getOutputStream()) {
            os.write(rdData);
            os.flush();
        } catch (Exception e) {
            Log.Debug("rd 데이터 전송 에러");
            e.printStackTrace();
        }

        Log.DebugEnd();
    }

    @RequestMapping(value = "/jIbFileList")
    public Map<String, Object> jIbFileList(@RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        List<?> list =  jFileUploadService.jIbFileList(paramMap);
        Map<String, Object> result = new HashMap<>();
        Log.Debug(">>>>>>>>>>jFileList<<<<<<<<<<");
        Log.Debug(paramMap.toString());
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    @RequestMapping(value = "/download")
    public void download(HttpSession session, HttpServletRequest request, HttpServletResponse response,
                         @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();

        IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        String fileSeq = (String) paramMap.get("fileSeq");
        String seqNo = (String) paramMap.get("seqNo");

        String[] fileSeqs = { fileSeq };
        String[] seqNos = { seqNo };
        fileHandler.download(false, fileSeqs, seqNos);

        Log.DebugEnd();
    }

    @RequestMapping(value = "/upload")
    public void upload(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws FileUploadException, JSONException, IOException {
        Log.DebugStart();

        String ssnEnterCd 	= session.getAttribute("ssnEnterCd").toString();

        JSONObject jsonObject = new JSONObject();
        Map<String, Object> result = new HashMap<>();
        response.setContentType("text/plain");
        response.setCharacterEncoding("utf-8");

        Log.Debug("■■■■■■■■■■■■■■■ parameter start ■■■■■■■■■■■■■■■");
        for( Enumeration<String> enumeration = request.getParameterNames(); enumeration.hasMoreElements();) {
            Object obj = enumeration.nextElement();
            String s = request.getParameterValues((String)obj)[0];
            Log.Debug( "Parameter name ="+ obj.toString() + ", Parameter value =["+s+"]" );
        }
        Log.Debug("■■■■■■■■■■■■■■■ parameter end ■■■■■■■■■■■■■■■");

        try {
            IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
            JSONArray oldJsonArray = fileHandler.ibupload("ibupload", null);
            JSONArray newJsonArray = new JSONArray();

            String enckey = securityMgrService.getEncryptKey(ssnEnterCd);
            for (int i=0; i<oldJsonArray.length(); i++) {
                Object item = oldJsonArray.get(i);
                if (item instanceof JSONObject) {
                    String strObject = item.toString();
                    JSONObject json = CryptoUtil.cryptoParameter(strObject, "E", enckey, request);
                    newJsonArray.put(json);
                }
                //기본 STRING 배열일 경우 추가
                else if (item instanceof String) {
                    newJsonArray.put(item);
                }
            }
            jsonObject.put("code", "success");
            jsonObject.put("data", newJsonArray);
            response.getWriter().write(jsonObject.toString());
        } catch(FileUploadException fue) {
            fue.printStackTrace();
            jsonObject.put("code", "error");
            jsonObject.put("msg", fue.getMessage());
            response.getWriter().write(jsonObject.toString());
        } catch(Exception e) {
            Log.Debug(e.getLocalizedMessage());
            jsonObject.put("code", "error");
            jsonObject.put("msg", e.getMessage());
            response.getWriter().write(jsonObject.toString());
        }

        Log.DebugEnd();
    }

    /**
     * 사인 저장
     *
     * @param paramMap
     * @param request
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/saveSignPad")
    public Map<String, Object> saveSignPad(
            HttpSession session, @RequestBody Map<String, Object> paramMap,
            HttpServletRequest request) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnEnterCd",  session.getAttribute("ssnEnterCd"));
        String message = "";
        int resultCnt = 0;

        try {
            //파일저장 경로
            FileUploadConfig config = new FileUploadConfig("pht002");
            String baseDir = (config.getDiskPath().length()==0 ) ? 
                request.getSession().getServletContext().getRealPath("/")+"/hrfile" : 
                config.getDiskPath();
            
            String storePath = config.getProperty(FileUploadConfig.POSTFIX_STORE_PATH);
            storePath = storePath == null ? "" : storePath;

            String sign = StringUtils.split(paramMap.get("sign").toString(), ",")[1];
            String fileName = "sign" + System.currentTimeMillis() + ".jpg";
            
            // 안전한 파일명 생성
            String safeFileName = FilenameUtils.getName(fileName);
            
            // 안전한 경로 생성
            Path securePath = SecurePathUtil.getSecurePath(baseDir, session.getAttribute("ssnEnterCd").toString(), storePath);
            Path secureFilePath = SecurePathUtil.getSecurePath(securePath.toString(), safeFileName);
            File f = secureFilePath.toFile();

            FileUtils.writeByteArrayToFile(f, Base64.decodeBase64(sign));

            paramMap.put("seqNo",     0);
            paramMap.put("fileSize",  f.length());
            paramMap.put("filePath",  storePath);
            paramMap.put("rFileNm",   safeFileName);
            paramMap.put("sFileNm",   safeFileName);
            
        } catch(Exception e) {
            resultCnt = -1;
            message = "처리 중 오류가 발생했습니다. \\n(" + e.getMessage() + ")";
            Log.Debug(e.getMessage());
        }

        String fileSeq = "";
        try {
            fileSeq = popupService.saveSignPadPopup(paramMap);
            if("-1".equals(fileSeq)) {
                resultCnt = -1;
            }
        } catch(Exception e) {
            resultCnt = -2;
            message = "파일 저장 중 오류가 발생했습니다. \\n(" + e.getMessage() + ")";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("Code", resultCnt);
        result.put("Message", message);
        result.put("FileSeq", fileSeq);
        Log.DebugEnd();
        return result;
    }

    private void getBaseYmd(@RequestParam Map<String, Object> paramMap) {
        if (paramMap.containsKey("baseSYmd") && paramMap.get("baseSYmd") != null && !"".equals(paramMap.get("baseSYmd"))) {
            paramMap.put("baseSYmd", replaceBaseYmd(paramMap.get("baseSYmd").toString()));
        } else {
            paramMap.put("baseSYmd", getToday());
        }

        if (paramMap.containsKey("baseEYmd") && paramMap.get("baseEYmd") != null && !"".equals(paramMap.get("baseEYmd"))) {
            paramMap.put("baseEYmd", replaceBaseYmd(paramMap.get("baseEYmd").toString()));
        }
    }

    private String replaceBaseYmd(String baseYmd) {
        return baseYmd.replaceAll("-", "");
    }

    private String getToday() {
        Date today = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        return dateFormat.format(today);
    }

}
