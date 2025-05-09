package com.hr.ben.carAllocate.carAllocateApp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 업무차량배차신청 Controller
 *
 * @author kwook
 *
 */
@Controller
@RequestMapping(value="/CarAllocateApp.do", method=RequestMethod.POST )
public class CarAllocateAppController extends ComController{
    /**
     * 업무차량배차신청 서비스
     */
    @Inject
    @Named("CarAllocateAppService")
    private CarAllocateAppService carAllocateAppService;    
    /**
     * 업무차량배차신청 View
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewCarAllocateApp",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewCarAllocateApp() throws Exception {
        return "ben/carAllocate/carAllocateApp/carAllocateApp";
    }
    
    /**
     * 업무차량배차 신청 다건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getCarAllocateAppList", method = RequestMethod.POST )
    public ModelAndView getCarAllocateAppList(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        List<?> result = carAllocateAppService.getCarAllocateAppList(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 업무차량배차 신청 코드 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getCarAllocateCdList", method = RequestMethod.POST )
    public ModelAndView getCarAllocateCdList(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        List<?> result = carAllocateAppService.getCarAllocateCdList(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
     /**
     * 업무차량배차 삭제 저장 
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=deleteCarAllocateApp", method = RequestMethod.POST )
    public ModelAndView deleteCarAllocateApp(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =carAllocateAppService.deleteCarAllocateApp(convertMap);
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
     * 업무차량배차 달력 스케줄 조회
     * */
    @RequestMapping(params="cmd=getCarAllocateSchedule", method = RequestMethod.POST )
    public ModelAndView getCarAllocateSchedule(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        
        Log.DebugStart();
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));

        //조회결과
        List<?> result = carAllocateAppService.getCarAllocateSchedule(paramMap);
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 업무차량배차 달력 스케줄 조회
     * */
    @RequestMapping(params="cmd=getCarAllocateScheduleDetail", method = RequestMethod.POST )
    public ModelAndView getCarAllocateScheduleDetail(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        
        Log.DebugStart();
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));

        //조회결과
        List<?> result = carAllocateAppService.getCarAllocateScheduleDetail(paramMap);
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }


    /**=====업무차량배차 신청서 화면=====*/
    /**
     * 업무차량배차신청 detail View
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewCarAllocateAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewCarAllocateAppDet() throws Exception {
        return "ben/carAllocate/carAllocateAppDet/carAllocateAppDet";
    }

    /**
     * 업무차량배차 신청 단건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getCarAllocateAppDetMap", method = RequestMethod.POST )
    public ModelAndView getCarAllocateAppDetMap(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        Map<?, ?> result = carAllocateAppService.getCarAllocateAppDetMap(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 업무차량배차 신청 다건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getCarAllocateInfo", method = RequestMethod.POST )
    public ModelAndView getCarAllocateInfo(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        Map<?, ?> result = carAllocateAppService.getCarAllocateInfo(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 업무차량배차 신청 가능여부 체크
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getEnableCarAllocateApp", method = RequestMethod.POST )
    public ModelAndView getEnableCarAllocateApp(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        List<?> result = carAllocateAppService.getEnableCarAllocateApp(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 업무차량배차 신청 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveCarAllocateAppDet", method = RequestMethod.POST )
    public ModelAndView saveCarAllocateAppDet(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
/*
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        String message = "";
        int resultCnt = -1;

        try{
            resultCnt = carAllocateAppService.saveCarAllocateAppDet(convertMap);

            if(resultCnt > 0){
                message="저장 되었습니다.";
            } else {
                if ("".equals(message)) {
                    message="처리된 내용이 없습니다.";
                }
            }
        } catch(Exception e) {
            Log.Debug(e.getLocalizedMessage());
            resultCnt = -1; message="저장을 실패하였습니다.";
        }

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("Code", resultCnt);
        resultMap.put("Message", message);

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);

        Log.DebugEnd();
        return mv;*/
        return saveData(session, request, paramMap);
        
    }
    
}

