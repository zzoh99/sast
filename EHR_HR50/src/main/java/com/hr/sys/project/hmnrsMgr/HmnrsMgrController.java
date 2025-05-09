package com.hr.sys.project.hmnrsMgr;

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
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
@RequestMapping(value="HmnrsMgr.do", method=RequestMethod.POST )
public class HmnrsMgrController {

    @Inject
    @Named("HmnrsMgrService")
    private HmnrsMgrService hmnrsMgrService;

    @RequestMapping(params="cmd=viewHmnrsMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewHmnrsMgr() {
        return "sys/project/hmnrsMgr/hmnrsMgr";
    }

    @RequestMapping(params="cmd=getHmnrsMgr", method = RequestMethod.POST )
    public ModelAndView getHmnrsMgr(HttpSession session, HttpServletRequest request
                , @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        List<?> list = new ArrayList<>();
        String message = null;

        try {
            list = hmnrsMgrService.getHmnrsMgr(paramMap);
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

    @RequestMapping(params="cmd=saveHmnrsMgr", method = RequestMethod.POST )
    public ModelAndView saveHmnrsMgr(HttpSession session, HttpServletRequest request
                , @RequestParam Map<String, Object> paramMap) throws Exception {
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request, paramMap.get("s_SAVENAME").toString(), "");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        int resultCnt;
        String code;
        String defaultMsg;

        try {
            resultCnt = hmnrsMgrService.saveHmnrsMgr(convertMap);
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



}
