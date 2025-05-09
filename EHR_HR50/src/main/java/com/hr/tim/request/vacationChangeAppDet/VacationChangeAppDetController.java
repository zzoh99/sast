package com.hr.tim.request.vacationChangeAppDet;
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
import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;

/**
 * 근태취소신청 세부내역 Controller
 *
 * @author bckim
 *
 */
@Controller
@RequestMapping({"/VacationChangeApp.do","/VacationChangeAppDet.do", "/VacationApp.do"})
public class VacationChangeAppDetController extends ComController {

	/**
	 * 근태취소신청 세부내역 서비스
	 */
	@Inject
	@Named("VacationChangeAppDetService")
	private VacationChangeAppDetService vacationChangeAppDetService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	/**
	 * 근태취소신청 세부내역 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewVacationChangeAppDet", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewVacationChangeAppDet() throws Exception {
		return "tim/request/vacationChangeAppDet/vacationChangeAppDet";
	}


	/**
	 * 근태취소신청 세부내역 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getVacationChangeAppDetMap", method = RequestMethod.POST )
	public ModelAndView getVacationChangeAppDetMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataMap(session, request, paramMap);
	}

	/**
	 * 근태취소신청 세부내역 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveVacationChangeAppDet", method = RequestMethod.POST )
	public ModelAndView saveVacationChangeAppDet(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String getParamNames ="sNo,sStatus,gntCd,sabun,applSeq,vacationYmd";
		
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,getParamNames,"");
		
		convertMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		convertMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		convertMap.put("holDay",paramMap.get("holDay"));
		convertMap.put("reqSHm",paramMap.get("reqSHm"));
		convertMap.put("reqEHm",paramMap.get("reqEHm"));


		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = vacationChangeAppDetService.saveVacationChangeAppDet(paramMap);
			
			if(resultCnt > 0) {
				//대체휴가일자 delete, insert
				resultCnt = vacationChangeAppDetService.deleteVacationChangeAppDetList(paramMap);
				resultCnt = vacationChangeAppDetService.insertVacationChangeAppDetList(convertMap);
			}
			
			if(resultCnt > 0){ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveOkV1", null, "저장 되었습니다."); } else{ message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveNoData", null, "저장된 내용이 없습니다."); }
			
		}catch(Exception e){
			
			resultCnt = -1; message=com.hr.common.language.LanguageUtil.getMessage("msg.alertSaveFail2", null, "저장에 실패하였습니다.");
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

    @RequestMapping(params="cmd=getVacationChangeAppDetChangeList", method = RequestMethod.POST )
    public ModelAndView getVacationChangeAppDetChangeList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = vacationChangeAppDetService.getVacationChangeAppDetChangeList(paramMap);
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

    @RequestMapping(params="cmd=getVacationChangeAppDetList", method = RequestMethod.POST )
    public ModelAndView getVacationChangeAppDetList(
            HttpSession session,  HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
        paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));

        List<?> list  = new ArrayList<Object>();
        String Message = "";
        try{
            list = vacationChangeAppDetService.getVacationChangeAppDetList(paramMap);
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

    @RequestMapping(params="cmd=getVacationChangeAppCheck", method = RequestMethod.POST )
    public ModelAndView getVacationChangeAppCheck(
            HttpSession session, HttpServletRequest request,
            @RequestParam Map<String, Object> paramMap ) throws Exception {
        Log.DebugStart();

        Map<?, ?> map = null;
        String Message = "";

        try{
            map = vacationChangeAppDetService.getVacationChangeAppCheck(paramMap);
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
}
