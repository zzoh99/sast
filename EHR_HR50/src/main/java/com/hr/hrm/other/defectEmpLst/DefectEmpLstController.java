package com.hr.hrm.other.defectEmpLst;

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
@RequestMapping(value="/DefectEmpLst.do", method=RequestMethod.POST )
public class DefectEmpLstController {

    @Autowired
    private DefectEmpLstService defectEmpLstService;

    @RequestMapping(params="cmd=viewDefectEmpLst", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewDefectEmpLst() throws Exception {
        return "hrm/other/defectEmpLst/defectEmpLst";
    }

    @RequestMapping(params="cmd=getDefectEmpLstList", method = RequestMethod.POST )
    public ModelAndView getDefectEmpLstList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = defectEmpLstService.getDefectEmpLstList(paramMap);
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
