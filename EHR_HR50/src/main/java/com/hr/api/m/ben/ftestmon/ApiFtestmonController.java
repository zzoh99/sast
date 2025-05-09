package com.hr.api.m.ben.ftestmon;

import com.hr.common.logger.Log;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value="/api/v5/ftestmon")
public class ApiFtestmonController {

    @Inject
    @Named("ApiFtestmonService")
    private ApiFtestmonService apiFtestmonService;

    /**
     * 어학시험응시료신청 세부내역 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getFtestmonAppDetMoMap")
    public Map<String, Object> getFtestmonAppDetMoMap(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        List<?> list = null;
        String Message = "";

        Log.Debug(paramMap.toString());
        try{
            list = apiFtestmonService.getFtestmonAppDetMoMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);

        return result;
    }

}
