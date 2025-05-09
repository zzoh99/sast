package com.hr.main.login;

import java.security.PrivateKey;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComService;
import com.hr.common.logger.Log;
import com.hr.common.util.RSA;
import com.hr.sys.security.userMgr.UserMgrService;

/**
 *  로그인
 *
 * @author ParkMoohun
 *
 */
@Controller

public class LoginControllerPlugin {

	@Inject
	@Named("LoginService")
	private LoginService loginService;

	@Inject
	@Named("ComService")
	private	ComService	comService;

	
	@Inject
	@Named("UserMgrService")
	private UserMgrService userMgrService;




	//@Autowired
	//private CommonMailController commonMailController;


	/*
	 * 패스워드 변경
	 */
	@RequestMapping(value="/pwdChg.do", method=RequestMethod.POST )
	public ModelAndView pwdChg(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap) throws Exception {
		Log.DebugStart();

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		if( session.getAttribute("ssnLoginSabun") == null && session.getAttribute("ssnSabun") == null ){
			Log.Debug("pwdChg() -- 잘못된 접근 입니다. ssnLoginUserId = null");
			mv.addObject("result", "fail");

			Log.DebugEnd();
			return mv;
		}

		if( session.getAttribute("ssnLoginSabun") != null){
			paramMap.put("ssnEnterCd", session.getAttribute("ssnLoginEnterCd"));
			paramMap.put("ssnSabun", session.getAttribute("ssnLoginSabun"));
		}else{
			paramMap.put("ssnEnterCd", session.getAttribute("ssnEnterCd"));
			paramMap.put("ssnSabun", session.getAttribute("ssnSabun"));

		}

		try{
			
			String type = (String) paramMap.get("type");

			//현재 비밀번호가 맞는지 확인
			List<?> pwdConLst = userMgrService.pwdConfirm(paramMap);
			Map pwdConMap = (Map)(pwdConLst.get(0));



            int pwdConCnt = Integer.parseInt(pwdConMap.get("cnt") == null ? "" : String.valueOf(pwdConMap.get("cnt"))); //현재 비밀번호 확인 여부
            Log.Debug("pwdChg() --  pwdConCnt : "+ pwdConCnt);

            if( pwdConCnt < 1 ){

    			mv.addObject("result", "notMatch");
    			Log.DebugEnd();
    			return mv;
            }

			//비밀번호 보안 체크
            Map<String, Object> pwdCheckMap = (Map<String, Object>)userMgrService.pwdCheck(paramMap);
            Log.Debug("pwdChg() --  pwdCheckMap : "+ pwdCheckMap);

			if( pwdCheckMap != null ){
				String pwdCheckResult = (String)pwdCheckMap.get("pwdCheck");
				if( pwdCheckResult != null && !pwdCheckResult.equals("") ){

					mv.addObject("result", pwdCheckResult );
	    			Log.DebugEnd();
	    			return mv;
				}
			}

        	//비밀번호 변경
			int result = userMgrService.pwdChfirm(paramMap);
			if (result > 0) {
				
				// 다운로드 비밀번호 변경인 경우
				if( !StringUtils.isBlank(type) && "download".equals(type) ) {
					// 세션에 담긴 다운로드 비밀번호 변경
					if( session.getAttribute("ssnFileDownPwd") != null){
						session.setAttribute("ssnFileDownPwd", (String) paramMap.get("newPwd"));
					}
				} else {
					//다시 로그인 해야 하므로 세션 값을 지움.
					if( session.getAttribute("ssnLoginUserId") != null){
						session.invalidate();
					}
				}
				
				mv.addObject("result", "success");

			}else{

    			mv.addObject("result", "fail");
			}



		}catch(Exception e){
			Log.Debug("pwdChg() -- "+ e.getMessage());
			mv.addObject("result", "fail");
		}


		Log.DebugEnd();
		return mv;
	}
	

	/**
	 * 사용언어 조회
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	/*
	@RequestMapping(value="/langSelect.do", method=RequestMethod.POST )
	public ModelAndView langSelect(HttpSession session,HttpServletRequest request ,
						@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		String enterCd = paramMap.get("enterCd")==null ? "": paramMap.get("enterCd").toString();
		paramMap.put("ssnEnterCd",  enterCd.equals("") ? session.getAttribute("ssnEnterCd") : enterCd);
		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		List<?> result = comService.getComQueryList(paramMap, "getLocaleList");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("list", result);
		Log.DebugEnd();
		return mv;
	}
	
	*/


}
