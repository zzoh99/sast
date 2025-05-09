package com.hr.cpn.payBonus.bonusDiv;

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
 *  bonusDiv Controller
 */
@Controller
@RequestMapping(value="/BonusDiv.do", method=RequestMethod.POST )
public class BonusDivController {

    /**
     * bonusDiv 서비스
     */
    @Inject
    @Named("BonusDivService")
    private BonusDivService bonusDivService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    /**
     * bonusDiv View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewBonusDiv", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewbonusDiv() throws Exception {
        return "cpn/payBonus/bonusDiv/bonusDiv";
    }

    /**
     * bonusDiv 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusDivList", method = RequestMethod.POST )
    public ModelAndView getbonusDivList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = bonusDivService.getBonusDivList(paramMap);
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
     * bonusDiv 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusDivDetailList", method = RequestMethod.POST )
    public ModelAndView getbonusDivDetailList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = bonusDivService.getBonusDivDetailList(paramMap);
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
     * bonusDiv 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveBonusDiv", method = RequestMethod.POST )
    public ModelAndView saveBonusDiv(
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
            resultCnt =bonusDivService.saveBonusDiv(convertMap);
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
     * bonusDiv 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusDivMap", method = RequestMethod.POST )
    public ModelAndView getbonusDivMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = bonusDivService.getBonusDivMap(paramMap);
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
     * BonusDiv 대상자생성 프로시저
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=callP_CPN_BONUS_DIV_EMP_CRE", method = RequestMethod.POST )
    public ModelAndView callP_CPN_BONUS_DIV_EMP_CRE(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
        paramMap.put("searchYear",request.getParameter("searchYear"));
        paramMap.put("searchBonusGrp",request.getParameter("searchBonusGrp"));
        
        Map<?, ?> map  = bonusDivService.callP_CPN_BONUS_DIV_EMP_CRE(paramMap);

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
    

    /**
     * BonusDiv 배분실행 프로시저
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=callP_CPN_BONUS_DIV_MON_CRE", method = RequestMethod.POST )
    public ModelAndView callP_CPN_BONUS_DIV_MON_CRE(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
        paramMap.put("searchYear",request.getParameter("searchYear"));
        paramMap.put("searchBonusGrp",request.getParameter("searchBonusGrp"));
        
        Map<?, ?> map  = bonusDivService.callP_CPN_BONUS_DIV_MON_CRE(paramMap);

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
