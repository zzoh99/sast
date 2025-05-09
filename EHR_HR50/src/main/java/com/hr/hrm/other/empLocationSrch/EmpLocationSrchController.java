package com.hr.hrm.other.empLocationSrch;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * 임직원 Location 현황
 * @author shlee0815
 */

@Controller
@RequestMapping(value="/EmpLocationSrch.do", method=RequestMethod.POST )
public class EmpLocationSrchController extends ComController {

    /**
     * 임직원 Location 현황 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewEmpLocationSrch", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewEmpLocationSrch() throws Exception {
        return "hrm/other/empLocationSrch/empLocationSrch";
    }

    /**
     * Location code, name 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getLocationCdNm", method = RequestMethod.POST )
    public ModelAndView getLocationCdNm(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        return getDataList(session, request, paramMap);
    }


    /**
     * Location별 임직원정보 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getLocationEmpInfo", method = RequestMethod.POST )
    public ModelAndView getLocationEmpInfo(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        return getDataList(session, request, paramMap);
    }

    /**
     * 마커 클러스터에 사용할 데이터 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getMapClusterData", method = RequestMethod.POST )
    public ModelAndView getMapClusterData(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();
        return getDataList(session, request, paramMap);
    }

}
