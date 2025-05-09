package com.hr.hrm.psnalInfo.psnalNojoUpload;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/PsnalNojoUpload.do", method=RequestMethod.POST )
public class PsnalNojoUploadController {

    @Autowired
    private PsnalNojoUploadService psnalNojoUploadService;

    @RequestMapping(params="cmd=viewPsnalNojoUpload", method = {RequestMethod.POST, RequestMethod.GET} )
    public String viewPsnalNojoUpload() throws Exception {
        return "hrm/psnalInfo/psnalNojoUpload/psnalNojoUpload";
    }

    @RequestMapping(params="cmd=getPsnalNojoUploadList", method = RequestMethod.POST )
    public ModelAndView getPsnalNojoUploadList(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        if(!paramMap.get("multiNojoPositionCd").toString().isEmpty())
            paramMap.put( "multiNojoPositionCd", ((String) paramMap.get("multiNojoPositionCd")).split(","));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = psnalNojoUploadService.getPsnalNojoUploadList(paramMap);
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

    @RequestMapping(params="cmd=savePsnalNojoUpload", method = RequestMethod.POST )
    public ModelAndView savePsnalNojoUpload(
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
            resultCnt = psnalNojoUploadService.savePsnalNojoUpload(convertMap);
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
