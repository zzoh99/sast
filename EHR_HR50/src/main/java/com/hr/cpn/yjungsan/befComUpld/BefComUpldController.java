package com.hr.cpn.yjungsan.befComUpld;

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
@RequestMapping(value="/BefComUpld.do", method=RequestMethod.POST )
public class BefComUpldController {
    @Autowired
    private BefComUpldService befComUpldService;

    @RequestMapping(params="cmd=viewBefComUpld", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBefComUpld() {
        return "cpn/yjungsan/befComUpld/befComUpld";
    }

    @RequestMapping(params="cmd=getBefComUpldList", method = RequestMethod.POST )
    public ModelAndView getBefComUpldList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = befComUpldService.getBefComUpldList(paramMap);
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

    @RequestMapping(params="cmd=saveBefComUpld", method = RequestMethod.POST )
    public ModelAndView saveBefComUpld(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = 0;

        try {
            resultCnt = befComUpldService.saveBefComUpld(convertMap);

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