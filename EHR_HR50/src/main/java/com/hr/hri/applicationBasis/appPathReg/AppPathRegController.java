package com.hr.hri.applicationBasis.appPathReg;

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
import com.hr.common.util.ParamUtils;
import com.hr.common.code.CommonCodeService;
import com.hr.common.logger.Log;

/**
 * 개인 신청 결재
 *
 * @author ParkMoohun
 */
@Controller
@RequestMapping(value="/AppPathReg.do", method=RequestMethod.POST )
public class AppPathRegController {

	@Inject
	@Named("AppPathRegService")
	private AppPathRegService appPathRegService;

	@Inject
	@Named("CommonCodeService")
	private CommonCodeService commonCodeService;
	/**
	 * 개인 신청 결재 화면
	 *
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewAppPathReg", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewAppPathReg(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.Debug("AppPathRegController.viewAppPathReg");
		return "hri/applicationBasis/appPathReg/appPathReg";
	}

	/**
	 * 개인 신청 결재 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPathRegList", method = RequestMethod.POST )
	public ModelAndView getAppPathRegList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		List<?> result = new ArrayList();
		String Message = "";
		try{
			result = appPathRegService.getAppPathRegList(paramMap);
		}catch(Exception e){
			Message="결재선 조회에 실패하였습니다!";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 개인 신청 결재 결재자 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPathOrgList", method = RequestMethod.POST )
	public ModelAndView getAppPathOrgList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		List<?> result = new ArrayList();
		String Message = "";
		try{
			result = appPathRegService.getAppPathOrgList(paramMap);
		}catch(Exception e){
			Message="부서 조회에 실패하였습니다!";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 개인 신청 결재 결재자 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPathRegOrgUserList", method = RequestMethod.POST )
	public ModelAndView getAppPathRegOrgUserList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> result = new ArrayList();
		String Message = "";
		try{
			result = appPathRegService.getAppPathRegOrgUserList(paramMap);
		}catch(Exception e){
			Message="사원 조회에 실패하였습니다!";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}


	/**
	 * 사원 리스트 조회(Token 발생)
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getOrgUserTokenList", method = RequestMethod.POST )
	public ModelAndView getOrgUserTokenList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> result = new ArrayList();
		String Message = "";
		try{
			result = appPathRegService.getOrgUserTokenList(paramMap);
		}catch(Exception e){
			Message="사원 조회에 실패하였습니다!";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인 신청 결재 결재자 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPathRegApplList", method = RequestMethod.POST )
	public ModelAndView getAppPathRegApplList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> result = new ArrayList();
		String Message = "";
		try{
			result = appPathRegService.getAppPathRegApplList(paramMap);
		}catch(Exception e){
			Message="결재자 조회에 실패하였습니다!";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 개인 신청 결재 참조자 리스트 조회
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getAppPathRegReferList", method = RequestMethod.POST )
	public ModelAndView getAppPathRegReferList(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		List<?> result = new ArrayList();
		String Message = "";
		try{
			result = appPathRegService.getAppPathRegReferList(paramMap);
		}catch(Exception e){
			Message="수신참조자 조회에 실패하였습니다!";
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", result);
		mv.addObject("Message", Message);
		Log.DebugEnd();
		return mv;
	}
	/**
	 * 개인 신청 결재 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppPathReg", method = RequestMethod.POST )
	public ModelAndView saveAppPathReg(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		String ssnSabun = session.getAttribute("ssnSabun").toString();
		convertMap.put("ssnSabun", ssnSabun);
		convertMap.put("ssnEnterCd", ssnEnterCd);
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) { Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,ssnEnterCd);
    			dupMap.put("SABUN"		,ssnSabun);
    			dupMap.put("PATH_SEQ"	,"99999999");
    			dupMap.put("PATH_NM"	,mp.get("pathNm"));
    			dupList.add(dupMap);
    		}
    		try{ cnt = commonCodeService.getDupCnt("THRI104", "ENTER_CD,SABUN,PATH_SEQ,PATH_NM", "s,s,i,s",dupList);
	    		if(cnt > 0 ) cnt = -1; message="중복된 값이 존재합니다.";
    		}catch(Exception e){ cnt = -1; message="중복 체크에 실패하였습니다."; }
		}
		if(cnt == 0){
			try{ cnt = appPathRegService.saveAppPathReg(convertMap);
				if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
			}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		}
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인 신청 결재 경로 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppPathRegAppl", method = RequestMethod.POST )
	public ModelAndView saveAppPathRegAppl(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		String ssnSabun = session.getAttribute("ssnSabun").toString();
		convertMap.put("ssnSabun", ssnSabun);
		convertMap.put("ssnEnterCd", ssnEnterCd);
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) { Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,ssnEnterCd);
    			dupMap.put("SABUN"		,ssnSabun);
    			dupMap.put("PATH_SEQ"	,mp.get("pathSeq"));
    			dupMap.put("AGREE_SABUN",mp.get("agreeSabun"));
    			dupList.add(dupMap);
    		}
    		try{ cnt = commonCodeService.getDupCnt("THRI105", "ENTER_CD,SABUN,PATH_SEQ,AGREE_SABUN", "s,s,i,s",dupList);
	    		if(cnt > 0 ) cnt = -1; message="중복된 값이 존재합니다.";
    		}catch(Exception e){ cnt = -1; message="중복 체크에 실패하였습니다."; }
		}
		if(cnt == 0){
			try{ cnt = appPathRegService.saveAppPathRegAppl(convertMap);
				if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
			}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		}
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	/**
	 * 개인 신청 결재 참조자 저장
	 *
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=saveAppPathRegRefer", method = RequestMethod.POST )
	public ModelAndView saveAppPathRegRefer(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		String ssnEnterCd = session.getAttribute("ssnEnterCd").toString();
		String ssnSabun = session.getAttribute("ssnSabun").toString();
		convertMap.put("ssnSabun", ssnSabun);
		convertMap.put("ssnEnterCd", ssnEnterCd);
		String message = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map> insertList = (List<Map>)convertMap.get("insertRows");
		List<Map<String,Object>> dupList = new ArrayList<Map<String,Object>>();
		int cnt = 0;
		if(insertList.size()>0){
    		for(Map<String,Object> mp : insertList) { Map<String,Object> dupMap = new HashMap<String,Object>();
    			dupMap.put("ENTER_CD"	,ssnEnterCd);
    			dupMap.put("SABUN"		,ssnSabun);
    			dupMap.put("PATH_SEQ"	,mp.get("pathSeq"));
    			dupMap.put("CC_SABUN",	mp.get("ccSabun"));
    			dupList.add(dupMap);
    		}
    		try{ cnt = commonCodeService.getDupCnt("THRI127", "ENTER_CD,SABUN,PATH_SEQ,CC_SABUN", "s,s,i,s",dupList);
	    		if(cnt > 0 ) cnt = -1; message="중복된 값이 존재합니다.";
    		}catch(Exception e){ cnt = -1; message="중복 체크에 실패하였습니다."; }
		}
		if(cnt == 0){
			try{ cnt = appPathRegService.saveAppPathRegRefer(convertMap);
				if (cnt > 0) { message="저장되었습니다."; }  else { message="저장된 내용이 없습니다."; }
			}catch(Exception e){ cnt=-1; message="저장 실패하였습니다."; }
		}
		resultMap.put("Code", 		cnt); resultMap.put("Message", 	message);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView"); mv.addObject("Result", resultMap);
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}

	@RequestMapping(params="cmd=getChar", method = RequestMethod.POST )
	public ModelAndView getChar(HttpSession session,
			HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		List<?> result = appPathRegService.getChar(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("char", result);
		Log.DebugEnd();
		return mv;
	}


//	private String growth_market_yn;
//
//	@javax.persistence.Column(name = "GROWTH_MARKET_YN", columnDefinition = "char")
//	public void getGrowth_market_yn(String growth_market_yn){
//		this.growth_market_yn = growth_market_yn;
//	}

}