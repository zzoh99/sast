package com.hr.cpn.perExpense.retAllowanceSta;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 퇴직충당금조회 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/RetAllowanceSta.do", method=RequestMethod.POST )
public class RetAllowanceStaController {
    /**
     * 퇴직충당금조회 서비스
     */
    @Inject
    @Named("RetAllowanceStaService")
    private RetAllowanceStaService retAllowanceStaService;

    /**
     * 퇴직충당금조회 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewRetAllowanceSta", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewRetAllowanceSta() throws Exception {
        return "cpn/perExpense/retAllowanceSta/retAllowanceSta";
    }

    /**
     * 퇴직충당금조회(세부내역) 팝업 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewRetAllowanceStaLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewRetAllowanceStaLayer() throws Exception {
        return "cpn/perExpense/retAllowanceSta/retAllowanceStaLayer";
    }

    /**
     * 퇴직충당금조회 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getRetAllowanceStaList", method = RequestMethod.POST )
    public ModelAndView getRetAllowanceStaList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = retAllowanceStaService.getRetAllowanceStaList(paramMap);
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

    /**
     * 퇴직충당금조회 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getRetAllowanceStaPopList", method = RequestMethod.POST )
    public ModelAndView getRetAllowanceStaPopList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = retAllowanceStaService.getRetAllowanceStaPopList(paramMap);
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

    /**
     * 퇴직충당금조회 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception exception
     */
    @RequestMapping(params="cmd=saveRetAllowanceSta", method = RequestMethod.POST )
    public ModelAndView saveRetAllowanceSta(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        try {
            int resultCnt = retAllowanceStaService.saveRetAllowanceSta(convertMap);
            resultMap.put("Code", resultCnt);
            if(resultCnt > 0) {
                resultMap.put("Message", "저장 되었습니다.");
            } else {
                resultMap.put("Message", "저장된 내용이 없습니다.");
            }
        } catch(Exception e) {
            resultMap.put("Code", -1);
            resultMap.put("Message", "저장에 실패하였습니다.");
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        Log.DebugEnd();
        return mv;
    }
}
