package com.hr.cpn.payApp.deptPartPayApp;
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
import com.hr.common.language.Language;


/**
 * 수당지급신청 Controller
 *
 * @author YSH
 *
 */
@Controller
@RequestMapping(value="/DeptPartPayApp.do", method=RequestMethod.POST )
public class DeptPartPayAppController {

	/**
	 * 수당지급신청 서비스
	 */
	@Inject
	@Named("DeptPartPayAppService")
	private DeptPartPayAppService deptPartPayAppService;

	/**
	 * 다국어처리 서비스
	 */
	@Inject
	@Named("Language")
	private	Language language;

	/**
	 *  수당지급신청  삭제
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=deleteDeptPartPayApp", method = RequestMethod.POST )
	public ModelAndView deleteDeptPartPayAppEx(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = deptPartPayAppService.deleteDeptPartPayApp(convertMap);
			if(resultCnt > 0){ message= language.getMessage("msg.alertSaveOk", null, "자료가 저장되었습니다.."); } else{ message= language.getMessage("msg.alertNoSaveData", null,"저장할 자료가 없습니다."); }
		}catch(Exception e){
			resultCnt = -1; message= language.getMessage("msg.alertSaveFail", null, "저장 중 오류가 발생하였습니다.");
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

    @RequestMapping(params="cmd=getDeptPartPayAppList", method = RequestMethod.POST )
    public ModelAndView getDeptPartPayAppList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = deptPartPayAppService.getDeptPartPayAppList(paramMap);
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

    @RequestMapping(params="cmd=getDeptPartPayAppDetailList", method = RequestMethod.POST )
    public ModelAndView getDeptPartPayAppDetailList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = deptPartPayAppService.getDeptPartPayAppDetailList(paramMap);
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
