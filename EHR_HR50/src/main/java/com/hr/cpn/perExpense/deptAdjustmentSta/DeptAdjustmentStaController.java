package com.hr.cpn.perExpense.deptAdjustmentSta;
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
 * 부채정산조회 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/DeptAdjustmentSta.do", method=RequestMethod.POST )
public class DeptAdjustmentStaController {
    /**
     * 부채정산조회 서비스
     */
    @Inject
    @Named("DeptAdjustmentStaService")
    private DeptAdjustmentStaService deptAdjustmentStaService;

    /**
     * 부채정산조회 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewDeptAdjustmentSta", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewDeptAdjustmentSta() throws Exception {
        return "cpn/perExpense/deptAdjustmentSta/deptAdjustmentSta";
    }

    /**
     * 부채정산조회(세부내역) 팝업 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewDeptAdjustmentStaPop", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewDeptAdjustmentStaPop() throws Exception {
        return "cpn/perExpense/deptAdjustmentSta/deptAdjustmentStaPop";
    }

    /**
     * 부채정산조회 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getDeptAdjustmentStaList", method = RequestMethod.POST )
    public ModelAndView getDeptAdjustmentStaList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = deptAdjustmentStaService.getDeptAdjustmentStaList(paramMap);
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
     * 부채정산조회 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveDeptAdjustmentSta", method = RequestMethod.POST )
    public ModelAndView saveDeptAdjustmentSta(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =deptAdjustmentStaService.saveDeptAdjustmentSta(convertMap);
            if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
        }catch(Exception e){
            resultCnt = -1; message="저장에 실패하였습니다.";
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
