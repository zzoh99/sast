package com.hr.api.m.ben.occasion;

import com.hr.common.logger.Log;
import com.hr.common.other.OtherService;
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
@RequestMapping(value="/api/v5/occasion")
public class ApiOccasionController {

    @Inject
    @Named("OtherService")
    private OtherService otherService;

    /**
     * 경조신청 서비스
     */
    @Inject
    @Named("ApiOccasionService")
    private ApiOccasionService apiOccasionService;
    /**
     * 경조신청 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getOccAppList")
    public Map<String, Object> getOccAppList(
            HttpSession session,
            HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        //페이징 설정
        int totalPage = apiOccasionService.getOccAppListCnt(paramMap);
        Log.Debug("totalPage:"+totalPage);

        int divPage = 10;
        Log.Debug(paramMap.get("searchPage").toString());
        int page = paramMap.get("searchPage") == null? 1: Integer.valueOf(paramMap.get("searchPage").toString());
        int stNum = (page -1) * divPage + 1;
        int edNum = page * divPage;
        int lastPage = (totalPage / 10) + 1;

        paramMap.put("stNum", stNum);
        paramMap.put("edNum", edNum);

        List<?> list = apiOccasionService.getOccasionList(paramMap);
        Log.Debug(list.toString());

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("lastPage", lastPage);
        Log.DebugEnd();
        return result;
    }

    /**
     * 경조금신청 단건 조회 3 Service
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getOccDetMap")
    public Map<String, Object> getOccDetMap(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = apiOccasionService.getOccAppDetMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("DATA", map);
        result.put("Message", Message);

        Log.DebugEnd();
        return result;
    }

    /**
     * 경조코드 조회
     *
     * @param session
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getOccCdList")
    public Map<String, Object> getOccCdList(
            HttpSession session, @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        List<?> list = apiOccasionService.getOccCdList(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    /**
     * 경조금신청 세부내역 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/saveOccasionAppDet")
    public Map<String, Object> saveOccasionAppDet(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try{
            List<Map<String, Object>> appList = (List<Map<String, Object>>) paramMap.get("applList");
            for(Map<String, Object> appls : appList){
                Log.Debug(appls.toString());
                resultCnt =apiOccasionService.saveOccasionAppDet(appls);
            }

            if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
        }catch(Exception e){

            Log.Error("Exception : "+e);
            Log.Error("resultCnt : "+resultCnt);
            resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
        }

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("Code", resultCnt);
        result.put("Message", message);

        Log.DebugEnd();

        return result;
    }



}
