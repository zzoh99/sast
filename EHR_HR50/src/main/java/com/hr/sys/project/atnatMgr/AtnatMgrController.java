package com.hr.sys.project.atnatMgr;

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.common.util.StringUtil;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="AtnatMgr.do", method=RequestMethod.POST )
public class AtnatMgrController {

    @Inject
    @Named("AtnatMgrService")
    private AtnatMgrService atnatMgrService;

    @RequestMapping(params="cmd=viewAtnatMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewAtnatMgr() {
        return "sys/project/atnatMgr/atnatMgr";
    }

    @RequestMapping(params="cmd=viewAtnatMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewAtnatMgrLayer() {
        return "sys/project/atnatMgr/atnatMgrLayer";
    }

    @RequestMapping(params="cmd=getAtnatList", method = RequestMethod.POST )
    public ModelAndView getAtnatList(HttpSession session, HttpServletRequest request
                , @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        List<?> list = new ArrayList<>();
        String message = null;

        try {
            list = atnatMgrService.getAtnatList(paramMap);
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

    @RequestMapping(params="cmd=saveAtnatApp", method = RequestMethod.POST )
    public ModelAndView saveAtnatApp(HttpSession session, HttpServletRequest request
                , @RequestParam Map<String, Object> paramMap) throws Exception {
        Map<String, Object> convertMap = new HashMap<>();
        convertMap = ParamUtils.requestInParamsMultiDML(request, StringUtil.join(paramMap.keySet().toArray(), ","),"");
        convertMap.put("cmd",paramMap.get("cmd"));
        convertMap.put("s_SAVENAME",StringUtil.join(paramMap.keySet().toArray(), ","));
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        int resultCnt;
        String code;
        String defaultMsg;

        try {
            resultCnt = atnatMgrService.saveAtnatApp(convertMap);
            code = resultCnt > 0 ? "msg.alertSaveOkV1" :  "msg.alertSaveNoData";
            defaultMsg = resultCnt > 0 ? "저장 되었습니다." : "저장된 내용이 없습니다.";
        }catch (Exception e) {
            resultCnt = -1;
            code = "msg.alertSaveFail2";
            defaultMsg = "저장에 실패하였습니다.";
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("Code", resultCnt);
        resultMap.put("Message", LanguageUtil.getMessage(code, null, defaultMsg));

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=deleteAtnatApp", method = RequestMethod.POST )
    public ModelAndView deleteAtnatApp(HttpSession session, HttpServletRequest request
                , @RequestParam Map<String, Object> paramMap) throws Exception {
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        int resultCnt;
        String code;
        String defaultMsg;

        try {
            resultCnt = atnatMgrService.deleteAtnatApp(paramMap);
            code = resultCnt > 0 ? "msg.alertSaveOkV1" :  "msg.alertSaveNoData";
            defaultMsg = resultCnt > 0 ? "저장 되었습니다." : "저장된 내용이 없습니다.";
        }catch (Exception e) {
            resultCnt = -1;
            code = "msg.alertSaveFail2";
            defaultMsg = "저장에 실패하였습니다.";
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("Code", resultCnt);
        resultMap.put("Message", LanguageUtil.getMessage(code, null, defaultMsg));

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getAtnatAppMap", method = RequestMethod.POST )
    public ModelAndView getAtnatAppMap(HttpSession session, HttpServletRequest request
                , @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        Map<?, ?> map = null;
        String message = null;

        try {
            map = atnatMgrService.getAtnatAppMap(paramMap);
        }catch (Exception e) {
            message = "조회에 실패했습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", message);
        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getAtnatAppDupCheck", method = RequestMethod.POST )
    public ModelAndView getAtnatAppDupCheck(HttpSession session, HttpServletRequest request
                , @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        Map<?, ?> map = null;
        String message = null;

        try {
            map = atnatMgrService.getAtnatAppDupCheck(paramMap);
        }catch (Exception e) {
            message = "조회에 실패했습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", map);
        mv.addObject("Message", message);
        Log.DebugEnd();
        return mv;
    }

}
