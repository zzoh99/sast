package com.hr.cpn.yjungsan.befComLst;

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
@RequestMapping(value="/BefComLst.do", method=RequestMethod.POST )
public class BefComLstController {
    @Autowired
    private BefComLstService befComLstService;

    @RequestMapping(params="cmd=viewBefComLst", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBefComLst() {
        return "cpn/yjungsan/befComLst/befComLst";
    }

    @RequestMapping(params="cmd=getBefComLstList", method = RequestMethod.POST )
    public ModelAndView getBefComLstList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = befComLstService.getBefComLstList(paramMap);
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
