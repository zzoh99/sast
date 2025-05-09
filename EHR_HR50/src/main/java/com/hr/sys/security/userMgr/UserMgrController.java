package com.hr.sys.security.userMgr;

import com.hr.common.exception.HrException;
import com.hr.common.logger.Log;
import com.hr.common.util.MaskingUtil;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 사용자 관리
 * 
 * @author ParkMoohun
 *
 */
@Controller
@RequestMapping(value="/UserMgr.do", method=RequestMethod.POST )
public class UserMgrController {

	@Inject
	@Named("UserMgrService")
	private UserMgrService userMgrService;

	/**
	 * @param paramMap
	 * @param request
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewUserMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewUserMgr(
			@RequestParam Map<String, Object> paramMap,
			HttpServletRequest request) throws Exception {
		Log.DebugStart();
		Log.DebugEnd();
		return "sys/security/userMgr/userMgr";
	}

	@RequestMapping(params="cmd=getUserMgrList", method = RequestMethod.POST )
	public ModelAndView getUserMgrList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap)throws HrException {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		List<?> result = new ArrayList<Object>();
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		try{
			result = userMgrService.getUserMgrList(paramMap);
			mv.addObject("DATA", result);
		}catch(Exception e){
			mv.addObject("DATA", "");
			mv.addObject("Code", "-1");
			mv.addObject("Message", "데이터 조회에 실패하였습니다.");
		}	
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=setUserMgrPwdInit", method = RequestMethod.POST )
	public ModelAndView userMgrPwdInit(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		
		//Map<?, ?> newPwd = userMgrService.pwdRandom(paramMap);
		Map<?, ?> newPwd = userMgrService.pwd7Jumin(paramMap);
		Log.Debug("newPwd=> "+ MaskingUtil.pwd((String) newPwd.get("nPwd")));
		paramMap.put("newPwd",newPwd.get("nPwd"));
		
		int	result = -1;
		Map<String, Object> resultMap= new HashMap<String, Object>();
		String message = "";
		try{
			result = userMgrService.setUserMgrPwdInit(paramMap);
			if (result > 0) { message="패스워드가 초기화 되었습니다."; } 
			else { message="패스워드 초기화에 실패하였습니다."; }
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
			//resultMap.put("nenwPwd", 	newPwd.get("encPwd").toString());
			session.setAttribute("ssnNewPwd", newPwd.get("encPwd")); 
		}catch(Exception e){
			resultMap.put("Code", 		-1);
			resultMap.put("Message", 	"패스워드 초기화에 실패하였습니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", resultMap); 
		
		Log.DebugEnd();
		return mv;
	}
	
	@RequestMapping(params="cmd=saveUserMgr", method = RequestMethod.POST )
	public ModelAndView saveUserMgr(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws HrException {
		Log.DebugStart();
		//List result = sysPwrSchViewService.getPwrSch(paramMap);
		// 열로 된 데이터들을 Map 형태의 연관된 데이터 셋으로 만들기 위해 
		// 같이 묶여질 param명을 ,구분자 포함하여 만든다.
		Map<String, Object> convertMap = ParamUtils.requestInParamsMultiDML(request,paramMap.get("s_SAVENAME").toString(),"");
		convertMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		convertMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		int	result = -1;
		Map<String, Object> resultMap= new HashMap<String, Object>();
		String message = "";
		try{
			result = userMgrService.saveUserMgr(convertMap);
			if (result > 0) { message="저장 되었습니다."; } 
			else { message="저장 실퍠 하였습니다."; }
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
		}catch(Exception e){
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
		}
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		
		Log.Debug("Result Message : " + mv);
		Log.DebugEnd();
		return mv;
	}
	
	
	
	@RequestMapping(params="cmd=userTheme", method = RequestMethod.POST )
	public ModelAndView userTheme(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		int	result = -1;
		Map<String, Object> resultMap= new HashMap<String, Object>();
		String message = "";
		try{
			result = userMgrService.userTheme(paramMap);
			if (result > 0) { message="테마 적용 되었습니다."; } 
			else { message="테마 적용에 실패하였습니다."; }
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
		}catch(Exception e){
			resultMap.put("Code", 		-1);
			resultMap.put("Message", 	"테마 적용에 실패하였습니다.");
		}
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		
		session.removeAttribute("theme"); 		session.setAttribute("theme", paramMap.get("subThemeType"));
		session.removeAttribute("wfont"); 		session.setAttribute("wfont", paramMap.get("subFontType"));
		session.removeAttribute("maintype"); 	session.setAttribute("maintype", paramMap.get("subMainType"));

		Log.Debug("│ theme:" + session.getAttribute("theme"));
		Log.Debug("│ wfont:" + session.getAttribute("wfont"));
		Log.Debug("│ maintype:" + session.getAttribute("maintype"));
		
		Log.DebugEnd();
		return mv;
	}
		
	

	/*
	 * 패스워드 확인
	 */
	@RequestMapping(params="cmd=pwdConfirm", method = RequestMethod.POST )
	public ModelAndView pwdConfirm(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		List<?> result = userMgrService.pwdConfirm(paramMap);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", result);
		return mv;
	}
	
