package com.hr.cpn.payBonus.bonusReportCre;

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

import com.hr.common.code.CommonCodeService;
import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 *  BonusReportCre Controller
 */
@Controller
@RequestMapping(value="/BonusReportCre.do", method=RequestMethod.POST )
public class BonusReportCreController {

    /**
     * BonusReportCre 서비스
     */
    @Inject
    @Named("BonusReportCreService")
    private BonusReportCreService bonusReportCreService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    /**
     * BonusReportCre View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewBonusReportCre", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBonusReportCre() throws Exception {
        return "cpn/payBonus/bonusReportCre/bonusReportCre";
    }

    /**
     * BonusReportCre 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusReportCreList", method = RequestMethod.POST )
    public ModelAndView getBonusReportCreList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = bonusReportCreService.getBonusReportCreList(paramMap);
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
     * BonusReportCre 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveBonusReportCre", method = RequestMethod.POST )
    public ModelAndView saveBonusReportCre(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        
        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =bonusReportCreService.saveBonusReportCre(convertMap);
            if(resultCnt > 0){ message = LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message = LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
        }catch(Exception e){
            resultCnt = -1; message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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

    /**
     * BonusReportCre 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusReportCreMap", method = RequestMethod.POST )
    public ModelAndView getBonusReportCreMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = bonusReportCreService.getBonusReportCreMap(paramMap);
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
    
    /**
     * Bonus 성과급확인서 생성 프로시저
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=callP_CPN_BONUS_RPT_CRE", method = RequestMethod.POST )
    public ModelAndView callP_CPN_BONUS_RPT_CRE(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
        paramMap.put("searchYear",request.getParameter("searchYear"));
        
        Map<?, ?> map  = bonusReportCreService.callP_CPN_BONUS_RPT_CRE(paramMap);

        Log.Debug("obj : "+map);
        Log.Debug("sqlCode : "+map.get("sqlCode"));
        Log.Debug("sqlErrm : "+map.get("sqlErrm"));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (map.get("sqlCode") != null) {
            resultMap.put("Code", map.get("sqlCode").toString());
        }
        if (map.get("sqlErrm") != null) {
            resultMap.put("Message", map.get("sqlErrm").toString());
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        
        Log.DebugEnd();
        return mv;
    }
    
}
