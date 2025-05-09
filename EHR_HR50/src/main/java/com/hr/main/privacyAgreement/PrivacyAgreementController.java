package com.hr.main.privacyAgreement;
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
 * 메뉴명 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/PrivacyAgreement.do", method=RequestMethod.POST ) 
public class PrivacyAgreementController {
	/**
	 * 메뉴명 서비스
	 */
	@Inject
	@Named("PrivacyAgreementService")
	private PrivacyAgreementService privacyAgreementMaster;
	
	/**
	 * 개인정보 보호법 팝업 미리보기 
	 * 
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewPrivacyAgreementPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public ModelAndView viewPrivacyAgreement3(HttpSession session,
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugEnd();
		return new ModelAndView("common/popup/privacyAgreementPopup");
	}
	/**
	 * 개인정보보호법동의 내용 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPrivacyAgreementList", method = RequestMethod.POST )
	public ModelAndView getPrivacyAgreementList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnSabun", session.getAttribute("ssnLoginSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnLoginEnterCd"));
		try{
			list = privacyAgreementMaster.getPrivacyAgreementList(paramMap);
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
	 * 개인정보보호법동의 내용 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getPrivacyAgreementList2", method = RequestMethod.POST )
	public ModelAndView getPrivacyAgreementList2(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = privacyAgreementMaster.getPrivacyAgreementList(paramMap);
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
	 * 개인정보보호법동의 저장
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=insertPrivacyAgreement", method = RequestMethod.POST )
	public ModelAndView insertPrivacyAgreement(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnSabun", session.getAttribute("ssnLoginSabun"));
		convertMap.put("ssnEnterCd", session.getAttribute("ssnLoginEnterCd"));
		
		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = privacyAgreementMaster.insertPrivacyAgreement(convertMap);
			if(resultCnt > 0){ message="생성 되었습니다."; } else{ message="생성된 내용이 없습니다."; }
		}catch(Exception e){
			resultCnt = -1; message="생성에 실패하였습니다.";
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
