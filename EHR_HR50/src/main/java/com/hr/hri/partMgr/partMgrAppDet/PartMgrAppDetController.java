package com.hr.hri.partMgr.partMgrAppDet;

import com.hr.common.logger.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
@RequestMapping({"/PartMgrApp.do", "/PartMgrAppDet.do"})
public class PartMgrAppDetController {

    @Autowired
    private PartMgrAppDetService partMgrAppDetService;

    @RequestMapping(params="cmd=viewPartMgrAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewPartMgrAppDet() throws Exception {
        return "hri/partMgr/partMgrAppDet/partMgrAppDet";
    }

    @RequestMapping(params="cmd=getPartMgrAppDet", method = RequestMethod.POST )
    public ModelAndView getPartMgrAppDet(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = partMgrAppDetService.getPartMgrAppDet(paramMap);
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

    @RequestMapping(params="cmd=getPartMgrAppDetCurEmp", method = RequestMethod.POST )
    public ModelAndView getPartMgrAppDetCurEmp(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = partMgrAppDetService.getPartMgrAppDetCurEmp(paramMap);
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

}
