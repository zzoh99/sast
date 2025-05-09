package com.hr.cpn.perExpense.inOutOrgMgr;
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


import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 전출입관리 Controller
 *
 * @author EW
 *
 */
@Controller
@RequestMapping(value="/InOutOrgMgr.do", method=RequestMethod.POST )
public class InOutOrgMgrController {
    /**
     * 전출입관리 서비스
     */
    @Inject
    @Named("InOutOrgMgrService")
    private InOutOrgMgrService inOutOrgMgrService;

    /**
     * 전출입관리 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewInOutOrgMgr", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewInOutOrgMgr() throws Exception {
        return "cpn/perExpense/inOutOrgMgr/inOutOrgMgr";
    }

    /**
     * 전출입관리 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewInOutOrgMgrTab1", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewInOutOrgMgrTab1() throws Exception {
        return "cpn/perExpense/inOutOrgMgr/inOutOrgMgrTab1";
    }

    /**
     * 전출입관리 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewInOutOrgMgrTab2", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewInOutOrgMgrTab2() throws Exception {
        return "cpn/perExpense/inOutOrgMgr/inOutOrgMgrTab2";
    }

    /**
     * 전출입관리(세부내역) 팝업 View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewInOutOrgMgrPop", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewInOutOrgMgrPop() throws Exception {
        return "cpn/perExpense/inOutOrgMgr/inOutOrgMgrPop";
    }

    /**
     * 전출입관리 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getInOutOrgMgrTab1List", method = RequestMethod.POST )
    public ModelAndView getInOutOrgMgrTab1List(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = inOutOrgMgrService.getInOutOrgMgrTab1List(paramMap);
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
     * 전출입관리 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getInOutOrgMgrTab2List", method = RequestMethod.POST )
    public ModelAndView getInOutOrgMgrTab2List(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = inOutOrgMgrService.getInOutOrgMgrTab2List(paramMap);
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
     * 전출입관리 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveInOutOrgMgr", method = RequestMethod.POST )
    public ModelAndView saveInOutOrgMgr(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =inOutOrgMgrService.saveInOutOrgMgr(convertMap);
            if(resultCnt > 0){ message="저장 되었습니다."; } else{ message="저장된 내용이 없습니다."; }
        }catch(Exception e){
            resultCnt = -1; message="저장에 실패하였습니다.";
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
     * 전출입관리 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getInOutOrgMgrMap", method = RequestMethod.POST )
    public ModelAndView getInOutOrgMgrMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = inOutOrgMgrService.getInOutOrgMgrMap(paramMap);
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
     * 전출입관리 인터페이스ID 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getInOutOrgMgrITFIDMap", method = RequestMethod.POST )
    public ModelAndView getInOutOrgMgrITFIDMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = inOutOrgMgrService.getInOutOrgMgrITFIDMap(paramMap);
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
     * 전출입관리 프로시저
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=inOutOrgMgrPrc1", method = RequestMethod.POST )
    public ModelAndView inOutOrgMgrPrc1(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
        paramMap.put("ssnSearchType",session.getAttribute("ssnSearchType"));
        paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));

        Map<String, Object> map = new HashMap<String, Object>();
        try {
            map = (Map<String, Object>) inOutOrgMgrService.inOutOrgMgrPrc1(paramMap);
        } catch(Exception e) {
            map.put("sqlCode", "-1");
            map.put("sqlErrm", "대상자생성에 실패하였습니다.");
            Log.Error("전출입관리 대상자생성 중 오류 발생 >> " + e.getMessage());
        }

        Log.Debug("obj : "+map);
        Log.Debug("sqlCode : "+map.get("sqlCode"));
        Log.Debug("sqlErrm : "+map.get("sqlErrm"));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (map.get("sqlCode") != null) {
            resultMap.put("Code", map.get("sqlCode").toString());
        } else {
            resultMap.put("Code", "");
        }
        if (map.get("sqlErrm") != null) {
            resultMap.put("Message", map.get("sqlErrm").toString());
        } else {
            resultMap.put("Message", "");
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);

        Log.DebugEnd();
        return mv;
    }

    /**
     * 전출입관리 프로시저
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=inOutOrgMgrPrc2", method = RequestMethod.POST )
    public ModelAndView inOutOrgMgrPrc2(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
        paramMap.put("ssnSearchType",session.getAttribute("ssnSearchType"));
        paramMap.put("ssnGrpCd",session.getAttribute("ssnGrpCd"));

        Map<?, ?> map  = inOutOrgMgrService.inOutOrgMgrPrc2(paramMap);

        Log.Debug("obj : "+map);
        Log.Debug("sqlCode : "+map.get("sqlCode"));
        Log.Debug("sqlErrm : "+map.get("sqlErrm"));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (map.get("sqlCode") != null) {
            resultMap.put("Code", map.get("sqlCode").toString());
        } else {
            resultMap.put("Code", "");
        }
        if (map.get("sqlErrm") != null) {
            resultMap.put("Message", map.get("sqlErrm").toString());
        } else {
            resultMap.put("Message", "");
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);

        Log.DebugEnd();
        return mv;
    }
}
