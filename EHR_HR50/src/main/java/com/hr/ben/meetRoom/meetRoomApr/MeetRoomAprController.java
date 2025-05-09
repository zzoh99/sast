package com.hr.ben.meetRoom.meetRoomApr;
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

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
/**
 * 회의실승인 Controller
 *
 * @author kwook
 *
 */
@Controller
@RequestMapping(value="/MeetRoomApr.do", method=RequestMethod.POST )
public class MeetRoomAprController extends ComController{
    
    /**
     * 회의실승인 서비스
     */
    @Inject
    @Named("MeetRoomAprService")
    private MeetRoomAprService meetRoomAprService;

    @Inject
    @Named("AuthTableService")
    private AuthTableService authTableService;
    
    /**
     * 회의실 승인 View
     * 
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewMeetRoomApr",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewMeetRoomMgr() throws Exception {
        return "ben/meetRoom/meetRoomApr/meetRoomApr";
    }
    
    /**
     * 회의실 승인 다건 조회
     * 
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getMeetRoomAprList", method = RequestMethod.POST )
    public ModelAndView getMeetRoomAprList(
            HttpSession session,  HttpServletRequest request, 
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        
        paramMap.put("ssnEnterCd",      session.getAttribute("ssnEnterCd"));
        
        Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
        Log.Debug("query.get=> "+ query.get("query"));
        paramMap.put("query", query.get("query"));
        
        List<?> result = meetRoomAprService.getMeetRoomAprList(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", result);
        Log.DebugEnd();
        return mv;
        
    }
    

    /**
     * 회의실 승인 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveMeetRoomApr", method = RequestMethod.POST )
    public ModelAndView saveMeetRoomApr(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");

        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        convertMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        String message = "";
        int resultCnt = -1;

        try{
            resultCnt = meetRoomAprService.saveMeetRoomApr(convertMap);

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
        return mv;
    }
}
