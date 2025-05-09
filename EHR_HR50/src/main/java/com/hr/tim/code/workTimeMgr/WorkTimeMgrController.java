package com.hr.tim.code.workTimeMgr;

import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.tim.code.workTimeMgr.WorkTimeMgrService;
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
 * 근무시간코드설정 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping(value="/WorkTimeMgr.do", method=RequestMethod.POST )
public class WorkTimeMgrController {

    /**
     * 근무시간코드설정 서비스
     */
    @Inject
    @Named("WorkTimeMgrService")
    private WorkTimeMgrService workTimeMgrService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    /**
     * workTimeCdMgr View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewWorkTimeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewWorkTimeMgr() throws Exception {
        return "tim/code/workTimeMgr/workTimeMgr";
    }

    /**
     * workTimeMgr(세부내역) 팝업 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewWorkTimeMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewWorkTimeMgrPop() throws Exception {
        return "tim/code/workTimeMgr/workTimeMgrPop";
    }

    /**
     * workTimeMgr 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getWorkTimeMgrList", method = RequestMethod.POST )
    public ModelAndView getWorkTimeMgrList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = workTimeMgrService.getWorkTimeMgrList(paramMap);
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
     * workTimeCdMgr 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getWorkTimeMgrStdHourList", method = RequestMethod.POST )
    public ModelAndView getWorkTimeMgrStdHourList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = workTimeMgrService.getWorkTimeMgrStdHourList(paramMap);
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
     * workTimeCdMgr 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getWorkTimeMgrMap", method = RequestMethod.POST )
    public ModelAndView getWorkTimeMgrMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = workTimeMgrService.getWorkTimeMgrMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    /**
     * 근무시간코드설정 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveWorkTimeMgr", method = RequestMethod.POST )
    public ModelAndView saveWorkTimeMgr(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        List<Map> insertList = (List<Map>)convertMap.get("insertRows");
        List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();

        for(Map<String,Object> mp : insertList) {
            Map<String,Object> dupMap = new HashMap<String,Object>();
            dupMap.put("ENTER_CD",convertMap.get("ssnEnterCd"));
            dupMap.put("TIME_CD",mp.get("timeCd"));
            dupList.add(dupMap);
        }

        String message = "";
        int resultCnt = -1;
        try{
            int dupCnt = 0;

            if(insertList.size() > 0) {
                // 중복검사
                dupCnt = commonCodeService.getDupCnt("TTIM017", "ENTER_CD,TIME_CD", "s,s",dupList);
            }

            if(dupCnt > 0) {
                resultCnt = -1; message= LanguageUtil.getMessage("msg.alertDataDup", null, "중복되어 저장할 수 없습니다.");
            } else {
                resultCnt =workTimeMgrService.saveWorkTimeMgr(convertMap);
                if(resultCnt > 0){ message=LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
            }
        }catch(Exception e){
            resultCnt = -1; message=LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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
     * 예외인정근무시간 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveWorkTimeMgrStdHour", method = RequestMethod.POST )
    public ModelAndView saveWorkManagerMgr(
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
            resultCnt =workTimeMgrService.saveWorkTimeMgrStdHour(convertMap);
            if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
        }catch(Exception e){
            resultCnt = -1; message="저장에 실패하였습니다.";
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
     * 일일근무스케쥴 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveWorkDaySchedule", method = RequestMethod.POST )
    public ModelAndView saveOrgChangeSchemeMgr(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try{

            resultCnt = workTimeMgrService.saveWorkDaySchedule(convertMap);
            if(resultCnt > 0){
                message="저장되었습니다.";
            } else{
                message="저장된 내용이 없습니다.";
            }
        }catch(Exception e){
            resultCnt = -1; message="저장에 실패하였습니다.";
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
}
