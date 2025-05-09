package com.hr.ben.apply;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping({"/BenApply.do"})
public class BenApplyController {

    /**
     * 복리후생 신청 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewBenApply",method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewBenApply() throws Exception {
        return "ben/apply/benApply";
    }
}
