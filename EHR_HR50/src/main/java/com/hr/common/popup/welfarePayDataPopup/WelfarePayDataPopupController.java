package com.hr.common.popup.welfarePayDataPopup;
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
import com.hr.common.code.CommonCodeService;
/**
 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/WelfarePayDataPopup.do", method=RequestMethod.POST )
public class WelfarePayDataPopupController {
	/**
	 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 서비스
	 */
	@Inject
	@Named("WelfarePayDataPopupService")
	private WelfarePayDataPopupService welfarePayDataPopupService;
	
	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	
	
	/**
	 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=welfarePayDataPopup", method = RequestMethod.POST )
	public String viewWelfarePayDataPopup() throws Exception {
		return "common/popup/welfarePayDataPopup";
	}
	/**
	 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWelfarePayDataPopupList", method = RequestMethod.POST )
	public ModelAndView getWelfarePayDataPopupList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		try{
			list = welfarePayDataPopupService.getWelfarePayDataPopupList(paramMap);
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
	 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getWelfarePayDataPopupMap", method = RequestMethod.POST )
	public ModelAndView getWelfarePayDataPopupMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = welfarePayDataPopupService.getWelfarePayDataPopupMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 의료비 / 학자금 / 사내여직원 / 이주비 마감 팝업 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveWelfarePayDataPopup", method = RequestMethod.POST )
	public ModelAndView saveWelfarePayDataPopup(
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
			resultCnt =welfarePayDataPopupService.saveWelfarePayDataPopup(convertMap);
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
	
}
