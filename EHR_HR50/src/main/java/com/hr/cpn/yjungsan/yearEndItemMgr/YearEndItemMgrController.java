package com.hr.cpn.yjungsan.yearEndItemMgr;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/YearEndItemMgr.do", method=RequestMethod.POST )
public class YearEndItemMgrController extends ComController {

    @Autowired
    private YearEndItemMgrService yearEndItemMgrService;

    @RequestMapping(params="cmd=viewYearEndItemMgrNew", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewYearEndItemMgrNew() {
        return "cpn/yjungsan/yearEndItemMgr/yearEndItemMgrNew";
    }

    @RequestMapping(params="cmd=viewYearEndItemMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewYearEndItemMgr() {
        return "cpn/yjungsan/yearEndItemMgr/yearEndItemMgr";
    }

    @RequestMapping(params="cmd=viewYearEndItemMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewYearEndItemMgrPopup() {
        return "cpn/yjungsan/yearEndItemMgr/yearEndItemMgrPopup";
    }


    @RequestMapping(params="cmd=viewYearEndItemMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewYearEndItemMgrLayer() {
        return "cpn/yjungsan/yearEndItemMgr/yearEndItemMgrLayer";
    }

    //연말정산 항목 프로세스 검색
    @RequestMapping(params="cmd=getYearEndItemMgrProcess", method = RequestMethod.POST )
    public ModelAndView getYearEndItemMgrProcess(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = yearEndItemMgrService.getYearEndItemMgrProcess(paramMap);
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

    //연말정산 항목 검색
    @RequestMapping(params="cmd=getYearEndItemMgr", method = RequestMethod.POST )
    public ModelAndView getYearEndItemMgr(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = yearEndItemMgrService.getYearEndItemMgr(paramMap);
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

    @RequestMapping(params="cmd=getYearEndItemMgrPopup", method = RequestMethod.POST )
    public ModelAndView getYearEndItemMgrPopup(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = yearEndItemMgrService.getYearEndItemMgrPopup(paramMap);
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

    @RequestMapping(params="cmd=saveYearEndItemMgrProcess", method = RequestMethod.POST )
    public ModelAndView saveYearEndItemMgrProcess(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = 0;

        try {
            resultCnt = yearEndItemMgrService.saveYearEndItemMgrProcess(convertMap);

            if(resultCnt > 0) {
                message = "저장되었습니다.";
            } else {
                message = "저장에 실패하였습니다.";
            }
        } catch(Exception e) {
            e.printStackTrace();
            message = e.getMessage();
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

    @RequestMapping(params="cmd=saveYearEndItemMgr", method = RequestMethod.POST )
    public ModelAndView saveYearEndItemMgr(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = 0;

        try {
            resultCnt = yearEndItemMgrService.saveYearEndItemMgr(convertMap);

            if(resultCnt > 0) {
                message = "저장되었습니다.";
            } else {
                message = "저장에 실패하였습니다.";
            }
        } catch(Exception e) {
            e.printStackTrace();
            message = e.getMessage();
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

    @RequestMapping(params="cmd=getYearEndItemMgrPopupSub", method = RequestMethod.POST )
    public ModelAndView getYearEndItemMgrPopupSub(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = yearEndItemMgrService.getYearEndItemMgrPopupSub(paramMap);
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

    @RequestMapping(params="cmd=saveYearEndItemMgrPopupSub", method = RequestMethod.POST )
    public ModelAndView saveYearEndItemMgrPopupSub(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = 0;

        try {
            resultCnt = yearEndItemMgrService.saveYearEndItemMgrPopupSub(convertMap);

            if(resultCnt > 0) {
                message = "저장되었습니다.";
            } else {
                message = "저장에 실패하였습니다.";
            }
        } catch(Exception e) {
            e.printStackTrace();
            message = e.getMessage();
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
