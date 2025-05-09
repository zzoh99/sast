package com.hr.hrd.incoming.incomingMgr;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hr.common.rd.EncryptRdService;
import com.hr.common.security.SecurityMgrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;
/**
 * 후임자관리 Controller
 *
 * @author
 *
 */
@Controller
@RequestMapping(value="/IncomingMgr.do", method=RequestMethod.POST )
public class IncomingMgrController {
	/**
	 * 후임자관리 서비스
	 */
	@Inject
	@Named("IncomingMgrService")
	private IncomingMgrService incomingMgrService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;

	@Inject
	@Named("EncryptRdService")
	private EncryptRdService encryptRdService;

	@Autowired
	private SecurityMgrService securityMgrService;

	@Value("${rd.image.base.url}")
	private String imageBaseUrl;

	/**
	 *  후임자관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIncomingMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewIncomingMgr() throws Exception {
		return "hrd/incoming/incomingMgr/incomingMgr";
	}

	/**
	 *  후임자관리 Popup View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewIncomingMgrPopup", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewIncomingMgrPopup() throws Exception {
		return "hrd/incoming/incomingMgr/incomingMgrPopup";
	}

	@RequestMapping(params="cmd=viewIncomingMgrLayer", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewIncomingMgrLayer() throws Exception {
		return "hrd/incoming/incomingMgr/incomingMgrLayer";
	}

	/**
	 * 후임자관리 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getIncomingMgrList", method = RequestMethod.POST )
	public ModelAndView getIncomingMgrList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = incomingMgrService.getIncomingMgrList(paramMap);
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
	 * 후임자관리 Popup 인사정보 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getIncomingMgrPopupHrInfoMap", method = RequestMethod.POST )
	public ModelAndView getIncomingMgrPopupHrInfoMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = incomingMgrService.getIncomingMgrPopupHrInfoMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 후임자관리 Popup 인사정보-학력 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getIncomingMgrPopupHrInfoSchList", method = RequestMethod.POST )
	public ModelAndView getIncomingMgrPopupHrInfoSchList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		List<?> list  = new ArrayList<Object>();
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		try{
			list = incomingMgrService.getIncomingMgrPopupHrInfoSchList(paramMap);
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
	 * 후임자관리 Popup 평가결과 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getIncomingMgrPopupEvalResultList", method = RequestMethod.POST )
	public ModelAndView getIncomingMgrPopupEvalResultList(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<Serializable> titles = new ArrayList<Serializable>();
		List<?> list  = new ArrayList<Object>();		
		String Message = "";
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		for(int i=9; i>=0; i--) {
			titles.add(i);
			paramMap.put("titles", titles);	
		}
		
		try{
			list = incomingMgrService.getIncomingMgrPopupEvalResultList(paramMap);
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
	 * 후임자관리 Popup 평판 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getIncomingMgrPopupReputationMap", method = RequestMethod.POST )
	public ModelAndView getIncomingMgrPopupReputationMap(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));
		Map<?, ?> map = incomingMgrService.getIncomingMgrPopupReputationMap(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", map);
		Log.DebugEnd();
		return mv;
	}
	
	/**
	 * 후임자관리 팝업 평판 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveIncomingMgrPopup", method = RequestMethod.POST )
	public ModelAndView saveIncomingMgrPopup(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();

		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		String message = "";
		int resultCnt = -1;
		try{
			resultCnt = incomingMgrService.saveIncomingMgrPopup(paramMap);
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

	@RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
	public ModelAndView getEncryptRd(
			HttpSession session, HttpServletRequest request
			, @RequestBody Map<String, Object> paramMap) throws Exception{
		Log.DebugStart();
		String mrdPath = "/hrd/incoming/IncomingMgr.mrd";
		String enterCd = String.valueOf(session.getAttribute("ssnEnterCd"));

		String param = "/rp"
				+ " ['" + enterCd + "']"
				+ " " + paramMap.get("parameters")
				+ " [" + imageBaseUrl + "]";

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
