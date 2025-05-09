package com.hr.api.m.main.main;

import com.hr.common.logger.Log;
import com.hr.common.security.SecurityMgrService;
import com.hr.main.login.LoginService;
import com.hr.main.main.MainService;
import com.hr.tim.request.vacationAppDet.VacationAppDetService;
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
@RequestMapping(value="/api/v5/main")
public class ApiMainController {

    @Inject
    @Named("MainService")
    private MainService mainService;

    @Inject
    @Named("SecurityMgrService")
    private SecurityMgrService securityMgrService;

    @Inject
    @Named("VacationAppDetService")
    private VacationAppDetService vacationAppDetService;

    @Inject
    @Named("LoginService")
    private LoginService loginService;

    /**
     * 개인 권한 리스트 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(value = "/getCollectAuthGroupList")
    public Map<String, Object> getCollectAuthGroupList(
            HttpSession session, HttpServletRequest request,
            @RequestBody Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        paramMap.put("ssnEncodedKey", 	session.getAttribute("ssnEncodedKey"));

        List<?> list = loginService.getAuthGrpList(paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        Log.DebugEnd();
        return result;
    }

    @RequestMapping(value = "/ChangeSession")
    public Map<String, Object> ChangeSession(
            HttpSession session,
            @RequestBody Map<String, Object> paramMap ) throws Exception {

        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        Map<String, Object> urlParam = new HashMap<String, Object>();
        String surl = paramMap.get("rurl").toString();
        String skey = session.getAttribute("ssnEncodedKey").toString();

        String subGrpCd = null;
        String subGrpNm = null;
        urlParam = (Map<String, Object>) securityMgrService.getDecryptUrl( surl, skey  );

        subGrpCd = urlParam.get("subGrpCd").toString();
        subGrpNm = urlParam.get("subGrpNm").toString();

        paramMap.put("subGrpCd", 	subGrpCd);

        Log.Debug("urlParam==>"+urlParam);
        Log.Debug("surl==>"+surl);
        Log.Debug("skey==>"+skey);

        Log.Debug("subGrpNm==>"+subGrpCd);
        Log.Debug("subGrpNm==>"+subGrpNm);

        Map<?, ?> map = mainService.getSelectMap_TSYS313(paramMap);

        String rs = "";
        if( map != null ){
            session.removeAttribute("ssnGrpCd"); 		session.setAttribute("ssnGrpCd", subGrpCd);
            session.removeAttribute("ssnGrpNm"); 		session.setAttribute("ssnGrpNm", subGrpNm);
            session.removeAttribute("ssnDataRwType"); 	session.setAttribute("ssnDataRwType", map.get("dataRwType"));
            session.removeAttribute("ssnSearchType"); 	session.setAttribute("ssnSearchType", map.get("searchType"));

            session.removeAttribute("ssnErrorAccYn"); 	session.setAttribute("ssnErrorAccYn", map.get("errorAccYn"));
            session.removeAttribute("ssnErrorAdminYn"); 	session.setAttribute("ssnErrorAdminYn", map.get("errorAdminYn"));

            session.removeAttribute("ssnAdminYn"); 		session.setAttribute("ssnAdminYn", map.get("adminYn"));
            session.removeAttribute("ssnEnterAllYn"); 	session.setAttribute("ssnEnterAllYn", map.get("enterAllYn"));
            session.removeAttribute("ssnPreSrchYn"); 	session.setAttribute("ssnPreSrchYn", map.get("preSrchYn"));
            session.removeAttribute("ssnRetSrchYn"); 	session.setAttribute("ssnRetSrchYn", map.get("retSrchYn"));
            session.removeAttribute("ssnResSrchYn"); 	session.setAttribute("ssnResSrchYn", map.get("resSrchYn"));

            rs = "yes";
        }else{

            rs = "no";
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", rs);
        Log.Debug("MainController.setChangeGrpCd >>> "+session.getAttribute("ssnGrpCdg"));
        return result;
    }

    /**
     * 근무 정보를 전달정다.
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getMainEssWorkTime")
    public Map<String, Object> getWorkTime(
            @RequestBody Map<String, Object> paramMap, HttpSession session) throws Exception {
        Log.Debug(paramMap.toString());
        Map<String, Object> result = new HashMap<>();
        String Message = "";

        try {
            paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
            paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

            Map<String, Object> map = (Map<String, Object>) mainService.getMainEssWorkTime(paramMap);
            if(map != null) {
                result.put("result",map);
            }else{
                result.put("result","");
            }
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
            Log.Debug(e.getMessage());
            result.put("Message", Message);
        }

        return result;
    }

    /**
     * 일정 정보를 전달한다.
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getPlanList")
    public Map<String, Object> getPlanList(
            @RequestBody Map<String, Object> paramMap, HttpSession session) throws Exception {
        Log.Debug(paramMap.toString());
        Map<String, Object> result = new HashMap<>();
        String Message = "";

        try{
            Log.Debug("getPlanList =====");
            paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
//        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
//        paramMap.put("ssnOrgCd", 	session.getAttribute("ssnOrgCd"));

            List<?> list = mainService.getMainEssAnnualPlan(paramMap);
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

}
