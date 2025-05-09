package com.hr.hrm.other.empAddressSrch;

import java.util.Map;

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
 * 임직원 거주지 조회
 * @author shlee0815
 */

@Controller
@RequestMapping(value="/EmpAddressSrch.do", method=RequestMethod.POST )
public class EmpAddressSrchController extends ComController {

    /**
     * 임직원 거주지 조회 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewEmpAddressSrch", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewEmpAddressSrch() throws Exception {
        return "hrm/other/empAddressSrch/empAddressSrch";
    }

    /**
     * 임직원 Timeline 조회 > 임직원 목록 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getEmpTimelineSrchEmpList", method = RequestMethod.POST )
    public ModelAndView getEmpTimelineSrchEmpList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        return getDataList(session, request, paramMap);
    }

    /**
     * 임직원 Timeline 조회 > Timeline 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getAppmtTimelineSrchTimelineList", method = RequestMethod.POST )
    public ModelAndView getAppmtTimelineSrchTimelineList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        return getDataList(session, request, paramMap);
    }

    /**
     * 임직원 거주지 조회 > 임직원 주소 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getEmpAddressSrchAddressList", method = RequestMethod.POST )
    public ModelAndView getEmpAddressSrchAddressList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        return getDataList(session, request, paramMap);
    }

}




