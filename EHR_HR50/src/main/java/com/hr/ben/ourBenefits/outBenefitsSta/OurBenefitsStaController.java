package com.hr.ben.ourBenefits.outBenefitsSta;

import com.hr.common.language.LanguageUtil;
import com.hr.common.logger.Log;
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
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value= "/OurBenefitsSta.do", method= RequestMethod.POST)
public class OurBenefitsStaController {
    /**
     * 우리회사 복리후생 서비스
     */
    @Inject
    @Named("OurBenefitsStaService")
    private OurBenefitsStaService ourBenefitsStaService;

    /**
     * 우리회사 복리후생 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params = "cmd=viewOurBenefitsSta", method = {RequestMethod.POST, RequestMethod.GET } )
    public String viewOurBenefitsSta() {
        return "ben/ourBenefits/ourBenefitsSta/ourBenefitsSta";
    }

    /**
     * 우리회사 복리후생 항목 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params = "cmd=getOurCompanyBenefits", method = RequestMethod.POST)
    public ModelAndView getOurCompanyBenefits(
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
            List<Map<String, Object>> list = ourBenefitsStaService.getOurCompanyBenefits(paramMap);
            mv.addObject("benefits", list);
        } catch(Exception e) {
            Log.Error(" ** 우리회사 복리후생 조회 실패 >> " + e.getLocalizedMessage());
            mv.addObject("benefits", new ArrayList<>());
            mv.addObject("message", LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다."));
        }

        try {
            List<Map<String, Object>> list = ourBenefitsStaService.getOurCompanyBenefitCategories(paramMap);
            mv.addObject("categories", list);
        } catch(Exception e) {
            Log.Error(" ** 카테고리 조회 실패 >> " + e.getLocalizedMessage());
            mv.addObject("categories", new ArrayList<>());
            mv.addObject("message", LanguageUtil.getMessage("msg.alertSearchFail2", null, "조회에 실패하였습니다."));
        }

        Log.DebugEnd();
        return mv;
    }
}
