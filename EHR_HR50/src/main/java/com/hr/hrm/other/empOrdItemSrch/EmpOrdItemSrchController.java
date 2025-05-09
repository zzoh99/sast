package com.hr.hrm.other.empOrdItemSrch;

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
@RequestMapping(value="/EmpOrdItemSrch.do", method=RequestMethod.POST )
public class EmpOrdItemSrchController {

    @Autowired
    private EmpOrdItemSrchService empOrdItemSrchService;

    @RequestMapping(params="cmd=viewEmpOrdItemSrch", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewEmpOrdItemSrch() throws Exception {
        return "hrm/other/empOrdItemSrch/empOrdItemSrch";
    }

    @RequestMapping(params="cmd=getEmpOrdItemSrchVer2List", method = RequestMethod.POST )
    public ModelAndView getEmpOrdItemSrchVer2List(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = empOrdItemSrchService.getEmpOrdItemSrchVer2List(paramMap);
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
