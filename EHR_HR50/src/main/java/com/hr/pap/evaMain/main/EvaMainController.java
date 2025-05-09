package com.hr.pap.evaMain.main;

import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import com.hr.common.util.CryptoUtil;
import com.hr.common.util.ParamUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
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
@SuppressWarnings("unchecked")
@RequestMapping(value="/EvaMain.do", method=RequestMethod.POST )
public class EvaMainController {

    @Autowired
    private EvaMainService evaMainService;

    @Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;

    @Autowired
    private SecurityMgrService securityMgrService;

    @Value("${rd.image.base.url}")
    private String imageBaseUrl;

    @RequestMapping(params="cmd=viewEvaMain", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewEvaMain(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        return "pap/evaMain/main/evaMain";
    }

    // 목표등록 master
    @RequestMapping(params="cmd=viewGoalRegLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewGoalRegLayer(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        return "pap/evaMain/main/goalRegLayer";
    }

    // 업적목표등록 TAB
    @RequestMapping(params="cmd=viewEvaMboReg", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView viewEvaMboReg(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("pap/evaMain/tab/mbo/evaMboReg");
        mv.addObject("param", paramMap);

        return mv;
    }

    // 역량목표등록 TAB
    @RequestMapping(params="cmd=viewEvaMboCompReg", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView viewEvaMboCompReg(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("pap/evaMain/tab/mbo/evaMboCompReg");
        mv.addObject("param", paramMap);

        return mv;
    }

    // 목표진행이력 TAB
    @RequestMapping(params="cmd=viewReferGoalSta", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewReferGoalSta(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        return "pap/evaMain/refer/referGoalSta";
    }

    // 목표승인 master
    @RequestMapping(params="cmd=viewGoalAprLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewGoalAprLayer(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        return "pap/evaMain/main/goalAprLayer";
    }

    // 면담내역 TAB
    @RequestMapping(params="cmd=viewReferIntvHst", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewReferIntvHst(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        return "pap/evaMain/refer/referIntvHst";
    }

    // Coaching Layer
    @RequestMapping(params="cmd=viewCoachingLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewCoachingLayer(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        return "pap/evaMain/coaching/coachingLayer";
    }

    // 본인 평가 Layer
    @RequestMapping(params="cmd=viewSelfAprLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewSelfAprLayer(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        return "pap/evaMain/main/selfAprLayer";
    }

    // 업무목표평가 TAB
    @RequestMapping(params="cmd=viewEvaMboApr", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView viewEvaMboApr(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("pap/evaMain/tab/mbo/evaMboApr");
        mv.addObject("param", paramMap);
        return mv;
    }

    // 역량목표평가 TAB
    @RequestMapping(params="cmd=viewEvaMboCompApr", method = {RequestMethod.POST, RequestMethod.GET} )
    public ModelAndView viewEvaMboCompApr(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("pap/evaMain/tab/mbo/evaMboCompApr");
        mv.addObject("param", paramMap);
        return mv;
    }

    // 평가 master
    @RequestMapping(params="cmd=viewEvaAprLayer", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewEvaAprLayer(
            HttpSession session, HttpServletRequest request, @RequestParam Map<String, Object> paramMap) throws Exception {
        return "pap/evaMain/main/evaAprLayer";
    }

    // 평가Intro Main 목표 등록 카드 조회
    @RequestMapping(params="cmd=getGoalCardList", method = RequestMethod.POST )
    public ModelAndView getGoalCardList(HttpSession session, @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        List<?> list = new ArrayList<Object>();
        String Message = "";
        try {
            list = evaMainService.getGoalCardList(paramMap);
        } catch(Exception e){
            Message="조회에 실패하였습니다";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 평가Intro Main 목표 승인 카드 조회
     */
    @RequestMapping(params="cmd=getGoalAprCardList", method = RequestMethod.POST )
    public ModelAndView getGoalAprCardList(HttpSession session, @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        List<?> list = new ArrayList<Object>();
        String Message = "";
        try {
            list = evaMainService.getGoalAprCardList(paramMap);
        } catch(Exception e){
            Message="조회에 실패하였습니다";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 평가Intro Main 평가 카드 조회
     */
    @RequestMapping(params="cmd=getAprCardList", method = RequestMethod.POST )
    public ModelAndView getAprCardList(HttpSession session, @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        List<?> list = new ArrayList<Object>();
        String Message = "";
        try {
            list = evaMainService.getAprCardList(paramMap);
        } catch(Exception e){
            Message="조회에 실패하였습니다";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 평가Intro Main Coaching 카드 조회
     */
    @RequestMapping(params="cmd=getCoachCardList", method = RequestMethod.POST )
    public ModelAndView getCoachCardList(HttpSession session, @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        List<?> list = new ArrayList<Object>();
        String Message = "";
        try {
            list = evaMainService.getCoachCardList(paramMap);
        } catch(Exception e){
            Message="조회에 실패하였습니다";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 평가대상자 기본사항 조회
     */
    @RequestMapping(params="cmd=getAppSabunMap", method = RequestMethod.POST )
    public ModelAndView getAppSabunMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        String Message = "";
        Map<?, ?> map = null;

        try{
            map = evaMainService.getAppSabunMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA",map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    /**
     * 목표등록,중간점검등록 다건 조회(의견조회)
     */
    @RequestMapping(params="cmd=getEvaGoalCommentRegList", method = RequestMethod.POST )
    public ModelAndView getEvaGoalCommentRegList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        List<?> list  = new ArrayList<Object>();
        String Message = "";
        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        try{
            list = evaMainService.getEvaGoalCommentRegList(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 최종평가 평가자 리스트 조회
     */
    @RequestMapping(params="cmd=getAppSabunList", method = RequestMethod.POST )
    public ModelAndView getAppSabunList(HttpSession session, @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        List<?> list = new ArrayList<Object>();
        String Message = "";
        try {
            list = evaMainService.getAppSabunList(paramMap);
        } catch(Exception e){
            Message="조회에 실패하였습니다";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 등급별 목표 수준 조회
     */
    @RequestMapping(params="cmd=getEvaMboRegList2", method = RequestMethod.POST )
    public ModelAndView getEvaMboRegList2(HttpSession session, @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        List<?> list = new ArrayList<Object>();
        String Message = "";
        try {
            list = evaMainService.getEvaMboRegList2(paramMap);
        } catch(Exception e){
            Message="조회에 실패하였습니다";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 목표등록,중간점검등록 등급별 목표수준 저장
     */
    @RequestMapping(params="cmd=saveEvaMboReg", method = RequestMethod.POST )
    public ModelAndView saveEvaMboReg(
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
            resultCnt =evaMainService.saveEvaMboReg(convertMap);
            if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
     * 최종평가 평가대상자 조회
     */
    @RequestMapping(params="cmd=getEvaAprList", method = RequestMethod.POST )
    public ModelAndView getEvaAprList(HttpSession session, @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        List<?> list = new ArrayList<Object>();
        String Message = "";
        try {
            list = evaMainService.getEvaAprList(paramMap);
        } catch(Exception e){
            Message="조회에 실패하였습니다";
        }
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", list);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }

    /**
     * 최종평가 - 업적 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveMboApr", method = RequestMethod.POST )
    public ModelAndView saveMboApr(
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
            resultCnt =evaMainService.saveMboApr(convertMap);
            if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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

    @RequestMapping(params="cmd=saveMboAprGradeCd", method = RequestMethod.POST )
    public ModelAndView saveMboAprGradeCd(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =evaMainService.saveMboAprGradeCd(paramMap);
            if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
     * 최종평가 - 역량 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveMboCompApr", method = RequestMethod.POST )
    public ModelAndView saveMboCompApr(
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
            resultCnt =evaMainService.saveMboCompApr(convertMap);
            if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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


    @RequestMapping(params="cmd=saveMboCompAprGradeCd", method = RequestMethod.POST )
    public ModelAndView saveMboCompAprGradeCd(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =evaMainService.saveMboCompAprGradeCd(paramMap);
            if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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
     * 역량, 업적 등급 조회
     */
    @RequestMapping(params="cmd=getEvaAprGradeCdMap", method = RequestMethod.POST )
    public ModelAndView getEvaAprGradeCdMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));

        String Message = "";
        Map<?, ?> map = null;

        try{
            map = evaMainService.getEvaAprGradeCdMap(paramMap);
        }catch(Exception e){
            Message="조회에 실패하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA",map);
        mv.addObject("Message", Message);

        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=saveEvaAprGradeCd", method = RequestMethod.POST )
    public ModelAndView saveEvaAprGradeCd(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt =evaMainService.saveEvaAprGradeCd(paramMap);
            if(resultCnt > 0){ message="저장되었습니다."; } else{ message="저장된 내용이 없습니다."; }
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

    // RD 데이터 암호화
    @RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
    public ModelAndView getEncryptRd(
            HttpSession session, HttpServletRequest request
            , @RequestBody Map<String, Object> paramMap) throws Exception{
        Log.DebugStart();

        String mrdPath = paramMap.get("rdMrd").toString();
        String param = "/rp " + paramMap.get("parameters");

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        try {
            mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
            mv.addObject("Message", "");
        } catch (Exception e) {
            mv.addObject("Message", "암호화에 실패했습니다.");
        }

        Log.DebugEnd();
        return mv;
    }
}
