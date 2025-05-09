package com.hr.cpn.payBonus.bonusGrpMgr;

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
 *  BonusGrpMgr Controller
 */
@Controller
@RequestMapping(value="/BonusGrpMgr.do", method=RequestMethod.POST )
public class BonusGrpMgrController {

    /**
     * BonusGrpMgr 서비스
     */
    @Inject
    @Named("BonusGrpMgrService")
    private BonusGrpMgrService bonusGrpMgrService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    /**
     * BonusGrpMgr View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewBonusGrpMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBonusGrpMgr() throws Exception {
        return "cpn/payBonus/bonusGrpMgr/bonusGrpMgr";
    }

    /**
     * BonusGrpMgr(세부내역) 팝업 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewBonusGrpMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBonusGrpMgrPop() throws Exception {
        return "cpn/payBonus/bonusGrpMgr/bonusGrpMgrPop";
    }

    /**
     * BonusGrpMgr 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusGrpMgrList", method = RequestMethod.POST )
    public ModelAndView getBonusGrpMgrList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",   session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = bonusGrpMgrService.getBonusGrpMgrList(paramMap);
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
     * BonusGrpMgr 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveBonusGrpMgr", method = RequestMethod.POST )
    public ModelAndView saveBonusGrpMgr(
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
            resultCnt =bonusGrpMgrService.saveBonusGrpMgr(convertMap);
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
     * BonusGrpMgr 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusGrpMgrMap", method = RequestMethod.POST )
    public ModelAndView getBonusGrpMgrMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = bonusGrpMgrService.getBonusGrpMgrMap(paramMap);
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
}
