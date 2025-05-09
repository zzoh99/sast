package com.hr.cpn.personalPay.salaryPeakMgr;

import java.util.ArrayList;
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

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;

/**
 * 임금피크대상자 관리 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/SalaryPeakMgr.do", method=RequestMethod.POST )
public class SalaryPeakMgrController extends ComController {

    @Inject
    @Named("SalaryPeakMgrService")
    private SalaryPeakMgrService salaryPeakMgrService;

	/**
	 * 임금피크대상자 관리 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSalaryPeakMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSalaryPeakMgr() throws Exception {
		return "cpn/personalPay/salaryPeakMgr/salaryPeakMgr";
	}

	/**
	 *  다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSalaryPeakMgrList", method = RequestMethod.POST )
	public ModelAndView getSalaryPeakMgrList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	/**
	 *  저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveSalaryPeakMgr", method = RequestMethod.POST )
	public ModelAndView saveSalaryPeakMgr(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return saveData(session, request, paramMap);
	}

    @RequestMapping(params="cmd=getYearCombo", method = RequestMethod.POST )
    public ModelAndView getYearCombo(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = salaryPeakMgrService.getYearCombo(paramMap);
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

}
