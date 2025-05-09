package com.hr.common.rd;

import com.hr.common.util.CryptoUtil;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.http.HttpSession;
import java.security.InvalidParameterException;
import java.util.*;

public class RdRequest {

    private JSONObject rk;
    private JSONObject parameters;
    private String mrdPath;

    private RdRequest(JSONObject rk, JSONObject parameters, String mrdPath) {
        this.rk = rk;
        this.parameters = parameters;
        this.mrdPath = mrdPath;
    }

    public static RdRequest of(Map<String, Object> paramMap, String encryptKey, HttpSession session) throws JSONException {
        JSONObject param = new JSONObject(paramMap);
        JSONObject rk = new JSONObject();

        if (session.getAttribute("mp") == null) {
            throw new InvalidParameterException("mp is null");
        }

        String encryptMrdPath = String.valueOf(session.getAttribute("mp"));
        String mrdPath = CryptoUtil.decrypt(encryptKey, encryptMrdPath);

        if (isContainsRk(param)) {
            String encryptRp = String.valueOf(session.getAttribute("rp"));
            String decryptRp = CryptoUtil.decrypt(encryptKey, encryptRp);
            String[] rpArr = decryptRp.split("#");

            JSONArray rkJsonArray = null;
            Object rkObject = param.get("rk"); // rk 값을 Object로 받아서 타입을 확인
            if (rkObject instanceof JSONArray) {
                // rk가 JSONArray일 경우
                rkJsonArray = (JSONArray) rkObject;
            } else if (rkObject instanceof String) {
                // rk가 String일 경우
                String rkString = (String) rkObject;
                rkJsonArray = new JSONArray(rkString);
            }

            for (int i = 0; i < rkJsonArray.length(); i++) {
                String decryptRk = CryptoUtil.decrypt(encryptKey, rkJsonArray.getString(i));
                String[] rkArr = decryptRk.split("#");

                for (int j = 0; j < rkArr.length; j++) {
                    String rpStr = rpArr[j];
                    String rkStr = "";
                    if (rk.has(rpStr)) {
                        rkStr = rk.getString(rpStr);
                        rkStr += "," + rkArr[j];
                    } else {
                        rkStr = rkArr[j];
                    }

                    if (rkStr.contains("{seq}")) {
                        rkStr = rkStr.replace("{seq}", String.valueOf(i + 1) );
                    }

                    rk.put(rpStr, rkStr);
                }

            }

            param.remove("rp");
            param.remove("rk");
        }

        return new RdRequest(rk, param, mrdPath);
    }

    private static boolean isContainsRk(JSONObject param) {
        return param.has("rk");
    }

    public boolean isEmpty() {
        return parameters.length() == 0 && rk.length() == 0;
    }

    public String makeRv() throws JSONException {
        if (rk == null || rk.length() == 0) {
            return makeRvFromParameters();
        }

        return makeRvFromParameters() + makeRvFromRk();
    }

    private String makeRvFromParameters() throws JSONException {
        Iterator keys = parameters.keys();
        String rvFromParameters = "";
        while (keys.hasNext()) {
            String key = String.valueOf(keys.next());
            rvFromParameters += makeRvPattern(key, parameters.getString(key));
        }

        return rvFromParameters;
    }

    private String makeRvFromRk() throws JSONException {
        Iterator<String> rkKeys = rk.keys();
        String rv = "";

        while(rkKeys.hasNext()) {
            String key = rkKeys.next();
            String value = rk.getString(key);
            rv += makeRvPattern(key, value);
        }

        return rv;
    }

    private String makeRvPattern(String key, String value) {
        return " " + key + "[" + value + "]";
    }

    public String getMrdPath() {
        return mrdPath;
    }
}
