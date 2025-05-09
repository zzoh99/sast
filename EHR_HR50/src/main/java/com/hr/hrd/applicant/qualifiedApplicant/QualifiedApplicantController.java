package com.hr.hrd.applicant.qualifiedApplicant;

import com.hr.common.code.CommonCodeService;
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
import java.util.*;

/**
 * 근무조관리 Controller 
 *
 * @author jcy
 *
 */
@Controller
@RequestMapping(value="/QualifiedApplicant.do", method=RequestMethod.POST )
public class QualifiedApplicantController {
    /**
     * 근무조관리 서비스
     */
    @Inject
    @Named("QualifiedApplicantService")
    private QualifiedApplicantService qualifiedApplicantService;

    @Inject
    @Named("CommonCodeService")
    private CommonCodeService commonCodeService;

    /**
     * workGrpMgr View
     *
     * @return String
     * @throws Exception
     */
    @RequestMapping(params="cmd=viewQualifiedApplicant", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewSelfDevelopmentEducationConnect() throws Exception {
        return "hrd/applicant/qualifiedApplicant/qualifiedApplicant";
    }

    @RequestMapping(params="cmd=getJobCatCodeList", method = RequestMethod.POST )
    public ModelAndView getJobCatCodeList(HttpSession session, HttpServletRequest request,@RequestParam Map<String, Object> paramMap) throws Exception {
        Log.DebugStart();

        List<?> result = qualifiedApplicantService.getJobCatCodeList(paramMap);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("codeList", result);
        Log.DebugEnd();
        return mv;
    }

    @RequestMapping(params="cmd=getQualifiedApplicantList", method = RequestMethod.POST )
    public ModelAndView getQualifiedApplicantList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list   = new ArrayList<Object>();
        List<?> listITK = new ArrayList<Object>();

        List<?> listOC = new ArrayList<Object>();
        List<?> listITKOC = new ArrayList<Object>();


        List<?> listFinal   = new ArrayList<Object>();

        String Message = "";

        String getParamNames  = "sNo,sDelete,sStatus,workAssignNmLarge,workAssignNmMiddle,workAssignCd,minTerm";
        String getParamNames2 = "sNo2,sDelete2,sStatus2,gubun,categoryCd,categoryNm,knowledgeCd,knowledgeNm,knowledgeType,techBizType,finalGrade";
//		sNo,sDelete,sStatus,workAssignNmLarge,workAssignNmMiddle,workAssignCd,minTerm
//

        Map<String, Object> convertMap  = ParamUtils.requestInParamsMultiDML(request,getParamNames  ,"");
        Map<String, Object> convertMap2 = ParamUtils.requestInParamsMultiDML2(request,getParamNames2,"");

        if (paramMap.get("searchChartType").toString().equals("ALL") || paramMap.get("searchChartType").toString().equals("APP")) {
            try {
                list = qualifiedApplicantService.getQualifiedApplicantList(convertMap);
            } catch (Exception e) {
                Message = "조회에 실패 하였습니다.";
            }


            try{
                listITK = qualifiedApplicantService.getQualifiedITKList(convertMap2);
            }catch(Exception e){
                Message="조회에 실패 하였습니다.";
            }
        }

        if (paramMap.get("searchChartType").toString().equals("ALL") || paramMap.get("searchChartType").toString().equals("REG")) {
            try {
                listOC = qualifiedApplicantService.getQualifiedApplicantOCList(convertMap);
            } catch (Exception e) {
                Message = "조회에 실패 하였습니다.";
            }

            try{
                listITKOC = qualifiedApplicantService.getQualifiedITKOCList(convertMap2);
            }catch(Exception e){
                Message="조회에 실패 하였습니다.";
            }
        }

        String qryStr1 = "";
        String qryStr2 = "";
        String qryStr3 = "";
        String qryStr4 = "";

        for (int i = 0; i < list.size() ; i++) {
            Map map = (Map) list.get(i);
            qryStr1 += "'"+map.get("sabun").toString()+"',";
        }

        for (int i = 0; i < listITK.size() ; i++) {
            Map map = (Map) listITK.get(i);
            qryStr2 += "'"+map.get("sabun").toString()+"',";
        }

        for (int i = 0; i < listOC.size() ; i++) {
        	Map map = (Map) listOC.get(i);
        	qryStr3 += "'"+map.get("sabun").toString()+"',";
        }

        for (int i = 0; i < listITKOC.size() ; i++) {
            Map map = (Map) listITKOC.get(i);
            qryStr4 += "'"+map.get("sabun").toString()+"',";
        }

        if (list.size()      > 0) paramMap.put("qrySabun1", qryStr1.substring(0, qryStr1.length()-1));
        if (listITK.size()   > 0) paramMap.put("qrySabun2", qryStr2.substring(0, qryStr2.length()-1));
        if (listOC.size()    > 0) paramMap.put("qrySabun3", qryStr3.substring(0, qryStr3.length()-1));
        if (listITKOC.size() > 0) paramMap.put("qrySabun4", qryStr4.substring(0, qryStr4.length()-1));


        try{
            listFinal = qualifiedApplicantService.getQualifiedApplicantFinalList(paramMap);
        }catch(Exception e){
            Message="조회에 실패 하였습니다.";
        }

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        mv.addObject("DATA", listFinal);
        mv.addObject("Message", Message);
        Log.DebugEnd();
        return mv;
    }


    // 승인 or 반려
    @RequestMapping(params="cmd=saveEducationYn", method = RequestMethod.POST )
    public ModelAndView saveEducationYn(HttpSession session,  HttpServletRequest request,@RequestParam Map<String, Object> paramMap ) throws Exception {
        // comment 시작
        Log.DebugStart();

        Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
        convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
        convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

        String message = "";
        int resultCnt = -1;
        try{
            resultCnt = qualifiedApplicantService.saveEducationYn(convertMap);
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
}
