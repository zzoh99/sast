package com.hr.tim.schedule.workTimeGrpMgr;


import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 근무그룹관리_신규 Controller
 *
 * @author sjt
 *
 */
@Controller
@RequestMapping(value="/WorkTimeGrpMgr.do", method=RequestMethod.POST )
public class WorkTimeGrpMgrController {


    @Inject
    @Named("WorkTimeGrpMgrService")
    private WorkTimeGrpMgrService workTimeGrpMgrService;


    /**
     * 근무그룹관리_신규 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewWorkTimeGrpMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewOrgWorkTimeOrgMgr() throws Exception {
        return "tim/schedule/workTimeGrpMgr/workTimeGrpMgr";
    }

    /**
     * 근무그룹관리_신규 Tab 이동
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewWorkTimeGrpMgrTabs", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView viewOrgWorkTimeOrgMgrTabs() throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("tim/schedule/workTimeGrpMgr/workTimeGrpMgrTabs");
        return mv;
    }

    /**
     * 근무그룹관리 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getWorkPattenMgrGrpList", method = RequestMethod.POST )
    public ModelAndView getWorkPattenMgrGrpList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = workTimeGrpMgrService.getWorkPattenMgrGrpList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    /**
     * 근무그룹관리 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getWorkPattenMgrTimeGrp", method = RequestMethod.POST )
    public ModelAndView getWorkPattenMgrTimeGrp(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<>();
        String Message = "";
        try{
            list = workTimeGrpMgrService.getWorkPattenMgrTimeGrp(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 근무그룹관리 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveWorkPattenMgrGrp", method = RequestMethod.POST )
    public ModelAndView saveWorkPattenMgrGrp(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

//        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        Map<String, Object> convertMap = new HashMap<String, Object>();
        List<Map<String, Object>> mergeRows = new ArrayList<>();
        List<Map<String, Object>> deleteRows = new ArrayList<>();
        mergeRows.add(paramMap);
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        convertMap.put("mergeRows", mergeRows);
        convertMap.put("deleteRows", deleteRows);




        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =workTimeGrpMgrService.saveWorkPattenMgrGrp(convertMap);
            if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
        }catch(Exception e){
            resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("Code", resultCnt);
        resultMap.put("Message", message);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 사용근무시간표 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveWorkPattenMgrTimeGrp", method = RequestMethod.POST )
    public ModelAndView saveWorkPattenMgrTimeGrp(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));



        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =workTimeGrpMgrService.saveWorkPattenMgrTimeGrp(convertMap);
            if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
        }catch(Exception e){
            resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("Code", resultCnt);
        resultMap.put("Message", message);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 근무시간코드 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getTimeCdList", method = RequestMethod.POST )
    public ModelAndView getTimeCdList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnGrpCd", 	session.getAttribute("ssnGrpCd"));

        List<?> result = new ArrayList<>();
        String Message = "";
        try{
            result = workTimeGrpMgrService.getTimeCdList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("data", result);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }
}
