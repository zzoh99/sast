package com.hr.cpn.payBonus.bonusUpload;

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
 *  bonusUpload Controller
 */
@Controller
@RequestMapping(value="/BonusUpload.do", method=RequestMethod.POST )
public class BonusUploadController {

    /**
     * bonusUpload 서비스
     */
    @Inject
    @Named("BonusUploadService")
    private BonusUploadService bonusUploadService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    /**
     * bonusUpload View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewBonusUpload", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewbonusUpload() throws Exception {
        return "cpn/payBonus/bonusUpload/bonusUpload";
    }

    /**
     * bonusUpload 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusUploadList", method = RequestMethod.POST )
    public ModelAndView getbonusUploadList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = bonusUploadService.getBonusUploadList(paramMap);
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
     * bonusUpload 다건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusUploadDetailList", method = RequestMethod.POST )
    public ModelAndView getbonusUploadDetailList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",    session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = bonusUploadService.getBonusUploadDetailList(paramMap);
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
     * bonusUpload 저장
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=saveBonusUpload", method = RequestMethod.POST )
    public ModelAndView saveBonusUpload(
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
            resultCnt =bonusUploadService.saveBonusUpload(convertMap);
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
     * bonusUpload 단건 조회
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=getBonusUploadMap", method = RequestMethod.POST )
    public ModelAndView getbonusUploadMap(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = bonusUploadService.getBonusUploadMap(paramMap);
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
     * BonusUpload 대상자생성 프로시저
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=callP_CPN_BONUS_Upload_EMP_CRE", method = RequestMethod.POST )
    public ModelAndView callP_CPN_BONUS_Upload_EMP_CRE(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
        paramMap.put("searchYear",request.getParameter("searchYear"));
        paramMap.put("searchBonusGrp",request.getParameter("searchBonusGrp"));
        
        Map<?, ?> map  = bonusUploadService.callP_CPN_BONUS_Upload_EMP_CRE(paramMap);

        Log.Debug("obj : "+map);
        Log.Debug("sqlCode : "+map.get("sqlCode"));
        Log.Debug("sqlErrm : "+map.get("sqlErrm"));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (map.get("sqlCode") != null) {
            resultMap.put("Code", map.get("sqlCode").toString());
        }
        if (map.get("sqlErrm") != null) {
            resultMap.put("Message", map.get("sqlErrm").toString());
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        
        Log.DebugEnd();
        return mv;
    }
    

    /**
     * BonusUpload 배분실행 프로시저
     *
     * @param session
     * @param request
     * @param paramMap
     * @return ModelAndView
     * @throws Exception
     */
    @RequestMapping(params="cmd=callP_CPN_BONUS_Upload_MON_CRE", method = RequestMethod.POST )
    public ModelAndView callP_CPN_BONUS_Upload_MON_CRE(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();
        paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun",session.getAttribute("ssnSabun"));
        paramMap.put("searchYear",request.getParameter("searchYear"));
        paramMap.put("searchBonusGrp",request.getParameter("searchBonusGrp"));
        
        Map<?, ?> map  = bonusUploadService.callP_CPN_BONUS_Upload_MON_CRE(paramMap);

        Log.Debug("obj : "+map);
        Log.Debug("sqlCode : "+map.get("sqlCode"));
        Log.Debug("sqlErrm : "+map.get("sqlErrm"));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (map.get("sqlCode") != null) {
            resultMap.put("Code", map.get("sqlCode").toString());
        }
        if (map.get("sqlErrm") != null) {
            resultMap.put("Message", map.get("sqlErrm").toString());
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("Result", resultMap);
        
        Log.DebugEnd();
        return mv;
    }   
}
