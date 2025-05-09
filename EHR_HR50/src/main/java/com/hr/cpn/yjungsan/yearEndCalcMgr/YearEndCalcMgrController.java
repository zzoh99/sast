package com.hr.cpn.yjungsan.yearEndCalcMgr;

import com.hr.common.com.ComController;
import com.hr.cpn.yjungsan.yearEndItemMgr.YearEndItemMgrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value="/YearEndCalcMgr.do", method= RequestMethod.POST )
public class YearEndCalcMgrController extends ComController {

    @Autowired
    private YearEndItemMgrService yearEndItemMgrService;

    @RequestMapping(params="cmd=viewYearEndCalcMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewYearEndItemMgr() {
        return "cpn/yjungsan/yearEndCalcMgr/yearEndCalcMgr";
    }

}
