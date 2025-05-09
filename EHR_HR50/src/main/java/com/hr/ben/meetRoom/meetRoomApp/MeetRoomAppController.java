package com.hr.ben.meetRoom.meetRoomApp;
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
 * 회의실신청 Controller
 *
 * @author kwook
 *
 */
@Controller
@RequestMapping(value="/MeetRoomApp.do", method=RequestMethod.POST )
public class MeetRoomAppController extends ComController{
    /**
     * 회의실신청 서비스
     */
    @Inject
    @Named("MeetRoomAppService")
    private MeetRoomAppService meetRoomAppService;    
    /**
     * 회의실신청 View
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewMeetRoomApp",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewMeetRoomApp() throws Exception {
        return "ben/meetRoom/meetRoomApp/meetRoomApp";
    }
    
    /**
     * 회의실 신청 다건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getMeetRoomAppList", method = RequestMethod.POST )
    public ModelAndView getMeetRoomAppList(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        List<?> result = meetRoomAppService.getMeetRoomAppList(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
     /**
     * 회의실 삭제 저장 
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=deleteMeetRoomApp", method = RequestMethod.POST )
    public ModelAndView deleteMeetRoomApp(
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
            resultCnt =meetRoomAppService.deleteMeetRoomApp(convertMap);
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
     * 회의실 달력 스케줄 조회
     * */
    @RequestMapping(params="cmd=getMeetRoomSchedule", method = RequestMethod.POST )
    public ModelAndView getMeetRoomSchedule(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        
        Log.DebugStart();
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));

        //조회결과
        List<?>  result = meetRoomAppService.getMeetRoomSchedule(paramMap);
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 회의실 달력 스케줄 조회
     * */
    @RequestMapping(params="cmd=getMeetRoomScheduleDetail", method = RequestMethod.POST )
    public ModelAndView getMeetRoomScheduleDetail(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        
        Log.DebugStart();
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));

        //조회결과
        List<?> result = meetRoomAppService.getMeetRoomScheduleDetail(paramMap);
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }


    /**=====회의실 신청서 화면=====*/
    /**
     * 회의실신청 detail View
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewMeetRoomAppDet",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewMeetRoomAppDet() throws Exception {
        return "ben/meetRoom/meetRoomAppDet/meetRoomAppDet";
    }

    /**
     * 회의실 신청 단건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getMeetRoomAppDetMap", method = RequestMethod.POST )
    public ModelAndView getMeetRoomAppDetMap(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        Map<?, ?> result = meetRoomAppService.getMeetRoomAppDetMap(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 회의실 신청 다건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getMeetRoomInfo", method = RequestMethod.POST )
    public ModelAndView getMeetRoomInfo(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        Map<?, ?> result = meetRoomAppService.getMeetRoomInfo(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 회의실 신청 가능여부 체크
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getEnableMeetRoomApp", method = RequestMethod.POST )
    public ModelAndView getEnableMeetRoomApp(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        List<?> result = meetRoomAppService.getEnableMeetRoomApp(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    
    /**
     * 회의실 신청 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveMeetRoomAppDet", method = RequestMethod.POST )
    public ModelAndView saveMeetRoomAppDet(
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
            resultCnt = meetRoomAppService.saveMeetRoomAppDet(convertMap);

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

    @RequestMapping(params="cmd=getMeetRoomCdList", method = RequestMethod.POST )
    public ModelAndView getMeetRoomCdList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        List<?> result = meetRoomAppService.getMeetRoomCdList(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;

    }
}

