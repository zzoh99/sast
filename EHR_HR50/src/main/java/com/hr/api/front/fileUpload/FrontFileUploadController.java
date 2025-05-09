package com.hr.api.front.fileUpload;

import com.hr.common.exception.FileUploadException;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.fileupload.impl.FileHandlerFactory;
import com.hr.common.util.fileupload.impl.IFileHandler;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
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
import java.util.Map;

@RestController
@RequestMapping(value="/api/front/file")
public class FrontFileUploadController {

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

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

    @RequestMapping(value = "/delete")
    public Map<String, Object> delete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // comment 시작
        Log.DebugStart();

        String message = "";
        String code = "success";

        try{
            IFileHandler fileHandler = FileHandlerFactory.getFileHandler(request, response);
            fileHandler.delete();
        }catch(Exception e){
            Log.Debug(e.getLocalizedMessage());
            message= LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
            code = "error";
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("code", code);
        resultMap.put("message", message);
        Log.DebugEnd();

        return resultMap;
    }

}
