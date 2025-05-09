package com.hr.sys.project.meetingLogMgr;

import com.hr.common.logger.Log;
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
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="MeetingLogMgr.do", method=RequestMethod.POST )
public class MeetingLogMgrController {

    @Inject
    @Named("MeetingLogMgrService")
    private MeetingLogMgrService meetingLogMgrService;

    @RequestMapping(params="cmd=viewMeetingLogListBoard", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewMeetingLogMgr() {
        return "sys/project/meetingLogMgr/meetingLogMgr";
    }

    @RequestMapping(params="cmd=getModuleList", method = RequestMethod.POST )
    public ModelAndView getModuleList(HttpSession session, HttpServletRequest request
                , @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        List<?> list = new ArrayList<>();
        String message = null;

        try {
            list = meetingLogMgrService.getModuleList(paramMap);
        }catch (Exception e) {
            message = "조회에 실패했습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", message);
        Log.DebugEnd();
        return mv;
    }
}
