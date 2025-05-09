package com.hr.cpn.perExpense.bonusAdjustMonSta;
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
 * 상여조정액조회 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/BonusAdjustMonSta.do", method=RequestMethod.POST )
public class BonusAdjustMonStaController {
    /**
     * 상여조정액조회 서비스
     */
    @Inject
    @Named("BonusAdjustMonStaService")
    private BonusAdjustMonStaService bonusAdjustMonStaService;

    /**
     * 상여조정액조회 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewBonusAdjustMonSta", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBonusAdjustMonSta() throws Exception {
        return "cpn/perExpense/bonusAdjustMonSta/bonusAdjustMonSta";
    }

    /**
     * 상여조정액조회(세부내역) 팝업 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewBonusAdjustMonStaPop", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBonusAdjustMonStaPop() throws Exception {
        return "cpn/perExpense/bonusAdjustMonSta/bonusAdjustMonStaPop";
    }

    /**
     * 상여조정액조회 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusAdjustMonStaList", method = RequestMethod.POST )
    public ModelAndView getBonusAdjustMonStaList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = bonusAdjustMonStaService.getBonusAdjustMonStaList(paramMap);
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
     * 상여조정액조회 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveBonusAdjustMonSta", method = RequestMethod.POST )
    public ModelAndView saveBonusAdjustMonSta(
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
            resultCnt =bonusAdjustMonStaService.saveBonusAdjustMonSta(convertMap);
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
