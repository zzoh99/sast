package com.hr.api.m.tim.vacation;

import com.hr.common.logger.Log;
import com.hr.tim.request.vacationApp.VacationAppService;
import com.hr.tim.request.vacationAppDet.VacationAppDetService;
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
@RequestMapping(value="/api/v5/vacation")
public class ApiVacationController {

    @Inject
    @Named("VacationAppService")
    private VacationAppService vacationAppService;

    @Inject
    @Named("VacationAppDetService")
    private VacationAppDetService vacationAppDetService;

    @Inject
    @Named("ApiVactionService")
    private ApiVactionService apiVactionService;

    /**
     * 근태 정보를 전달한다.
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationAppList")
    public Map<String, Object> getVacationAppList(
            @RequestBody Map<String, Object> paramMap, HttpSession session) throws Exception {
        Log.Debug(paramMap.toString());
        Map<String, Object> result = new HashMap<>();
        String Message = "";

        try {
            Log.Debug("getVacationAppList =====");
            Log.Debug(":"+paramMap.toString());
            Log.Debug(":"+session.toString());

            paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
            //ssnLocaleCd

            List<?> list = vacationAppService.getVacationAppList(paramMap);
            if(list != null) {
                result.put("list", list);
            }else{
                result.put("list","");
            }
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
            Log.Debug(e.getMessage());
            result.put("Message", Message);
        }

        return result;
    }

    /**
     * 근태신청 상세 내역
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationAppDetMoMap")
    public Map<String, Object> getVacationAppDetMoMap(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
        paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));

        Log.Debug(paramMap.toString());

        List<?> list = null;
        String Message = "";

        try{
            list = apiVactionService.getVacationAppDetMoMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);

        Log.DebugEnd();
        return result;
    }

    /**
     * 근태취소 상세 내역
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationUpdAppDetMoMap")
    public Map<String, Object> getVacationUpdAppDetMoMap(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));
        paramMap.put("ssnSearchType", 	session.getAttribute("ssnSearchType"));

        Log.Debug(paramMap.toString());

        List<?> list = null;
        String Message = "";

        try{
            list = apiVactionService.getVacationUpdAppDetMoMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);

        Log.DebugEnd();
        return result;
    }

    /**
     * getVacationAppDetRestCnt 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationAppDetRestCnt")
    public Map<String, Object> getVacationAppDetRestCnt(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = vacationAppDetService.getVacationAppDetRestCnt(paramMap);
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
     * vacationApp 다건 조회 2
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationAppExList")
    public Map<String, Object> getVacationAppExList(
            HttpSession session,  HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("searchSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = vacationAppService.getVacationAppExList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("Message", Message);
        Log.DebugEnd();
        return result;
    }

    /**
     * vacationAppDet 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationAppDetHolidayCnt")
    public Map<String, Object> getVacationAppDetHolidayCnt(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = vacationAppDetService.getVacationAppDetHolidayCnt(paramMap);
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
     * getVacationAppDetStatusCd 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationAppDetStatusCd")
    public Map<String, Object> getVacationAppDetStatusCd(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = vacationAppDetService.getVacationAppDetStatusCd(paramMap);
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
     * getVacationAppDetDayCnt 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationAppDetDayCnt")
    public Map<String, Object> getVacationAppDetDayCnt(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = vacationAppDetService.getVacationAppDetDayCnt(paramMap);
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
     * vacationAppDet 단건 조회 2
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/getVacationAppDetApplDayCnt")
    public Map<String, Object> getVacationAppDetApplDayCnt(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = vacationAppDetService.getVacationAppDetApplDayCnt(paramMap);
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
     * 근태신청 세부내역 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return Map
     * @throws Exception
     */
    @RequestMapping(value = "/saveVacationAppDet")
    public Map<String, Object> saveVacationAppDet(
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
                appls.put("ssnEnterCd", paramMap.get("ssnEnterCd").toString());
                appls.put("searchApplSabun", paramMap.get("ssnSabun").toString());
                appls.put("gntReqReson", paramMap.get("gntReqReson").toString());
                Log.Debug(appls.toString());
                resultCnt =vacationAppDetService.saveVacationAppDet(appls);
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