	/*
	 * 패스워드 변경 
	 */
	@RequestMapping(params="cmd=pwdChfirm", method = RequestMethod.POST )
	public ModelAndView pwdChfirm(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		int	result = -1;
		Map<String, Object> resultMap= new HashMap<String, Object>();
		String message = "";
		try{
			result = userMgrService.pwdChfirm(paramMap);
			if (result > 0) { message="비밀번호가 변경 되었습니다."; } 
			else { message="비밀번호가 변경에 실패하였습니다."; }
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
		}catch(Exception e){
			resultMap.put("Code", 		-1);
			resultMap.put("Message", 	"비밀번호가 변경에 실패하였습니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("" +
				"", result);
		return mv;
	}	
	
	
	/*
	 * 패스워드 Level
	 */
	@RequestMapping(params="cmd=pwdLevel", method = RequestMethod.POST )
	public ModelAndView pwdLevel(
			HttpSession session,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		paramMap.put("ssnEnterCd", 	session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", 	session.getAttribute("ssnSabun"));
		
		String strPwd = paramMap.get("newPwd").toString();
	    int s = 0;
	    int b = 0;
	    int n = 0;
	    int returnSum = 0;
	    char[] imsi = strPwd.toCharArray();

	    //한글자씩 루프를 돌려서
		for(int i=0;i<=strPwd.length()-1;i++){

			//대문자이면
			if(Character.isUpperCase(imsi[i]))
			b++;
			//소문자는
			else if(Character.isLowerCase(imsi[i]))
			s++;
			// 숫자나 특문인 경우는
			else if(Character.isDigit(imsi[i] )){
				n++;
			}
		}
		
		if(b>0) returnSum = returnSum + 15000;
		if(s>0) returnSum = returnSum + 15000;
		if(n>0) returnSum = returnSum + 15000;
	
		Map<?, ?> result = userMgrService.pwdLevel(paramMap);
		returnSum  = returnSum   + Integer.parseInt( (String) result.get("cnt") );
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result", returnSum);
		return mv;
	}	
	
	/**
	 * 다운로드 비밀번호 초기화
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=setUserMgrDownloadPwdInit", method = RequestMethod.POST )
	public ModelAndView userMgrDownloadPwdInit(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();
		paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
		paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));
		
		
		//Map<?, ?> newPwd = userMgrService.pwdRandom(paramMap);
		Map<?, ?> newPwd = userMgrService.pwd7Jumin(paramMap);
		Log.Debug("newPwd => " + newPwd.get("nPwd"));
		paramMap.put("newPwd", newPwd.get("nPwd"));
		
		int	result = -1;
		Map<String, Object> resultMap= new HashMap<String, Object>();
		String message = "";
		try{
			result = userMgrService.setUserMgrDownloadPwdInit(paramMap);
			if (result > 0) { message="다운로드 패스워드가 초기화 되었습니다."; } 
			else { message="다운로드 패스워드 초기화에 실패하였습니다."; }
			resultMap.put("Code", 		result);
			resultMap.put("Message", 	message);
			//resultMap.put("nenwPwd", 	newPwd.get("encPwd").toString());
			session.setAttribute("ssnNewPwd", newPwd.get("encPwd")); 
		}catch(Exception e){
			resultMap.put("Code", 		-1);
			resultMap.put("Message", 	"다운로드 패스워드 초기화에 실패하였습니다.");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("map", resultMap); 
		
		Log.DebugEnd();
		return mv;
	}
}