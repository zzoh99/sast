package com.hr.api.self.common;

import com.hr.common.code.CommonCodeService;
import com.hr.common.exception.FileUploadException;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.fileupload.impl.FileHandlerFactory;
import com.hr.common.util.fileupload.impl.IFileHandler;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5/self/common")
public class SelfCommnController {

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

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

}
