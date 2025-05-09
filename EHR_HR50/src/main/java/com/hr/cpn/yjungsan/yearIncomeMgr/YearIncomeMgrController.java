package com.hr.cpn.yjungsan.yearIncomeMgr;

import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/YearIncomeMgr.do", method=RequestMethod.POST )
public class YearIncomeMgrController {

    @Autowired
    private YearIncomeMgrService yearIncomeMgrService;

    @RequestMapping(params="cmd=viewYearIncomeMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewYearIncomeMgr() {
        return "cpn/yjungsan/yearIncomeMgr/yearIncomeMgr";
    }

    @RequestMapping(params="cmd=getYearIncomeMgrList", method = RequestMethod.POST )
    public ModelAndView getBefComUpldList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = yearIncomeMgrService.getYearIncomeMgrList(paramMap);
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

    @RequestMapping(params="cmd=getYearIncomeMgrEtc", method = RequestMethod.POST )
    public ModelAndView getYearIncomeMgrEtc(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = yearIncomeMgrService.getYearIncomeMgrEtc(paramMap);
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
}
