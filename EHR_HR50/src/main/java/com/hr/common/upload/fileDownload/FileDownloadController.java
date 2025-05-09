package com.hr.common.upload.fileDownload;

import com.hr.common.logger.Log;
import com.hr.common.util.HttpUtils;
import com.hr.common.util.Zip4jUtil;
import com.hr.common.wrapper.ModifyResponseWrapper;
import com.hr.hrm.certificate.certiAppDet.CertiAppDetController;
import com.hr.common.util.securePath.SecurePathUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.nio.file.Path;

@Controller
@RequestMapping({"/FileDownload.do"})
public class FileDownloadController {


    @Autowired
    private FileDownloadService fileDownloadService;

    /**
     * [제증명] PDF 다운로드 처리
     * @param session
     * @param request
     * @param paramMap
     * @throws Exception
     */
    @RequestMapping(params="cmd=getCertiAppPdfDownload", method = RequestMethod.GET )
    public void getCertiAppPdfDownload(
            HttpSession session, HttpServletRequest request, HttpServletResponse response,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));

        Map<?, ?> map  = new HashMap<String,Object>();

        // 브라우저 정보
        String browser  = HttpUtils.getBrowser(request);

        // 다운로드시 비밀번호 설정 여부
        String fileDownSetPwd   = "N";
        // 다운로드 설정 비밀번호
        String fileDownPwd      = "";
        // 다운로드시 파일명
        String downloadFileName = null;

        // 서버 기준 경로
        String serverPath = "";
        // 파일명
        String fileName = "";
        // 파일경로
        String filePath = "";
        // yjunsan.properties 객체
        Properties prop = null;
        // opti.properties 객체
        Properties prop2 = null;


        // 파일
        File file = null;
        InputStream in = null;
        OutputStream out = null;

        try{
            /* 다운로드시 비밀번호 설정 여부 체크 */
            if( session != null ) {
                fileDownSetPwd = (String) session.getAttribute("ssnFileDownSetPwd");
                fileDownPwd = (String) session.getAttribute("ssnFileDownPwd");
            }

            if( fileDownSetPwd == null || "".equals(fileDownSetPwd) ) {
                fileDownSetPwd = "N";
            }
            /* 다운로드시 비밀번호 설정 여부 체크 */

            // 다운로드 파일 정보 조회
            map = fileDownloadService.getCertiAppDetPdfDownloadFileMap(paramMap);
            if( map != null ) {
                prop = new Properties();
                prop.load(CertiAppDetController.class.getClassLoader().getResourceAsStream("yjungsan.properties"));

                // 네트워크 파일 업로드 패스
                String nfsUploadPath = prop.getProperty("NFS.HRFILE.PATH");
                if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
                    serverPath = nfsUploadPath;
                } else {
                    serverPath = prop.getProperty("WAS.PATH");
                }

                fileName = (String) map.get("fileName");
                filePath = (String) map.get("filePath");

                if( !StringUtils.isBlank(filePath) && !StringUtils.isBlank(fileName) ) {
                    // 안전한 파일명 생성
                    String safeFileName = SecurePathUtil.sanitizeFileName(fileName);
                    
                    // 안전한 경로 생성
                    Path safePath = SecurePathUtil.getSecurePath(serverPath, filePath);
                    Path safeFilePath = SecurePathUtil.getSecurePath(safePath.toString(), safeFileName);
                    
                    file = new File(safeFilePath.toString());

                    // 파일이 실제 존재하는 경우 진행
                    if( file != null && file.isFile() && file.exists() ) {

                        // 파일 암호 설정이 N이거나 설정값이 없는 경우[일반적인]
                        if(fileDownSetPwd == null || "N".equals(fileDownSetPwd)) {
                            downloadFileName = safeFileName;
                            in = new FileInputStream(file);
                        } else {
                            prop2 = new Properties();
                            prop2.load(CertiAppDetController.class.getClassLoader().getResourceAsStream("opti.properties"));

                            downloadFileName = System.currentTimeMillis() + ".zip";
                            
                            // 임시 ZIP 파일 경로 생성
                            Path tempPath = SecurePathUtil.getSecurePath(prop2.getProperty("common.temp.path"), downloadFileName);
                            File zipFile = new File(tempPath.toString());

                            File upDir = zipFile.getParentFile();
                            if(!upDir.isDirectory()) {
                                SecurePathUtil.createSecureDirectory(prop2.getProperty("common.temp.path"), "");
                            }

                            // load Zip4j util
                            Zip4jUtil zip4jUtil = null;
                            try {
                                zip4jUtil = new Zip4jUtil(zipFile, true, fileDownPwd.toCharArray());
                                zip4jUtil.addEntry(safeFileName, new FileInputStream(file));
                            } finally {
                                if(zip4jUtil != null) {
                                    try {
                                        zip4jUtil.close();
                                    } catch (Exception e) {
                                        Log.Debug("Zip4jUtil CLOSE FAIL");
                                    }
                                }
                            }

                            in = new FileInputStream(zipFile);
                            zipFile.delete();
                        }

                        /* set responseWrapper header */
                        Tika tika = new Tika();
                        String mType = tika.detect(downloadFileName);

                        if ( !"".equals(mType)){
                            response.setHeader("Content-Type", mType);
                        }else{
                            response.setHeader("Content-Type", "application/octet-stream");
                        }
                        response.setHeader("Content-Disposition", HttpUtils.getEncodedFilenameAddPrefix(downloadFileName, browser, "attachment;filename="));
                        response.setContentLength((int) in.available());

                        /* set response header */
                        out = response.getOutputStream();

                        byte b[] = new byte[1024];
                        int numRead = 0;
                        while ((numRead = in.read(b)) != -1) {
                            out.write(b, 0, numRead);
                        }

                        out.flush();
                        out.close();
                        out = null;
                        in.close();
                        in = null;
                    }
                }
            }
        }catch(Exception e){
            Log.Debug(e.getLocalizedMessage());
            throw e;
        } finally {
            try {
                if(out != null) {
                    out.close();
                }
            } catch (Exception ee) {}

            try {
                if(in != null) {
                    in.close();
                }
            } catch (Exception ee) {}
        }

        Log.DebugEnd();
    }
}
