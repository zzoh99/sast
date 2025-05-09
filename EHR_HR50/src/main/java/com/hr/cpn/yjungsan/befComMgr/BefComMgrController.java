package com.hr.cpn.yjungsan.befComMgr;

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
@RequestMapping(value="/BefComMgr.do", method=RequestMethod.POST )
public class BefComMgrController {

    @Autowired
    private BefComMgrService befComMgrService;

    @RequestMapping(params="cmd=viewBefComMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBefComMgr() {
        return "cpn/yjungsan/befComMgr/befComMgr";
    }

    @RequestMapping(params="cmd=viewBefComMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBefComMgrPopup() {
        return "cpn/yjungsan/befComMgr/befComMgrPopup";
    }

    @RequestMapping(params="cmd=getNoTaxCodeList", method = RequestMethod.POST )
    public ModelAndView getNoTaxCodeList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = befComMgrService.getNoTaxCodeList(paramMap);
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


    @RequestMapping(params="cmd=getBefComMgr", method = RequestMethod.POST )
    public ModelAndView getBefComMgr(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = befComMgrService.getBefComMgr(paramMap);
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

    @RequestMapping(params="cmd=getBefComMgrNoTax", method = RequestMethod.POST )
    public ModelAndView getBefComMgrNoTax(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = befComMgrService.getBefComMgrNoTax(paramMap);
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

    @RequestMapping(params="cmd=saveBefComMgr", method = RequestMethod.POST )
    public ModelAndView saveBefComMgr(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = 0;

        try {
            resultCnt = befComMgrService.saveBefComMgr(convertMap);

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

    @RequestMapping(params="cmd=saveBefComMgrNoTax", method = RequestMethod.POST )
    public ModelAndView saveBefComMgrNoTax(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = 0;

        try {
            resultCnt = befComMgrService.saveBefComMgrNoTax(convertMap);

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
