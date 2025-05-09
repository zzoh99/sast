package com.hr.ben.ourBenefits.outBenefitsMgr;

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
@RequestMapping(value="/OurBenefitsMgr.do", method= RequestMethod.POST)
public class OurBenefitsMgrController {
    /**
     * 우리회사 복리후생 관리 서비스
     */
    @Inject
    @Named("OurBenefitsMgrService")
    private OurBenefitsMgrService ourBenefitsMgrService;

    /**
     * 우리회사 복리후생 관리 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params = "cmd=viewOurBenefitsMgr", method = {RequestMethod.POST, RequestMethod.GET } )
    public String viewOurBenefitsMgr() {
        return "ben/ourBenefits/ourBenefitsMgr/ourBenefitsMgr";
    }

    /**
     * 우리회사 복리후생 관리 항목 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params = "cmd=getOurBenefitsMgr", method = RequestMethod.POST)
    public ModelAndView getOurBenefitsMgr(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {

        Log.DebugStart();

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");

        paramMap.put("ssnSabun",		session.getAttribute("ssnSabun"));
        paramMap.put("ssnEnterCd",		session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSearchType",	session.getAttribute("ssnSearchType"));
        paramMap.put("ssnGrpCd",		session.getAttribute("ssnGrpCd"));

        try {
            List<Map<String, Object>> list = ourBenefitsMgrService.getOurBenefitsMgr(paramMap);
            mv.addObject("DATA", list);
        } catch(Exception e) {
            Log.Error(" ** 우리회사 복리후생 관리 조회 실패 >> " + e.getLocalizedMessage());
            mv.addObject("DATA", new ArrayList<>());
            mv.addObject("message", LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다."));
        }

        Log.DebugEnd();
        return mv;
    }

    /**
     * 우리회사 복리후생 항목 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params = "cmd=saveOurBenefitsMgr", method = RequestMethod.POST)
    public ModelAndView saveOurBenefitsMgr(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try {
            resultCnt = ourBenefitsMgrService.saveOurBenefitsMgr(convertMap);
            if (resultCnt > 0) {
                message = "저장되었습니다.";
            } else {
                message = "저장된 내용이 없습니다.";
            }
        } catch (Exception e) {
            Log.Error(" ** 우리회사 복리후생 관리 저장 실패 >> " + e.getLocalizedMessage());
            message = LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
        }
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("Code", resultCnt);
        resultMap.put("Message", message);

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        Log.DebugEnd();
        return mv;
    }
}
