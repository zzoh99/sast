package com.hr.api.common.controller;

import com.hr.api.common.service.ApiLocaleService;
import com.hr.common.logger.Log;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5")
public class ApiLocaleController {

    @Inject
    @Named("ApiLocaleService")
    private ApiLocaleService apiLocaleService;

    /**
     * 공통 COMBO 코드 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/load-locale")
    public Map<String, Object> locale(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();

        List<Map<String, Object>> enList  = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> koList  = new ArrayList<Map<String, Object>>();
        Map<String, Object> en = new HashMap<>();
        Map<String, Object> ko = new HashMap<>();

        try{
            paramMap.put("langCd", "en");
            enList = (List<Map<String, Object>>) apiLocaleService.getLoadLocale(paramMap);
            for(Map<String, Object> map : enList){
                en.put(map.get("keyId").toString(), map.get("keyText").toString());
            }
            paramMap.put("langCd", "ko");
            koList = (List<Map<String, Object>>) apiLocaleService.getLoadLocale(paramMap);
            for(Map<String, Object> map : koList){
                ko.put(map.get("keyId").toString(), map.get("keyText").toString());
            }
        }
        catch(Exception e){
            Log.Error(e.getMessage());
        }

        Map<String, Object> result = new HashMap<>();
        result.put("en", en);
        result.put("ko", ko);

        Log.DebugEnd();
        return result;
    }

}
